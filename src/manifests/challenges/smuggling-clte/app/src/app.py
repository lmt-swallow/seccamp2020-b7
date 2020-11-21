from flask import Flask, abort, request

app = Flask(__name__)
app.config["MAX_CONTENT_LENGTH"] = 512

@app.route("/", methods=["POST"])
def post():
    return "Hello! Method: POST", 200

@app.route("/", methods=["GET"])
def hello():
    return "Hello! Method: GET", 200
