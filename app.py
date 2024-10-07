import mysql.connector
import numpy as np
from flask import Flask, send_from_directory, jsonify, request
from flask_cors import CORS, cross_origin
import json, requests, os
from copy import deepcopy
import datetime
import redis
import time
import logging
from are import cfg,io,com,utils,ingest,ingestdiameter
#from IngestApp import Ingestion


app = Flask(__name__)
app.debug = True
CORS(app)
r = redis.Redis(host='localhost', port=6379, db=0)
logging.basicConfig(level=logging.INFO,filename='app.log', filemode='w', format='%(asctime)s %(name)-12s %(levelname)-8s %(message)s')


@app.route('/', methods=['GET'])
def get():
    return "Ingestion app is up!"

# Serve the UI index page
@app.route('/ui/')
def serve_ui_index():
    return send_from_directory(os.path.join(app.root_path, 'ui'), 'index.html')

# Serve UI static files (CSS, JS, images, etc.)
@app.route('/ui/<path:filename>')
def serve_ui_static(filename):
    return send_from_directory(os.path.join(app.root_path, 'ui'), filename)

@app.route('/diametercheck/<string:folder_name>',  methods=['GET'])
def diametercheck(folder_name):
    cfg.sshdir = cfg.sshreviewdir
    neuronResults = ingestdiameter.ingestarchive(folder_name)

    if any([neuronResults[item]['status'] == 'error' for item in neuronResults]):
        return {
            'data': ', '.join(['{}: {}'.format(item,neuronResults[item]['message']) for item in neuronResults if neuronResults[item]['status'] == 'error']),
            'status': 'error'
        }
    else:
        return {
            'data': 'Archive {} ingested'.format(folder_name),
            'status': 'success'
        }

@app.route('/checkgif/<string:archive>', methods=['GET'])
def checkgif(archive):
    
    status = r.get("{}_gif_status".format(archive))
    progress = r.get("{}_gif_progress".format(archive))
    
    if progress is None:
        progress = 0
    else:
        progress = float(progress)
    result = {
        'status': str(status),
        'progress': progress
    }
    logging.info("Result = {}".format(result))
    return result

@app.route('/setstatus/', methods=['POST'])
def setstatus():
    payloadData = request.get_json()
    neuron_name = payloadData['archive']
    toset = payloadData['status']
    r.set(archive,toset)
    return 'status set'

@app.route('/getarchives/', methods=['GET'])
def getarchives():
    result = io.getarchivecsv()
    return result

@app.route('/gifgen/<string:archive>', methods=['GET'])
def gifgen(archive):
    try:
        result = io.genarchivegifs(archive)
        logging.info("Result = {}".format(result))

    except Exception as identifier:
        pass    
    
    return result


@app.route('/readarchive/<string:archive>', methods=['GET'])
def readarchive(archive):
    result = io.getfiles(archive)
    return result


@app.route('/revertarchive/<string:archive>', methods=['GET'])
def revertarchive(archive):
    result = io.revertarchive(archive)
    return result

@app.route('/deleteneurons', methods=['POST'])
def deleteneurons():
    anarchive = request.get_json()
    neuronfolder = anarchive['name']
    for item in anarchive['neurons']:
        io.deleteneuron(item['neuron_name'])
    return io.revertarchive(neuronfolder)

@app.route('/archiveneurons', methods=['POST'])
def archiveneurons():
    anarchive = request.get_json()
    neuronfolder = anarchive['name']
    for item in anarchive['neurons']:
        com.archiveneuron(item['neuron_name'])
    com.deleteingestedarchive(neuronfolder)
    return {"status": "success"}


@app.route('/deingestarchive/<string:archive>', methods=['GET'])
def deingestarchive(archive):
    result = io.deingestarchive(archive)
    return result

@app.route('/genwinjsp/<string:archive>', methods=['GET'])
def genwinjsp(archive):
    try:
        now = datetime.datetime.now()
        dt_string = now.strftime("%Y-%m-%d")
        cfg.sshdir = cfg.sshreviewdir
        (version,nneurons) = io.genwinjsp(archive)
        io.writeendings(archive)
        #io.updateinforev(archive,version,dt_string)
        io.reviewworkflow()
        return {"status": "success"}
    except Exception as identifier:
        logging.exception("Error when generating win.jsp")
        return {"status": "error"}
    

@app.route('/ingestneuron/<string:neuron_name>',  methods=['GET'])
def ingestneuron(neuron_name):
    cfg.sshdir = cfg.sshreviewdir
    neuronResults = ingest.ingestneuron(neuron_name)
    return neuronResults

@app.route('/ingestarchive/<string:folder_name>',  methods=['GET'])
def ingestarchive(folder_name):
    cfg.sshdir = cfg.sshreviewdir
    neuronResults = ingest.ingestarchive(folder_name)
    if any([neuronResults[item]['status'] == 'error' for item in neuronResults]):
        return {
            'data': ', '.join(['{}: {}'.format(item,neuronResults[item]['message']) for item in neuronResults if neuronResults[item]['status'] == 'error']),
            'status': 'error'
        }
    else: 
        return {
            'data': 'Archive {} ingested'.format(folder_name),
            'status': 'success'
        }

