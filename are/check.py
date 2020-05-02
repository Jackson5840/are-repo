import os
from datetime import datetime
from . import com 
from time import time
import random

def citstr(astr):
    return "'" + astr + "'"

def job1(foldername):
    # check which archives that are available 
    # check if neurons are imported in the db
    # run basic checks to see that they are complete
    # update db with neurons and archives available.
    folders = os.listdir(foldername)
    chkfolders = []
    t1 = time()
    for item in folders:
        folderpath = foldername + item
        if os.path.isdir(folderpath):
            neuronfolder = folderpath + '/CNG Version'
            neuronfiles = os.listdir(neuronfolder)
            for jtem in neuronfiles:
                neuron_name = jtem[0:-8]
                try:
                    
                    if com.isindb('ingestion','neuron_name',neuron_name):
                        continue
                    else:
                        now = datetime.now()
                        dt_string = now.strftime("%Y-%m-%d %H:%M:%S")
                        com.insert('ingestion',{
                            'neuron_name': citstr(neuron_name),
                            'status': 2,
                            'archive': citstr(item[0:-6]),
                            'ingestion_date': citstr(dt_string)
                            })
                except SyntaxError as e:
                    now = datetime.now()
                    dt_string = now.strftime("%Y-%m-%d %H:%M:%S")
                    com.insert('ingestion',{
                        'neuron_name': citstr(neuron_name),
                        'status': 1,
                        'archive': citstr(item[0:-6]),
                        'ingestion_date': citstr(dt_string),
                        'premessage': citstr("Syntax Error")
                        })
                except Exception as e:
                    now = datetime.now()
                    dt_string = now.strftime("%Y-%m-%d %H:%M:%S")
                    com.insert('ingestion',{
                        'neuron_name': citstr(neuron_name[0:5]),
                        'status': 1,
                        'archive': citstr(item[0:-6]),
                        'ingestion_date': citstr(dt_string),
                        'premessage': citstr('Error')
                        })
            
    print('Passed time: {}'.format(time()-t1))
