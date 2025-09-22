#!/bin/sh
echo "Starting demo server..."

while true; do
  {
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n"
    echo "<h1>Hello from Stakater Demo!</h1>"
    echo "<p>Config: $(cat /app/config.txt)</p>"
  } | nc -l -p 8080 -k
done
