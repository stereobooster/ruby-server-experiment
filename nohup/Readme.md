https://github.com/puma/puma/issues/1202

```bash
vagrant ssh # or any other ssh to linux box
nohup ruby test.rb &
# nohup: ignoring input and appending output to 'nohup.out'
exit
cat nohup.out
HUP # nohup sends HUP signal when parent process (ssh session) closed
```
