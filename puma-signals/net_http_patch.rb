# disable retries in case of Timeout Error
# this patch required until PR will be merged
# https://github.com/ruby/ruby/pull/1654
module Net   #:nodoc:
  class HTTP

    private

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
        D "Conn close because of error #{exception}"
        @socket.close if @socket
        raise
      end

      end_transport req, res
      res
    rescue => exception
      D "Conn close because of error #{exception}"
      @socket.close if @socket
      raise exception
    end
  end
end