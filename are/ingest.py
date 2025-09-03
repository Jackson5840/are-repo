import logging
import os
from . import cfg
import pandas as pd
from . import com
from datetime import date 
import math, redis
from . import io


logging.basicConfig(level=logging.INFO,filename='app.log', filemode='w', format='%(asctime)s %(name)-12s %(levelname)-8s %(message)s')


def representint(s):
    try: 
        int(s)
        return True
    except ValueError:
        return False

def ingestexecute(neuron_name,neurontomeas,neurontometa,ndomains):
    # takes one neuron as parameter
    # reads metadata as provided by csv and folder mapping to a dictionary
    # read measurements
    # calculate pvec
    # runs ingest region
    # rund ingest neuron
    # copy neuron files to the right place
    # neurontodetmeas dicitionary mapping domain to measurements dictionary 
    neurontomeas =  changenotrep(neurontomeas.keys(),neurontomeas)
    meas_id = com.insert('measurements',neurontomeas)
    shrinkval_id = com.insert('shrinkagevalue',getshrinkage(neurontometa))
    regionid = com.ingestregion(neurontometa)
    celltypeid = com.ingestcelltype(neurontometa)
    neurontometa['uploaddate'] = str(date.today())
    neurontometa['has_soma'] = 'Soma' in ndomains.keys()
    if representint(neurontometa['pmid']):
        neurontometa['doi'] = ''
    else:
        neurontometa['doi'] = neurontometa['pmid']
        neurontometa['pmid'] = -1
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
    return com.ingestneuron(neurontometa)

def ingestdetailedmeas(neuron_name,neurontodetmeas):
    meas_ids = {}
    for item in neurontodetmeas:
        thismeas = neurontodetmeas[item][neuron_name]
        changenotrep(thismeas.keys(),thismeas)
        meas_ids[item] = com.insert('measurements',thismeas)
    return meas_ids
    
    
    
def ingestneuron(neuron_name):
    try:
        folder_name = com.getneuronfolder(neuron_name)
        #archive_name = io.namefromfolder(folder_name)
        neurontometa = mapneurontometa(folder_name)
        (neurontomeas,neurontodetmeas) = mapneurontomeasurements(folder_name)
        (ndomains,morpho_attr) = neurondomains(neuron_name,neurontometa[neuron_name])
        neuron_id = ingestexecute(neuron_name,neurontomeas[neuron_name],neurontometa[neuron_name],ndomains)
        detmeas_ids = ingestdetailedmeas(neuron_name,neurontodetmeas)
        
        com.ingestdomain(neuron_id,ndomains,morpho_attr,detmeas_ids)
        io.importpvec(neuron_id,neuron_name,folder_name)
        io.exportneuron(neuron_name)
        result= {
            'status': 'success',
            'message': 'Successful ingestion'
        }
    except Exception as e:
        result= {
            'status': 'error',
            'message': str(e)
        }
        com.setneuronerror(neuron_name,str(e))
        logging.exception("Error during ingestion of neuron: {}".format(neuron_name))
    return result
    

def mapshrinkage(d):
    if d['shrinkage_reported'] == 'Reported' and d['shrinkage_corrected'] == 'Corrected':
        d['shrinkage_reported'] = 'reported and corrected'
    elif d['shrinkage_reported'] == 'Reported':
        d['shrinkage_reported'] = 'reported and not corrected'
    return d

        

def changenotrep(tochange,d):
    for item in tochange:
        #if d[item] == 'Not reported' or d[item] == 'Not applicable':
        #    d[item] = None
        if isinstance(d[item], float):
            if math.isnan(d[item]):
                d[item] = None
    return d

def mapvals(d):
    if d['gender'] == 'Male':
        d['gender'] = 'M'
    elif d['gender'] == 'Female':
        d['gender'] = 'F'
    elif d['gender'] == 'Male/Female':
        d['gender'] = 'M/F'
    elif d['gender'] == 'Not reported' or d['gender'] == 'not reported':
        d['gender'] = 'NR'
        
    return d

def getshrinkage(d):
    shrinkkeys = ['reported_value', 'reported_xy', 'reported_z', 'corrected_value','corrected_xy','corrected_z']
    shrinkd = {item: d[item] for item in shrinkkeys}
    shrinkd = changenotrep(shrinkkeys,shrinkd)
    return shrinkd


