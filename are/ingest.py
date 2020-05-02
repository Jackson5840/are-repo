import os
from . import cfg
import pandas as pd
from . import com
from datetime import date 
import math

def ingestexecute(neuron_name,neurontomeas,neurontometa):
    # takes one neuron as parameter
    # reads metadata as provided by csv and folder mapping to a dictionary
    # read measurements
    # calculate pvec
    # runs ingest region
    # rund ingest neuron
    # copy neuron files to the right place
    neurontomeas =  changenotrep(neurontomeas.keys(),neurontomeas)
    meas_id = com.insert('measurements',neurontomeas)
    shrinkval_id = com.insert('shrinkagevalue',getshrinkage(neurontometa))
    regionid = com.ingestregion(neurontometa)
    celltypeid = com.ingestcelltype(neurontometa)
    neurontometa['uploaddate'] = str(date.today())
    neurontometa['has_soma'] = 'NULL'
    neurontometa['doi'] = 'NULL'
    neurontometa['sum_mes_id'] = meas_id 
    neurontometa['shrinkval_id'] = shrinkval_id
    neurontometa['neuron_name'] = neuron_name
    neurontometa['region'] = regionid
    neurontometa['celltype'] = celltypeid
    neurontometa = changenotrep([
        'min_weight',
        'max_weight',
        'max_age',
        'min_age',
        'URL_reference',
        'thickness',
        'pmid'
        ],neurontometa)
    neurontometa = mapvals(neurontometa)
    neurontometa = mapshrinkage(neurontometa)
    com.ingestneuron(neurontometa)

def ingestneuron(neuron_name):
    result = {}
    try:
        archive_name = com.getneuronarchive(neuron_name)
        readyneurons = com.getreadyneurons(archive_name)
        neurontometa = mapneurontometa(archive_name)
        neurontomeas = mapneurontomeasurements(archive_name)
        ingestexecute(neuron_name,neurontomeas[neuron_name],neurontometa[neuron_name])
        result['status'] = 'success'
    except Exception as e:
        result['status'] = 'error'
        com.setneuronerror(neuron_name,str(e)) 
    return result
    

def mapshrinkage(d):
    if d['shrinkage_reported'] == 'Reported' and d['shrinkage_corrected'] == 'Corrected':
        d['shrinkage_reported'] = 'reported and corrected'
    elif d['shrinkage_reported'] == 'Reported':
        d['shrinkage_reported'] = 'reported and not corrected'
    return d

        

def changenotrep(tochange,d):
    for item in tochange:
        if d[item] == 'Not reported' or d[item] == 'Not applicable':
            d[item] = 'NULL'
        if isinstance(d[item], float):
            if math.isnan(d[item]):
                d[item] = 'NULL'
    return d

def mapvals(d):
    if d['gender'] == 'Male':
        d['gender'] = 'M'
    elif d['gender'] == 'Female':
        d['gender'] = 'F'
    elif d['gender'] == 'Male/Female':
        d['gender'] = 'M/F'
        
    return d

def getshrinkage(d):
    shrinkkeys = ['reported_value', 'reported_xy', 'reported_z', 'corrected_value','corrected_xy','corrected_z']
    shrinkd = {item: d[item] for item in shrinkkeys}
    shrinkd = changenotrep(shrinkkeys,shrinkd)
    return shrinkd


def ingestarchive(archive_name):
    # select all neurons with status ready from an archive and ingest them
    result = {}
    readyneurons = com.getreadyneurons(archive_name)
    neurontometa = mapneurontometa(archive_name)
    neurontomeas = mapneurontomeasurements(archive_name)
    result['status'] = 'success'
    for item in readyneurons:
        try:
            ingestexecute(item,neurontomeas[item],neurontometa[item])
        except Exception as e:
            result['status'] = 'error'
            com.setneuronerror(item,str(e))
     
    return result
    


def readmeasurements(archive_name):
    measurementPath = os.path.join(cfg.datapath, archive_name + '_Final', "Measurements")
    mdfs = {}
    for filename in os.listdir(measurementPath):
        if filename.find('csv') != -1:
            csvFilePath = os.path.join(measurementPath, filename)
            measurementsDataFrame = pd.read_csv(csvFilePath, header=0)
            if filename[-7] == '-':
                label = filename[-6:-4]
            else:
                label = filename[-7:-4]
            mdfs[label]= measurementsDataFrame
    return mdfs

def readmetadata(archivename):
    # read metadata from file, assign dict values to dict of metadata labels
    # if only one group, assign dict values to dict with label 'default'
    filepath = os.path.join(cfg.metapath,archivename,archivename + '.csv')
    anmdf = pd.read_csv(filepath,header=0)
    (rows,cols) = anmdf.shape
    metadict = {}
    if cols > 2:
        for col in anmdf.columns[1:]:
            #grouplabel = anmdf.iat[0,icol]
            metadict[col] = {}
        for ix in range(rows):
            itemlabel = anmdf.iat[ix,0]
            for jx in range(1,cols):
                grouplabel = anmdf.columns[jx]
                metadict[grouplabel][itemlabel] = anmdf.iat[ix,jx]
    else:
        metadict = {'default': {}}
        for ix in range(rows):
            itemlabel = anmdf.iat[ix,0]
            metadict['default'][itemlabel] = anmdf.iat[ix,1]
    return metadict

def mapneurontometa(archivename):
    # generates neuron to metadata map
    # check number of metadata groups
    # if more than one, generate neuron to group map 
    # and generate group to metadata map 
    # if only one, map the neurons directly to the metadata
    # returns the neuron to metadata map
    neurontometa = {}
    grouptometa = readmetadata(archivename)
    if len(grouptometa) == 1:
        thismetapath = os.path.join(cfg.metapath,archivename,'CNG Version')
        neurons=os.listdir(thismetapath)
        for item in neurons:
            neurontometa[item[0:-8]] = grouptometa['default']
    else:
        thismetapath = os.path.join(cfg.metapath,archivename,'CNG Version')
        metadatadirs = os.listdir(thismetapath)
        for item in metadatadirs:
            thispath = os.path.join(thismetapath,item)
            if not os.path.isdir(thispath):
                continue
            neurons = os.listdir(thispath)
            for neuron in neurons:
                neurontometa[neuron[0:-8]] = grouptometa[item]
    return neurontometa

def mapneurontomeasurements(archive_name):
    # generates measurements to neurons map
    # read different type of measurements for the archive 
    # map all neurons to measurements
    mdfs = readmeasurements(archive_name)
    summeas = mdfs['All']
    neuronstomeas = {}
    (nrows,ncols) = summeas.shape
    for irow in range(nrows):
        neuron_name = summeas.iat[irow,0]
        neuronstomeas[neuron_name] = {}
        for icol in range(1,ncols):
            neuronstomeas[neuron_name][summeas.columns[icol]] = summeas.iat[irow,icol]

    return neuronstomeas
                