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
