FROM cleanstart/python:latest-dev

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

# Only pass the script, base Entrypoint is already /usr/bin/python
CMD ["app.py"]
