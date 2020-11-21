import uuid
import os
from flask import Flask, request, render_template, session

app = Flask(__name__)

@app.route('/')
def index():        
    if 'id' not in session:
        session['id'] = str(uuid.uuid4())
        
    return render_template('index.html', sessid=session['id'])

if __name__ == '__main__':
    app.secret_key = os.urandom(32)
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8000)))