def ingestarchive(folder_name):
    # select all neurons with status ready from an archive and ingest them
    r = redis.Redis(host='localhost', port=6379, db=0)
        #archive_name = io.namefromfolder(folder_name)
    neurontometa = mapneurontometa(folder_name)

    (neurontomeas,neurontodetmeas) = mapneurontomeasurements(folder_name)
    archive_name = io.namefromfolder(folder_name)
    readyneurons = com.getfolderneuronstatus(archive_name) # TODO check if correct
    counter =  0
    nneurons = len(readyneurons)
    result = {}
    for neuron in [item for item in readyneurons if item['status'] in ('warning','read','error')]:
        try:
            neuron_name = neuron['neuron_name']
            #logging.info("neuron_name is {}".format(neuron_name))
            thismeta = neurontometa[neuron_name].copy()
            #logging.info("thismeta is {}".format(thismeta))
            (ndomains,morpho_attr) = neurondomains(neuron_name,thismeta)

            neuron_id = ingestexecute(neuron_name,neurontomeas[neuron_name],thismeta,ndomains)
            detmeas_ids = ingestdetailedmeas(neuron_name,neurontodetmeas)
            
            com.ingestdomain(neuron_id,ndomains,morpho_attr,detmeas_ids)
            io.importpvec(neuron_id,neuron_name,folder_name)
            io.exportneuron(neuron_name)
            result[neuron_name] = {
                'status': 'success',
                'message': 'Successful ingestion'
            }
        except Exception as e:
            result[neuron_name] = {
                'status': 'error',
                'message': str(e)
            }
            com.setneuronerror(neuron_name,str(e))
            logging.exception("Error during ingestion of neuron: {}".format(neuron_name))
        counter += 1
        r.set(folder_name,counter/nneurons)
        #except Exception as e:
        #    result['status'] = 'error'
        #    com.setneuronerror(item,str(e))
     
    return result
    


def readmeasurements(foldername):
    measurementPath = os.path.join(cfg.datapath, foldername, "Measurements")
    mdfs = {}
    for filename in os.listdir(measurementPath):
        if filename[0] == '.':
            continue
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
    thismetapath = os.path.join(cfg.metapath,archivename,'CNG Version')
    if len(grouptometa) == 1:
        
        neurons=os.listdir(thismetapath)
        for item in neurons:
            neurontometa[item[0:-8]] = grouptometa['default']
    else:
    
        metadatadirs = os.listdir(thismetapath)
        for item in metadatadirs:
            thispath = os.path.join(thismetapath,item)
            if not os.path.isdir(thispath):
                continue
            neurons = os.listdir(thispath)
            for neuron in neurons:
                try: 
                    neurontometa[neuron[0:-8]] = grouptometa[item]
                except KeyError as e:
                    raise KeyError(str(e) + ' Meta data group not found')
    return neurontometa

def mapneurontomeasurements(foldername):
    # generates measurements to neurons map
    # read different type of measurements for the archive 
    # map all neurons to measurements
    mdfs = readmeasurements(foldername)
    summeas = mdfs['All']
    neuronstomeas = {}
    (nrows,ncols) = summeas.shape
    for irow in range(nrows):
        neuron_name = str(summeas.iat[irow,0])
        neuronstomeas[neuron_name] = {}
        neuronstomeas[neuron_name][summeas.columns[1]] = summeas.iat[irow,1]
        for icol in range(2,ncols):
            neuronstomeas[neuron_name][summeas.columns[icol]] = summeas.iat[irow,icol]
    dets = ['AP','APA','APB','AX','BS','BSA','NEU','PR']
    neuronstodetmeas = {}
    for item in dets:
        thismes = mdfs[item]
        thisdet = {}
        (nrows,ncols) = thismes.shape
        for irow in range(nrows):
            neuron_name = str(thismes.iat[irow,0])
            thisdet[neuron_name] = {}
            thisdet[neuron_name][thismes.columns[1]] = thismes.iat[irow,1]
            for icol in range(2,ncols):
                thisdet[neuron_name][thismes.columns[icol]] = thismes.iat[irow,icol]
        neuronstodetmeas[item] = thisdet
    return (neuronstomeas,neuronstodetmeas)

def mapneurontodetailedmeasurements(archive_name):
    # generates measurements to neurons map
    # read different type of measurements for the archive 
    # map all neurons to measurements
    #TODO to adapt to detailed
    mdfs = readmeasurements(archive_name)

    detailedtypes = ['AP','APA','APB','AX','BS','BSA','NEU','PR']

    
    neuronstomeas = {}
    for item in detailedtypes:
        detmeas = mdfs[item]
        (nrows,ncols) = detmeas.shape
        for irow in range(nrows):
            neuron_name = detmeas.iat[irow,0]
            #if neuron_name in neuronstomeas.keys()
            neuronstomeas[neuron_name] = {}
            for icol in range(1,ncols):
                neuronstomeas[item][neuron_name][detmeas.columns[icol]] = detmeas.iat[irow,icol]

    return neuronstomeas

