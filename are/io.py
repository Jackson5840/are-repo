from . import com
from . import cfg     
import shutil
import paramiko
import socket
import os
from stat import S_ISDIR
from datetime import date
import csv
from datetime import datetime
import glob
from Bio import Entrez

def create_sftp_client(host):
    """
    create_sftp_client(username, keyfilepath,host, port) -> SFTPClient
 
    Creates a SFTP client connected to the supplied host on the supplied port authenticating as the user with
    supplied username and supplied password or with the private key in a file with the supplied path.
    If a private key is used for authentication, the type of the keyfile needs to be specified as DSA or RSA.
    :rtype: SFTPClient object.
    """
    ssh = None
    sftp = None
    key = None
    try:
        #key = paramiko.RSAKey.from_private_key_file(keyfilepath)
 
        # Connect SSH client accepting all host keys.
        ssh = paramiko.SSHClient()
        ssh.load_system_host_keys()
        ssh.connect(host)

        #ssh.connect(host, port, username, key)
 
        # Using the SSH client, create a SFTP client.
        sftp = ssh.open_sftp()
        # Keep a reference to the SSH client in the SFTP client as to prevent the former from
        # being garbage collected and the connection from being closed.
        sftp.sshclient = ssh
 
        return sftp
    except Exception as e:
        print('An error occurred creating SFTP client: %s: %s' % (e.__class__, e))
        if sftp is not None:
            sftp.close()
        if ssh is not None:
            ssh.close()
        pass

def getfiles(archive):
    """ Takes one archive as input, fetches files and distributes.
    For the archive from mounted smb dir as defined in are.cfg
     a) 1) Fetch the swc files, 2) Fetch Std files, 3) Fetch Standardization log, 4) Fetch source files.
     5) Fetch images.
     b) store on new server as data/archive/date(ISO)/filetypedir/file.xxx
     c) update status for each neuron in ingestion table as 'data imported (Ready)'"""
    result = {'status': 'success', 'message': 'Archive read succesfully'}
    try:
        srcpath = os.path.join(cfg.remotepath, archive + '_Final')
        dstpath = os.path.join(cfg.datapath, archive)
        srcmetapath = os.path.join(cfg.remotemetapath, archive)
        dstmetapath = os.path.join(cfg.metapath, archive)
        prechecks(srcpath,srcmetapath)
        
        shutil.copytree(srcpath,dstpath)
        shutil.copytree(srcmetapath,dstmetapath)
        setready(dstpath,archive)

    except Exception as identifier:
        result['status'] = 'error'
        result['message'] = str(identifier)
    return result

def passpath(pathname):
    if not os.path.exists(pathname):
        raise FileNotFoundError('Directory does not exist: {}'.format(pathname))

def filenames(adir,filefilters=[],excludefilters=[]):
    """
    return filenames of a directory tree
    Arguments:
        adir - directory to list files for
        filefilters - a list of strings indicating which files to filter out, e.g ['.swc','.std']
    """
    # Building list of files and their paths
    filelist = [(item,r)  for r, d, files in os.walk(adir) for item in files]

    if len(filefilters) > 0:
        for thisfilter in filefilters:
            filelist  = list(filter(lambda x: (thisfilter in x[0]) , filelist))
    return filelist

def prechecks(datapath,metapath):
    """ Runs prechecks for the files in datapath and metapath:
    1) Number of files same in all directories
    2) Neurons in CNG Version matching neurons in metadata
    3) Can find csv file
    4) Group folder names matching groups in metadata
    """
    metalist = os.listdir(metapath)
    nondata = {'.DS_Store','._.DS_Store','desktop.ini'}
    # Loop over all meta folders
    metafiles = []
    metafiles = filenames(metapath,['.swc'])
    if len(metafiles) == 0:
        raise FileNotFoundError('No files in meta data directory: {}'.format(metapath))
    datapath
    releasedir = datapath + '/CNG Version/'
    
    passpath(releasedir)
    passpath(datapath + '/Images/')
    passpath(datapath + '/Measurements/')
    passpath(datapath + '/Remaining issues/')
    passpath(datapath + '/Source-Version/')
    passpath(datapath + '/Standardization log/')
    
    
    # Check if meta folder is in release dir. 
    releasefiles = filenames(releasedir,['.swc'])
    if len(releasefiles) == 0:
        raise FileNotFoundError('No files in data directory: {}'.format(releasefiles))
    # Calculate set difference between release and meta folders
    (metafilenames,metapaths) = zip(*metafiles)
    (releasefilenames,releasepaths) = zip(*releasefiles)
    metaset = set(metafilenames)
    releaseset = set(releasefilenames)
    notinrelease = metaset.difference(releaseset)
    if bool(notinrelease):
        raise FileNotFoundError('Files exist in metadata folder that are not in release folder: {}'.format(notinrelease))
    notinmeta = releaseset.difference(metaset)
    if bool(notinmeta):
        raise FileNotFoundError('Files exist in release folder that are not in metadata folder: {}'.format(notinrelease))

