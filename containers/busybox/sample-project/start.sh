# #!/bin/sh
# echo "🚀 Cleanstart BusyBox started as user: $(whoami)"
# echo "📦 BusyBox version: $(busybox | head -n 1)"

# # heartbeat logs every 5 sec
# while true; do
#   echo "⏳ Busybox is a combination of UNIX utilities and is a single binary! $(date)"
#   sleep 5
# done
#!/bin/sh
echo "🚀 Cleanstart BusyBox started as user: $(whoami)"
echo "📦 BusyBox version: $(busybox | head -n 1)"

#!/bin/sh
echo "🚀 Starting BusyBox HTTP server..."
exec busybox httpd -f -v -p 8080 -h /www


# heartbeat logs every 5 sec
while true; do
  echo "⏳ Busybox is serving files at http://localhost:8080 $(date)"
  sleep 5
done
