**BusyBox Blue-Green Deployment Demo**

This project demonstrates a Blue-Green Deployment setup using Docker and BusyBox containers.
It runs a simple web server using netcat (nc) to serve static HTML pages with different background colors.

Blue Deployment → Uses the public BusyBox image (busybox:latest)
Green Deployment → Uses the Cleanstart BusyBox image (cleanstart/busybox:latest-dev)
Project Structure


Dockerfile.v1      # Blue Deployment (public BusyBox)
Dockerfile.v2      # Green Deployment (Cleanstart BusyBox)
index.html         # HTML page (Blue or Green content)
server.sh          # Simple web server using netcat


**How It Works:**

Each container serves a static HTML page via a custom shell script (server.sh).
The HTML file (index.html) defines the background color and message:
Blue → Public BusyBox
Green → Cleanstart BusyBox
The container listens on port 8080 and responds with the HTML page.

**Building the Images**

Blue Deployment (Public BusyBox)
```bash
docker build -t busybox-blue -f Dockerfile.v1 .
```

Green Deployment (Cleanstart BusyBox)
```bash
docker build -t busybox-green -f Dockerfile.v2 .
```

**Running the Containers**

Blue Deployment
```bash
docker run -d -p 8080:8080 busybox-blue
```

Visit: http://localhost:8080

You should see a blue page with the message:
"Hello from Public BusyBox - BLUE Deployment!"

**Green Deployment**
```bash
docker run -d -p 8080:8080 busybox-green
```

Visit: http://localhost:8080

You should see a green page with the message:
"Hello from Cleanstart BusyBox - GREEN Deployment!"

Blue-Green Deployment Concept
Blue Deployment = Current running version (stable).
Green Deployment = New version (tested before switching traffic).


**List running containers:**

```bash
docker ps -a
```

**Stop a container:**

```bash
docker stop <container_id>
```

**Summary:**
Blue Deployment (Public BusyBox) → Blue background page
Green Deployment (Cleanstart BusyBox) → Green background page

This simple setup shows how Blue-Green deployments work using Docker and BusyBox.