def citstr(astr):
    return "'" + astr + "'"

def setready(folderpath,archive):
    """ Sets all neurons in the archive's path as ready for ingestion in db
    """
    neuronfolder = folderpath + '/CNG Version'
    neuronfiles = os.listdir(neuronfolder)
    now = datetime.now()
    dt_string = now.strftime("%Y-%m-%d %H:%M:%S")
    for jtem in neuronfiles:
        neuron_name = jtem[0:-8]
        if com.isindb('ingestion','neuron_name',neuron_name):
            continue
        else:
            com.insert('ingestion',{
                'neuron_name': neuron_name,
                'status': 2,
                'archive': archive,
                'ingestion_date': dt_string
            })
    com.insert('ingested_archives',{
        'name': archive,
        'date': dt_string
    })

def exportfiles(archivelist):
    """ Sends archives in archivelist from startdate to external targets
    """
    for archive in archivelist:
        measurementPath = os.path.join(cfg.local_data, archive + '_Final', "Measurements")
    

def getarchivecsv():
    csvpath = os.path.join(cfg.remotepath,'readyarchives.csv')
        
    with open(csvpath, newline='') as csvfile:
        areader = csv.reader(csvfile, delimiter=',', quotechar='"')
        row = next(areader)
    return row


def put_all(self,localpath,remotepath):
    #  recursively upload a full directory
    os.chdir(os.path.split(localpath)[0])
    parent=os.path.split(localpath)[1]
    for walker in os.walk(parent):
        try:
            self.sftp.mkdir(os.path.join(remotepath,walker[0]))
        except:
            pass
        for file in walker[2]:
            self.put(os.path.join(walker[0],file),os.path.join(remotepath,walker[0],file))


def exportneurons():
    # exports all ready neurons and the sub structures to mysql db from postgres
    # after insertion, retrieves the id and writes it back to the postgres db.
    # also updates export table 
    # calls other functions as needed, run by either UI or automatic
    readyNeurons = com.getallreadydata() # should be status 3 add new method
    for item in readyNeurons:
        try:
            myitem = mapneuronfields(item)
            oldid = com.myinsert('neuron',myitem)
            com.insertbrainregions(item,oldid)
            com.insertcelltypes(item,oldid)
            com.exportmeasurements(item['id'],oldid,item['name'])
            com.insertdeposition(oldid,item)
            com.insertcompleteness(item['id'],oldid,item)
            com.inserttissueshrinkage(item['id'],oldid)
            transferneuronfiles(item)
            status = 'success'
            message = ''
        except Exception as e:
            oldid = 0
            status = 'error'
            message = str(e)
        com.updateexportstatus(item['id'],oldid,status,message)

def exportneuron(neuron_name):
    #try:
    item = com.getneurondata(neuron_name)
    myitem = mapneuronfields(item)
    oldid = com.myinsert('neuron',myitem)
    com.insertbrainregions(item,oldid)
    com.insertcelltypes(item,oldid)
    com.exportmeasurements(item['id'],oldid,item['name'])
    com.insertdeposition(oldid,item)
    com.insertcompleteness(item['id'],oldid,item)
    com.inserttissueshrinkage(item['id'],oldid)
    com.myinsert('file',{
        'neuron_id': oldid,
        'filename': neuron_name,
        'type': 'swc'
    })
    com.exportpublication(oldid,item['id'])
    transferneuronfiles(neuron_name)
    status = 'success'
    message = 'Neuron exported succesfully'
    """     except Exception as e:
        oldid = 0
        status = 'error'
        message = str(e) """
    com.updateexportstatus(item['id'],oldid,status,message)
    return {
        'status': status,
        'message': message
    }

def transferneuronfiles(neuron_name):
    def checkdir(path):
        try:
            sftp.chdir(path)
        except IOError as e:
            sftp.mkdir(path)
    archive = com.getneuronarchive(neuron_name)
    sftp = create_sftp_client(cfg.sshhost)
    datadir = cfg.sshdir + 'dableFiles/' + archive.lower() + '/'
    swcdir = datadir + 'CNG version/'
    remdir = datadir + 'Remaining issues/'
    stddir = datadir + 'Standardization log/'
    srcdir = datadir + 'Source-Version/'
    imgdir = cfg.sshdir + 'images/imageFiles/' + archive + '/'
    checkdir(datadir)
    checkdir(swcdir)
    checkdir(remdir)
    checkdir(stddir)
    checkdir(srcdir)
    checkdir(imgdir)
    lswcdir = cfg.datapath + archive + '/CNG Version/'
    lremdir = cfg.datapath + archive + '/Remaining issues/'
    lstddir = cfg.datapath + archive + '/Standardization log/'
    lsrcdir = cfg.datapath + archive + '/Source-Version/'
    limgdir = cfg.datapath + archive + '/Images/PNG/'
    sftp.put(lswcdir + neuron_name + '.CNG.swc',swcdir + neuron_name + '.CNG.swc')
    sftp.put(lremdir + neuron_name + '.CNG.swc.std',remdir + neuron_name + '.CNG.swc.std')
    sftp.put(lstddir + neuron_name + '.std',stddir + neuron_name + '.std')
    sourcefile = glob.glob(lsrcdir + neuron_name + '.*')[0]
    filename, file_extension = os.path.splitext(sourcefile)
    sftp.put(sourcefile,srcdir + neuron_name + file_extension)
    sftp.put(limgdir + neuron_name + '.png',imgdir + neuron_name + '.png')
        
