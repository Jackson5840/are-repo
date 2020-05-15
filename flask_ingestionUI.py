import mysql.connector
import numpy as np
from flask import Flask
from flask import jsonify
from flask_cors import CORS, cross_origin
from flask import request
import json, requests, os
from copy import deepcopy
import datetime
from sqlalchemy import DateTime
from flask_sqlalchemy import SQLAlchemy
from are import ingest
from are import io
import redis
import time
#from IngestApp import Ingestion


app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = "postgresql://nmo:100neuralDB@localhost:5432/nmo"
db = SQLAlchemy(app)
r = redis.Redis(host='localhost', port=6379, db=0)



class IngestionModel(db.Model):
    __tablename__ = 'ingestion'

    id = db.Column(db.Integer, primary_key=True)
    neuron_name = db.Column(db.String())
    archive = db.Column(db.String())
    neuron_id = db.Column(db.Integer())
    ingestion_date = db.Column(DateTime, default=datetime.datetime.now())
    status = db.Column(db.Integer())
    warnings = db.Column(db.String())
    errors = db.Column(db.String())
    premessage = db.Column(db.String())


    def __init__(self, name, model, doors):
        self.name = name
        self.model = model
        self.doors = doors

    def __repr__(self):
        return f"<Ingestion {self.name}>"

@app.route('/', methods=['GET'])
def get():
    return "Ingestion app is up!"

@app.route('/getstatus/<string:archive>', methods=['GET'])
def getstatus(archive):
    status = {'done': float(r.get(archive))}
    return jsonify(status)

@app.route('/setstatus/', methods=['POST'])
def setstatus():
    payloadData = request.get_json()
    neuron_name = payloadData['archive']
    toset = payloadData['status']
    r.set(archive,toset)
    return 'status set'

@app.route('/getdm/', methods=['GET'])
def getdm():
    with open('datamodel.json') as json_file:
        data = json.load(json_file)
    return {'data': data}

@app.route('/getarchives/', methods=['GET'])
def getarchives():
    archivelist = io.getarchivecsv()
    return {'data': archivelist}


@app.route('/readarchive/<string:archive>', methods=['GET'])
def readarchive(archive):
    result = io.getfiles(archive)
    return result

@app.route('/getui',  methods=['GET'])
def getui():
    ingestionData = IngestionModel.query.all()
    results = [
        {   
            "neuron_name":row.neuron_name,
            "archive": row.archive,
            "neuron_id": row.neuron_id,
            "ingestion_date": row.ingestion_date,
            "status":row.status,
            "warnings": row.warnings,
            "errors": row.errors,
            "premessage": row.premessage
        } for row in ingestionData]

    return {"count": len(results), "data": results}

@app.route('/ingestneuron/<string:neuron_name>',  methods=['GET'])
def ingestneuron(neuron_name):
    neuronResults = ingest.ingestneuron(neuron_name)
    return neuronResults

@app.route('/ingestarchive',  methods=['POST'])
def ingestarchive():
    payloaddata = request.get_json()
    archive = payloaddata['archive']
    results = ingest.ingestarchive(archive)
    io.exportneurons()
    r.set(archive, 0)
    return {"data" : results}

