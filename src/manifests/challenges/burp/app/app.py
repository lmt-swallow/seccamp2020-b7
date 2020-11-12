#!/usr/bin/python

import os
import glob
from flask import Flask, request, render_template

app = Flask(__name__)


@app.route('/')
def index():
    flag = None
    if request.headers.get('X-Gimme', '').lower() == 'flag':
        flag = 'seccamp{yay_you_are_master_of_burp_repeater}'

    return render_template('index.html', flag=flag)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