@app.route('/deleteneuron/<string:neuron_name>',  methods=['GET'])
def deleteneuron(neuron_name):
    cfg.sshdir = cfg.sshreviewdir
    neuronResults = io.deleteneuron(neuron_name)
    return neuronResults

@app.route('/handleduplicate/<string:neuron_name>/<string:action>',  methods=['GET'])
def handleduplicate(neuron_name,action):
    com.pginsert('duplicateactions',{
        'neuron_name': neuron_name,
        'action': action
    })
    com.deletefromjson('dupname',neuron_name,'ui/assets/ajax/duplicates2023b.json')
    return {"status": "success"}


'''@app.route('/tweetneuron/<string:neuron_name>/<string:archive>/',  methods=['GET'])
def tweetneuron(neuron_name,archive):
    cfg.sshdir = cfg.sshreviewdir
    neuronResults = com.tweetneuron(neuron_name,archive)
    return neuronResults'''

@app.route('/tweetneuron/<string:neuron_name>/<string:archive>/',  methods=['GET'])
def tweetneurons(neuron_name,archive):
    cfg.sshdir = cfg.sshreviewdir
    version = com.getcurrentversions('pubversion')
    (neuronlist,neuronids) = com.getarchiveneurons(archive)
    nneurons = len(neuronlist)
    if nneurons == 1:
        plural = ''
    else:
        plural = 's'
    #foldername = io.namefromfolder(archive)
    #logging.info("app.py foldername = {}".format(foldername))

    csvfile = cfg.readyarchives
    folder = io.tweetfolder(archive, csvfile)
    folder_name = com.getfoldername(archive)
    logging.info("app.py folders name = {}".format(folder_name))


    tweet_id = io.publishtweets(version,nneurons,archive, neuron_name, folder_name)
    tweet_url = "https://twitter.com/NeuroMorphoOrg/status/{}".format(tweet_id)
    embed_code = io.embedded_tweet(tweet_url)
    io.tweet_index_embed(embed_code)

    return plural



@app.route('/exporttomain/<string:archive>',  methods=['GET'])
def exporttomain(archive):
    try:    
        now = datetime.datetime.now()
        dt_string = now.strftime("%Y-%m-%d")
        logging.info("Dtstring: {}".format(dt_string))
        cfg.sshdir = cfg.sshreviewdir
        cfg.dbsel = cfg.dbselmain
        io.mainrelease(archive,dt_string)
        cfg.sshdir = cfg.sshmaindir
        
        (version,nneurons) = io.genwinjsp(archive, dt_string)
        io.writeendings(archive)
        io.updateinfo(archive,version,dt_string)
        io.mainworkflow()
        io.updatetickertape()
        results = {
            "data" : "Archive {} exported".format(archive),
            "status": "success"
        }
       #io.publishtweet(version,nneurons,archive)
    except Exception:
        logging.exception("Error during export to main site of archive {}".format(archive))
        results = {
            "status": "error"
        }    
    cfg.sshdir = cfg.sshreviewdir
    cfg.dbsel = cfg.dbselrev
    return results


@app.route('/create_tweet', methods=['POST'])
def create_tweet():
    data = request.get_json()
    tweet_link = data.get('tweet_link')

    #tweet_id = 1707394627295424633
    tweet_id = io.createtweet(tweet_link, tweet_link)
    tweet_url = "https://twitter.com/NeuroMorphoOrg/status/{}".format(tweet_id)
    embed_code = io.embedded_tweet(tweet_url)
    io.tweet_index_embed(embed_code)

    return jsonify({"message": "Tweet created successfully"}), 200

@app.route('/create_tweets', methods=['POST'])
def create_tweets():
    data = request.get_json()
    tweet_link = data.get('tweet_links')

    #tweet_id = 1707394627295424633
    tweet_id = io.createtweets(tweet_link, tweet_link)
    tweet_url = "https://twitter.com/NeuroMorphoOrg/status/{}".format(tweet_id)
    embed_code = io.embedded_tweet(tweet_url)
    io.tweet_index_embed(embed_code)

    return jsonify({"message": "Tweet created successfully"}), 200


@app.route('/create_tweetc_customize', methods=['POST'])
def create_tweetc_customize():
    data = request.get_json()
    tweet_link = data.get('tweet_link_customize')

    logging.info(tweet_link)

    tweet_id = io.createtweetcustomize(tweet_link)
    tweet_url = "https://twitter.com/NeuroMorphoOrg/status/{}".format(tweet_id)
    embed_code = io.embedded_tweet(tweet_url)
    io.tweet_index_embed(embed_code)

    return jsonify({"message": "Tweet created successfully"}), 200