def neurondomains(neuron_name,neuronmeta):
    integrity = neuronmeta['Physical integrity']
    
    #reads swc file and finds neuron domains and if it has soma or not
    folder_name = com.getneuronfolder(neuron_name)
    filename = os.path.join(cfg.datapath, folder_name,'CNG Version',neuron_name + '.CNG.swc')
    minrad = 10000
    maxrad = -10000
    noDim = True
    hasDim = False
    firstRead = True
    with open(filename) as fp: 
        lines = fp.readlines()
        domaincount = [0] * 8
        for line in lines:
            if line[0] == '#' or len(line) < 3:
                continue
            else:
                elems = line.strip().split()
                if firstRead and int(elems[1]) != 1:
                    prevradius = float(elems[5]) 
                    firstRead = False
                domaincount[int(elems[1])] += 1
                if maxrad < float(elems[4]):
                    maxrad = float(elems[4])
                if minrad > float(elems[4]):
                    minrad = float(elems[4])

                hasDim = hasDim or (int(elems[1]) != 1 and float(elems[5]) > 1)
                if int(elems[1]) != 1:
                    noDim = noDim and float(elems[5]) == prevradius
                    # logging.info("noDim is {}".format(noDim))
                    # logging.info("before noDim is {}".format(noDim))
                    # logging.info("elem5 is {}".format(elems[5]))
                    # logging.info("prevradius is {}".format(prevradius))
                    prevradius = float(elems[5])
        # logging.info("elems is {}".format(elems[1]))
    #3D -  has a variation in diameter
    is3D = maxrad - minrad > 3

    # Check diameter override from csv
    diaoverride = neuronmeta['diameter']  
    if isinstance(diaoverride,float): # is NaN
        # if it is null
        # hasDim = not noDim
        # hasDim = False
        pass

    elif diaoverride in ('TRUE','True'): # Overridden to True
        hasDim = True

    elif diaoverride in ('FALSE','False'): # Overridden to False
        hasDim = False

    else:
        hasDim = not noDim

    # Code for deciding morphological a2tributes.
    # Angles hardcoded, as it was in previous ingestion. 
    if hasDim and is3D:
        # Diameter, 3D, Angles
        morpho_attr = 3
    elif hasDim and not is3D:
        # Diameter, 2D, Angles
        morpho_attr = 1
    elif not hasDim and is3D:
        # No Diameter, 3D, Angles
        morpho_attr = 7
    else:
        # No Diameter, 2D, Angles
        morpho_attr = 5
    # logging.info("Diameter is morpho_attr is {}".format(morpho_attr))

    #establish dictionary of domains detected
    domains = {'Soma': domaincount[1] > 0,
        "AP": domaincount[4] > 0,
        "BS": domaincount[3] > 0,
        "AX": domaincount[2] > 0,
        "NEU": domaincount[6] > 0,
        "PR": domaincount[7] > 0
    }
    domcheck = [key for key in domains if domains[key]]
    domres = {}
    # parse integrity
    if  isinstance(integrity,float):
        # is nan value
        integdict = {item: ('Incomplete' if item == 'AX' else 'Moderate') for item in domcheck}
    else:
        integrity = integrity.replace('& ','')
        # make integerity string  array 
        integarr = integrity.split()
        integdict = {item: ('Incomplete' if item == 'AX' else 'Moderate') for item in domcheck }
        try:
            if len(integarr) > 2:
                for item in domcheck:
                    if len(integarr) == 3:
                        integdict[item] = integarr[2]
                    else:
                        integdict[item] = integarr[1]
                if domaincount[2] > 0:
                    if len(integarr) == 3:
                        integdict['AX'] = integarr[2]
                    else:
                        integdict['AX'] = integarr[3]
            elif len(integarr) > 0:
                for item in domcheck:
                    integdict[item] = integarr[1]
                if domaincount[2] > 0 and 'Axon' not in integarr:
                    integdict['AX'] = 'Incomplete'
        except KeyError as e:
            raise KeyError('Physical integrity element not in domains{}'.format(str(e)))
    return (integdict,morpho_attr)
                