def mapneuronfields(pgdict):
    archdict = {'archive_name': pgdict['archive_name'], 
        'archive_URL': pgdict['archive_url']}
    archive_id = com.checkexists('archive','archive_name', archdict)
    species_id = com.checkexists('species','species', {'species': pgdict['species_name']})
    strain_id = com.checkexists('animal_strain','strain_name', {'strain_name': pgdict['strain_name']})
    format_id = com.checkexists('original_format','original_format', {'original_format': pgdict['originalformat_name']})
    protocol_id = com.checkexists('protocol_design','protocol', {'protocol': pgdict['protocol']})
    thickness_id = com.checkexists('slicing_thickness','slice_thickness', {'slice_thickness': pgdict['slicingthickness']})
    slice_direction_id = com.checkexists('slicing_direction','slicing_direction', {'slicing_direction': pgdict['slicing_direction']})
    stain_id = com.checkexists('staining_method','stain', {'stain': pgdict['staining_name']})
    magnification_id = com.checkexists('magnification','magnification', {'magnification': pgdict['magnification']})
    objective_id = com.checkexists('objective_type','objective_type', {'objective_type': pgdict['objective']})
    reconstruction_id = com.checkexists('reconstruction','reconstruction_software', {'reconstruction_software': pgdict['reconstruction']})
    age_classification_id = com.checkexists('age_classification','age_class', {'age_class': pgdict['age']})
    expercond_id = com.checkexists('experimentcondition','expercond', {'expercond': pgdict['expcond_name']})
    region1_id = com.checkexists('neuron_region1','region1', {'region1': pgdict['region1']})
    region2_id = com.checkexists('neuron_region2','region2', {'region2': pgdict['region2']})
    region3_id = com.checkexists('neuron_region3','region3', {'region3': pgdict['region3']})
    region3B_id = com.checkexists('neuron_region3','region3', {'region3': pgdict['region3B']})
    class1_id = com.checkexists('neuron_class1','class1', {'class1': pgdict['class1']})
    class2_id = com.checkexists('neuron_class2','class2', {'class2': pgdict['class2']})
    class3_id = com.checkexists('neuron_class3','class3', {'class3': pgdict['class3']})
    class3B_id = com.checkexists('neuron_class3','class3', {'class3': pgdict['class3B']})
    class3C_id = com.checkexists('neuron_class3','class3', {'class3': pgdict['class3C']})


    
    mydict = {'neuron_name': pgdict['name'],
        'archive_id': archive_id,
        'species_id': species_id,
        'strain_id': strain_id,
        'max_age': pgdict['max_age'],
        'age_scale': pgdict['age_scale'],
        'min_age': pgdict['min_age'],
        'min_weight': pgdict['min_weight'],
        'max_weight': pgdict['max_weight'],
        'age_classification_id': age_classification_id,
        'region1_id': region1_id,
        'region2_id': region2_id,
        'region3_id': region3_id,
        'region3_idB': region3B_id,
        'class1_id': class1_id,
        'class2_id': class2_id,
        'class3_id': class3_id,
        'class3_idB': class3B_id,
        'class3_idC': class3C_id,
        'celltype_id': class2_id,
        'gender': pgdict['gender'],
        'format_id': format_id,
        'protocol_id': protocol_id,
        'thickness_id': thickness_id,
        'slice_direction_id': slice_direction_id,
        'stain_id': stain_id,
        'magnification_id': magnification_id,
        'objective_id': objective_id,
        'reconstruction_id': reconstruction_id,
        'URL_reference': pgdict['url_reference'],
        'note': pgdict['note'],
        'expercond_id': expercond_id}
    return mydict

def fetchpmarticle(pmid):
    Entrez.email = "bljungqu@gmu.edu"
    handle = Entrez.efetch(db="pubmed", id=pmid, rettype="gb", retmode="xml") # or esearch, efetch, ...
    record = Entrez.read(handle)
    handle.close()
    result = {}
    article  = record['PubmedArticle'][0]['MedlineCitation']['Article']
    result['article_title'] = com.escapechars(remove_html_tags(str(article['ArticleTitle'])))
    result['article_abstract'] = com.escapechars(remove_html_tags(str(article['Abstract']['AbstractText'][0])))
    result['article_URL'] = 'https://pubmed.ncbi.nlm.nih.gov/{}/'.format(pmid)
    return result


def remove_html_tags(text):
    """Remove html tags from a string"""
    import re
    clean = re.compile('<.*?>')
    return re.sub(clean, '', text)



