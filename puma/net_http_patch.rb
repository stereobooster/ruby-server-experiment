# disable retries in case of Timeout Error
# this patch required until PR will be merged
# https://github.com/ruby/ruby/pull/1654

module Net   #:nodoc:
  class HTTP
    # Creates a new Net::HTTP object for the specified server address,
    # without opening the TCP connection or initializing the HTTP session.
    # The +address+ should be a DNS hostname or IP address.
    def initialize(address, port = nil)
      @address = address
      @port    = (port || HTTP.default_port)
      @local_host = nil
      @local_port = nil
      @curr_http_version = HTTPVersion
      @keep_alive_timeout = 2
      @last_communicated = nil
      @close_on_empty_response = false
      @socket  = nil
      @started = false
      @open_timeout = 60
      @read_timeout = 60
      @continue_timeout = nil
      @max_retries = 1
      @debug_output = nil

      @proxy_from_env = false
      @proxy_uri      = nil
      @proxy_address  = nil
      @proxy_port     = nil
      @proxy_user     = nil
      @proxy_pass     = nil

      @use_ssl = false
      @ssl_context = nil
      @ssl_session = nil
      @sspi_enabled = false
      SSL_IVNAMES.each do |ivname|
        instance_variable_set ivname, nil
      end
    end

    # Maximum number of times to retry an idempotent request in case of
    # Net::ReadTimeout, IOError, EOFError, Errno::ECONNRESET,
    # Errno::ECONNABORTED, Errno::EPIPE, OpenSSL::SSL, Timeout::Error
    # Should be non-negative integer number. Zero means no retries.
    # The default value is 1.
    def max_retries=(retries)
      if !retries.is_a?(Integer) || retries < 0
        raise ArgumentError, 'max_retries should be non-negative integer number'
      end
      @max_retries = retries
    end

    attr_reader :max_retries

    # ruby 2.4
    # def transport_request(req)
    #   count = 0
    #   begin
    #     begin_transport req
    #     res = catch(:response) {
    #       req.exec @socket, @curr_http_version, edit_path(req.path)
    #       begin
    #         res = HTTPResponse.read_new(@socket)
    #         res.decode_content = req.decode_content
    #       end while res.kind_of?(HTTPInformation)

    #       res.uri = req.uri

    #       res
    #     }
    #     res.reading_body(@socket, req.response_body_permitted?) {
    #       yield res if block_given?
    #     }
    #   rescue Net::OpenTimeout
    #     raise
    #   rescue Net::ReadTimeout, IOError, EOFError,
    #          Errno::ECONNRESET, Errno::ECONNABORTED, Errno::EPIPE,
    #          # avoid a dependency on OpenSSL
    #          defined?(OpenSSL::SSL) ? OpenSSL::SSL::SSLError : IOError,
    #          Timeout::Error => exception
    #     if count < max_retries && IDEMPOTENT_METHODS_.include?(req.method)
    #       count += 1
    #       @socket.close if @socket
    #       D "Conn close because of error #{exception}, and retry"
    #       retry
    #     end
    #     D "Conn close because of error #{exception}"
    #     @socket.close if @socket
    #     raise
    #   end

    #   end_transport req, res
    #   res
    # rescue => exception
    #   D "Conn close because of error #{exception}"
    #   @socket.close if @socket
    #   raise exception
    # end

    # ruby 2.3
    def transport_request(req)
      count = 0
      begin
        begin_transport req
        res = catch(:response) {
          req.exec @socket, @curr_http_version, edit_path(req.path)
          begin
            res = HTTPResponse.read_new(@socket)
            res.decode_content = req.decode_content
          end while res.kind_of?(HTTPInformation)

          res.uri = req.uri

          res
        }
        res.reading_body(@socket, req.response_body_permitted?) {
          yield res if block_given?
        }
      rescue Net::OpenTimeout
        raise
      rescue Net::ReadTimeout, IOError, EOFError,
             Errno::ECONNRESET, Errno::ECONNABORTED, Errno::EPIPE,
             # avoid a dependency on OpenSSL
             defined?(OpenSSL::SSL) ? OpenSSL::SSL::SSLError : IOError,
             Timeout::Error => exception
        if count < max_retries && IDEMPOTENT_METHODS_.include?(req.method)
          count += 1
          @socket.close if @socket and not @socket.closed?
          D "Conn close because of error #{exception}, and retry"
          retry
        end
        D "Conn close because of error #{exception}"
        @socket.close if @socket and not @socket.closed?
        raise
      end

      end_transport req, res
      res
    rescue => exception
      D "Conn close because of error #{exception}"
      @socket.close if @socket and not @socket.closed?
      raise exception
    end
  end
end
