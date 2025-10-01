# Python Flask CRUD Applications

**App1 runs on python:3.11**
**App2 runs on cleanstart/python:latest-dev**

Same application is Dockerised to show the migration functionality of open source image and Cleanstart image.

**Features:**

```bash
Add new users with name and email.
Update existing user information.
Delete users from the database.
```

SQLite database automatically created on app startup.

**Directory Structure:**
```bash
Copy code
├── app1.py                  # Flask app 1
├── app2.py                  # Flask app 2
├── requirements.txt         # Python dependencies
├── Dockerfile.v1            # Dockerfile for app1
├── Dockerfile.v2            # Dockerfile for app2
└── models/
    ├── __init__.py
    ├── database.py          # Database creation and setup
    └── user.py              # User model and CRUD operations
```

Building Docker Images
App1
```bash
docker build -t python-app1 -f Dockerfile.v1 .
```

**Run command:**
```bash
docker run -d -p 5000:5000 --name app1-container python-app1
```

Access the App1 here : http://localhost:5000/

App2
```bash
docker build -t python-app2 -f Dockerfile.v2 .
```

Run command:

```bash
docker run -d -p 5001:5001 --name app2-container python-app2
```

Access the App2 here : http://localhost:5001/


### App1
- **Image:** `python-app1`
- **Port:** `5000`

###App2
- **Image:** `python-app2`
- **Port:** `5001`


**Notes:**
The applications use Flask as the web framework and SQLite as the database.

Ports 5000 and 5001 can be adjusted if needed.
