FROM cleanstart/memcached:latest-dev
 
WORKDIR /app
 
COPY . .
 
CMD ["memcached", "-m", "128", "-p", "11211", "-u", "memcache", "-l", "0.0.0.0", "-vv"]