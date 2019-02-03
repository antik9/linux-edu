## Run playbook with vagrant
For correct work ensure you have empty 8080 port on your system.
<br />
Or replace port in Vagrantfile to empty one.

```
>>> vagrant up
>>> curl -i localhost:8080

HTTP/1.1 301 Moved Permanently
Server: nginx/1.12.2
Date: Sun, 03 Feb 2019 23:55:16 GMT
Content-Type: text/html
Content-Length: 185
Connection: keep-alive
Location: http://localhost:8080/cookie-setter

<html>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx/1.12.2</center>
</body>
</html>

>>> curl -i http://localhost:8080/cookie-setter

HTTP/1.1 301 Moved Permanently
Server: nginx/1.12.2
Date: Sun, 03 Feb 2019 23:56:31 GMT
Content-Type: text/html
Content-Length: 185
Connection: keep-alive
Location: http://localhost:8080
Set-Cookie: access_pass=jMsgll2Fbx0bAtZH55KMzvE1tXRUn6S5;Max-Age=60

<html>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx/1.12.2</center>
</body>
</html>

>>> curl -L -c cookie-jar http://localhost:8080

<!DOCTYPE html>
<html>
<head>
    <title>
        Index Page
    </title>
</head>
<body>
    <h2>
        Ansible task For nginx server
    </h2>
</html>
```
