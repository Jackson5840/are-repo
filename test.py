from flask import Flask,jsonify
from are import com
app = Flask(__name__)

@app.route('/')
def ingest():
    s= {'status': 'success'}
    try:
        print(com.insert('publication',{'pmid': 111111211}))
        print(com.insertneuron('test212e23'))
    except Exception as e:
        s['status'] = 'error'
        s['message'] = str(e)
        print(s)
    return jsonify(s)


