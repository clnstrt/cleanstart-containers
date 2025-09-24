# #!/bin/sh

# while true; do
#   {
#     echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n
# <html>
# <head>
#   <title>Blue Deployment</title>
# </head>
# <body style='background-color:blue; color:white; text-align:center; padding-top:50px;'>
#   <h1>Hello from Public BusyBox - BLUE Deployment!</h1>
# </body>
# </html>";
#   } | nc -l -p 8080
# done


#!/bin/sh

while true; do
  {
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n
<html>
<head>
  <title>Green Deployment</title>
</head>
<body style='background-color:green; color:white; text-align:center; padding-top:50px;'>
  <h1>Hello from Cleanstart BusyBox - GREEN Deployment!</h1>
</body>
</html>";
  } | nc -l -p 8080
done
