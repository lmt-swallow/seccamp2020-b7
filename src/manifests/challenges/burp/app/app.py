#!/usr/bin/python

import os
import glob
from flask import Flask, jsonify, request, render_template, make_response

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
