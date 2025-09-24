**Python App Migration: Public Image → Cleanstart Image**
Overview:

**This project demonstrates migrating a Python application from a public Python Docker image (python:3.11) to a Cleanstart Python image (cleanstart/python:latest). The migration ensures identical functionality while leveraging Cleanstart’s optimized, secure, and preconfigured runtime.**

---Blue Deployment (Public Python Image)---

Create Dockerfile.v1 :

```bash
FROM python:3.11
WORKDIR /app1
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app1.py .
EXPOSE 5000
CMD ["python", "app1.py"]
```

Create app1.py :

```bash
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return """
    <html>
      <head><title>Blue Deployment</title></head>
      <body style="background-color:blue; color:white; text-align:center; padding-top:50px;">
        <h1>Hello from Python container - BLUE Deployment!</h1>
      </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```


Build & Run :

```bash
docker build -t my-python-app -f Dockerfile.v1 .
docker run -d -p 5000:5000 my-python-app
```

Test :

Open a browser and visit: http://localhost:5000

You should see the Blue Deployment page.



---Green Deployment (Cleanstart Python Image)---

Create Dockerfile.v2 :

```bash
FROM cleanstart/python:latest
WORKDIR /app2
COPY requirements.txt .
RUN ["python", "-m", "pip", "install", "--no-cache-dir", "-r", "requirements.txt"]
COPY app2.py .
EXPOSE 5000
CMD ["app2.py"]
```

Create app2.py :

```bash
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return """
    <html>
      <head><title>Green Deployment</title></head>
      <body style="background-color:green; color:white; text-align:center; padding-top:50px;">
        <h1>Hello from Nginx container - GREEN Deployment!</h1>
      </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

Build & Run :

```bash
docker build -t my-cleanstart-app .
docker run -d -p 5001:5000 my-cleanstart-app
```

Test :

Open a browser and visit: http://localhost:5001

You should see the Green Deployment page.

Migration Justification
Aspect	Public Python Image	Cleanstart Python Image	Benefit
Base image reliability	Official Python, widely used	Cleanstart, optimized and maintained	More secure and lightweight runtime
Preinstalled tooling	Python only	Python + preconfigured environment	Reduces repetitive setup steps
Security & compliance	Standard updates via Docker Hub	Hardened image with fewer vulnerabilities	Adheres to internal policies, reduces attack surface
Image size	~900 MB (full Python)	Typically smaller and optimized	Faster deployments, lower resource consumption
Consistency across projects	Varies by public image version	Controlled Cleanstart versions	Standardizes Python environment across projects
Entrypoint simplification	CMD python app.py	Python entrypoint included	Simplifies Dockerfile, avoids manual CMD
Migration validation	Baseline working app	Green deployment confirmed	Functionality remains identical while leveraging Cleanstart benefits
Migration Testing

Run both containers simultaneously:

curl http://localhost:5000  # Blue Deployment
curl http://localhost:5001  # Green Deployment


Verify identical functionality.

Confirms a successful migration from public Python image to Cleanstart Python image.

Summary

The migration demonstrates that Cleanstart Python images provide:

Smaller, optimized image size

Preinstalled and configured environment

Enhanced security and compliance

Standardized development environment

Functionality remains the same as the baseline public Python image deployment.