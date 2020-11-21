#!/usr/bin/python

import os
import glob
import random
from flask import Flask, request, render_template

app = Flask(__name__)

@app.route('/uranai')
def uranai():
    name = request.args.get('name', '')
    if name == '':
        return 'error', 400

    ua = request.headers.get('User-Agent', '')    
    unsei = random.choice(['最高', 'ふつう', '微妙'])
    return render_template('unsei.html', name=name, unsei=unsei, ua=ua)

@app.route('/')
def index():        
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8000)))
