import subprocess
import twitter, validators, csv,logging,json,shutil,socket,os,glob,math,requests,re,time,filecmp,tweepy
from . import com,cfg,gifgen,ingest,tasks,utils
from stat import S_ISDIR
from datetime import date,datetime
from Bio import Entrez
from pathlib import Path
from crossref.restful import Works 
from threading import Thread
from xml.etree import ElementTree as ET
from urllib.request import urlopen
from bs4 import BeautifulSoup
import mysql.connector
import logging

# paramiko.util.log_to_file('paramiko.log', level='DEBUG')

# use localhost flag to run on localhost
islocal = True
if not islocal:
    import paramiko

def updateinforev(foldername,version,dt_string):
    archive = namefromfolder(foldername)
    table = 'version'
    nneurons = com.countneurons()
    nneurons += 57;
    (neuronlist,neuronids) = com.getarchiveneurons(archive)
    ninarchive = len(neuronlist) 


    if islocal:
        dirpath = cfg.sshdir
        winpath = dirpath + 'about.jsp'
        filehandle = open(winpath,'w+')
    else:
        sftp = create_sftp_client(cfg.sshhost)
        dirpath = cfg.sshdir
        winpath = dirpath + 'about.jsp'
        filehandle = sftp.file(winpath,'r')
        
    with filehandle as sfile:
        line = sfile.readline()
        # FIND start of list
        while line != "" and not "START INFO" in line:
            line = sfile.readline()
        pos = sfile.tell()

        #skip the current line
        sfile.readline()
        infoline = ["{}.{}.{} - Released: {} - Content: {} cells </font></td>\n".format(version['major'],version['minor'],version['patch'],dt_string,nneurons)]

        restoffile = sfile.readlines()
        towrite = infoline + restoffile
        sfile.seek(pos)
        sfile.writelines(towrite)

    if islocal:
        winpath = dirpath + 'about.jsp'
        filehandle = open(winpath,'w+')
    else:
        filehandle = sftp.file(winpath,'r')

 
    with filehandle as sfile:
        line = sfile.readline()

        #skip the current line
        while line != "" and not "START INFO" in line:
            line = sfile.readline()
        #skip the current line
        pos = sfile.tell()
        sfile.readline()
        #infoline = ['	finalOutput=finalOutput+"<table width=\\"100%\\" border=\\"0\\" cellpadding=\\"3\\" cellspacing=\\"2\\" class=\\"tab\\"><tr><td colspan=\\"2\\" align=\\"center\\" valign=\\"top\\" class=\\"rhstyle\\"><strong>Quick Facts</strong></td><td width=\\"23%\\" align=\\"center\\" valign=\\"top\\" class=\\"headstyle\\"><strong>v{}.{}.{}</strong></td></tr>";\n'.format(version['major'],version['minor'],version['patch'])]
        
        #infoline = ['        <td align="center" valign="top" class="headstyle"><strong class="headstyle">v{}.{}.{}</strong></td>\n'.format(version['major'],version['minor'],version['patch'])]

        restoffile = sfile.readlines()
        towrite = infoline + restoffile
        #sfile.seek(pos)
        #sfile.writelines(towrite)
    
    filehandle.close()
    if islocal:
        winpath = dirpath + 'about.jsp'
        filehandle = open(winpath,'w+')
    else:
        filehandle = sftp.file(winpath,'r')

    with filehandle as sfile:
        line = sfile.readline()

        #skip the current line
        while line != "" and not "VERSION INF2" in line:
            line = sfile.readline()
        #skip the current line
        pos = sfile.tell()
        sfile.readline()
        #infoline = ['	finalOutput=finalOutput+"<table width=\\"100%\\" border=\\"0\\" cellpadding=\\"3\\" cellspacing=\\"2\\" class=\\"tab\\"><tr><td colspan=\\"2\\" align=\\"center\\" valign=\\"top\\" class=\\"rhstyle\\"><strong>Quick Facts</strong></td><td width=\\"23%\\" align=\\"center\\" valign=\\"top\\" class=\\"headstyle\\"><strong>v{}.{}.{}</strong></td></tr>";\n'.format(version['major'],version['minor'],version['patch'])]
        
       # infoline = ['        <td align="center" valign="top" class="headstyle"><strong class="headstyle">v{}.{}.{}</strong></td>\n'.format(version['major'],version['minor'],version['patch'])]

        restoffile = sfile.readlines()
        towrite = infoline + restoffile
        #sfile.seek(pos)
        #sfile.writelines(towrite)

    filehandle.close()
    if not islocal:
        sftp.close()
        sftp.sshclient.close()

# new sftp client
def create_sftp_client(host):
    """
    create_sftp_client(host) -> SFTPClient

    Creates an SFTP client connected to the specified host using RSA private key file
    configured in cfg.py.
    """
    ssh = None
    sftp = None
    try:

        # Create SSH client instance
        ssh = paramiko.SSHClient()
        ssh.load_system_host_keys()

        #logging.info("sftp username is {}".format(cfg.sshuser))

        # Connect SSH client to the specified host using RSA key
        ssh.connect('cng.gmu.edu', port=22, username='bljungqu', key_filename='/home/bljungqu/.ssh/id_rsa', allow_agent=False)
        logging.info("good")

        # Create SFTP client from the SSH transport
        t = ssh.get_transport()
        sftp = paramiko.SFTPClient.from_transport(t)

        # Keep a reference to the SSH client in the SFTP client to prevent connection closure
        sftp.sshclient = ssh

        logging.info("Successfully connected to SFTP server")
        return sftp

    except Exception as e:
        logging.exception('An error occurred creating SFTP client: %s: %s' % (e.__class__, e))
        if sftp is not None:
            sftp.close()
        if ssh is not None:
            ssh.close()
        raise


def create_sftp_client_old(host):
    """
    create_sftp_client(username, keyfilepath,host, port) -> SFTPClient
 
    Creates an SFTP client connected to the supplied host on the supplied port authenticating as the user with
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
        #logging.info("ssh is {}".format(host))

        #ssh.connect(host, port, username, key)
 
        # Using the SSH client, create a SFTP client.
        t = ssh.get_transport()
        t.use_compression(True)
        t.packetizer.REKEY_BYTES = pow(2, 40)
        t.packetizer.REKEY_PACKETS = pow(2, 40)
        sftp = paramiko.SFTPClient.from_transport(t,2147483647,32768)
        #logging.info("sftp is {}".format(sftp))
        # Keep a reference to the SSH client in the SFTP client as to prevent the former from
        # being garbage collected and the connection from being closed.
        sftp.sshclient = ssh
 
        return sftp
    except Exception as e:
        logging.exception('An error occurred creating SFTP client: %s: %s' % (e.__class__, e))
        if sftp is not None:
            sftp.close()
        if ssh is not None:
            ssh.close()
        raise

def namefromfolder(foldername):
    foldpath = os.path.join(cfg.remotemetapath, foldername)
    csvpath = '{}/{}.csv'.format(foldpath,foldername)
    r = csv.reader(open(csvpath))
    lines = list(r)
    archive_name = lines[3][1]
    if ' archive' in archive_name.lower():
        archive_name = archive_name[:-8]
    elif 'archive' in archive_name.lower():
        archive_name = archive_name[:-7]
    return archive_name


def getsourcefiles(sourcepath,localsource,metafolder,swcfolder,stdpath,stdfolder):
    """
    1) deletes sourcefiles that are duplicates
    2) Transfers the remaining files. 
    3) Creates symlinks locally
    4) Creates meta data children corresponding to symlinks
    """
    srcdup = utils.checkswctosource(sourcepath,swcfolder)
    utils.createmetachildren(srcdup,metafolder)

    shutil.copytree(sourcepath,localsource)
    shutil.copytree(stdpath,stdfolder)
    stddup = {item.split('.')[0] + '.std': 
        [elem.split('.')[0] + '.std' for elem in srcdup[item]] for item in srcdup.keys()}
    for item in srcdup:
        utils.createsymlinks(item,srcdup,localsource)
    for item in stddup:
        utils.createsymlinks(item,stddup,stdfolder)

def populateresult(result,archive):
    newres = []
    for item in result:
        orgname = item['Original']
        orgfolder = com.getneuronarchive(orgname)
        if not os.path.exists('ui/temp/'):
            os.mkdir('ui/temp/')
        if orgfolder is None:
            orgfolder = archive
            shutil.copyfile(os.path.join(cfg.datapath,archive,'Images/PNG/',orgname + '.png'),os.path.join('ui/temp/',orgname + '.png'))
            item['orgimg'] = './temp/' + orgname + '.png'
        else:
            item['orgimg'] =  'https://neuromorpho.org/images/imageFiles/{}/{}.png'.format(orgfolder,orgname)

        dupname = item['Duplicate']
        shutil.copyfile(os.path.join(cfg.datapath,archive,'Images/PNG/',dupname + '.png'),os.path.join('ui/temp/',dupname + '.png'))
        item['dupimg'] = './temp/' + dupname + '.png'
        srcfile = glob.glob(os.path.join(cfg.datapath,archive,'Source-Version/',orgname + '.*'))[0]
        dupfile = glob.glob(os.path.join(cfg.datapath,archive,'Source-Version/',dupname + '.*'))[0]
        item["srcfilesame"] = 'True' if filecmp.cmp(srcfile,dupfile,shallow = False)  else 'False'

        newres.append(item)
    return newres
        
def getfiles(foldername):
    """ Takes one archive (folder aanme) as input, fetches files and distributes.
    For the archive from mounted smb dir as defined in are.cfg
    First get the name of the archive as in csv file
     a) 1) Fetch the swc files, 2) Fetch Std files, 3) Fetch Standardization log, 4) Fetch source files.
     5) Fetch images.
     b) store on new server as data/archive/date(ISO)/filetypedir/file.xxx
     c) update status for each neuron in ingestion table as 'data imported (Ready)'"""
    archive = namefromfolder(foldername)
    result = {'status': 'success', 'message': 'Archive read successfully'}
    try:
        ares = com.getarchiveingestionstatus(foldername) #TODO must select subset of archive that has not been 

        if ares and ares["status"] in ['read','partial','ingested']:
            result = ares
        else:
        
            srcpath = os.path.join(cfg.remotepath, foldername + '_Final')
            dstpath = os.path.join(cfg.datapath, foldername)
            srcmetapath = os.path.join(cfg.remotemetapath, foldername)
            dstmetapath = os.path.join(cfg.metapath, foldername)
            
            
            if os.path.exists(dstpath):
                deleteallfiles(dstpath)
            if os.path.exists(dstmetapath):
                deleteallfiles(dstmetapath)
            #add ignore pattern for scrcpath, ignoring source folder.
            ignorepattern =  shutil.ignore_patterns('Source-Version','Standardization log')

            shutil.copytree(srcpath,dstpath,ignore=ignorepattern)
            
            lswcdir = os.path.join(cfg.datapath,foldername,'CNG Version/')
            rstddir = os.path.join(cfg.remotepath,foldername + '_Final','Standardization log/')
            lstddir = os.path.join(cfg.datapath,foldername,'Standardization log/')
            if not os.path.isdir(lswcdir):
                os.rename(cfg.datapath,foldername,'CNG version/',lswcdir)
            shutil.copytree(srcmetapath,dstmetapath)
            getsourcefiles(os.path.join(cfg.remotepath,foldername + '_Final','Source-Version/'),os.path.join(cfg.datapath,foldername,'Source-Version/'),dstmetapath,lswcdir,rstddir,lstddir)
            prechecks(dstpath,dstmetapath,foldername)
            

            #lgifdir = os.path.join(cfg.datapath, archive,'rotatingImages/')
            #os.mkdir(lgifdir)
            # commented out rightnow
            #gifgen.gifgen(lswcdir,lgifdir)

            data = readpvecmes(foldername)
            duplicateresult = checkduplicatesinternal(data,cfg.pcalim,cfg.similaritylim)
            #duplicateresult = 0
            if len(duplicateresult) > 0:
            #if duplicateresult > 0:
                populateresult(duplicateresult,foldername)
                now = datetime.now()
                dt_string = now.strftime("%Y-%m-%d %H:%M:%S")
                nupdated = com.update('ingested_archives',
                {
                    'name': archive,
                    'date': dt_string,
                },
                {
                    'name': archive,
                    'foldername': foldername,
                    'date': dt_string,
                    'status': 'warning',
                    'message': 'Duplicates detected',
                    'json': json.dumps(duplicateresult)
                })
                if nupdated < 1: 
                    com.insert('ingested_archives',{
                        'name': archive,
                        'foldername': foldername,
                        'date': dt_string,
                        'status': 'warning',
                        'message': 'Duplicates detected',
                        'json': json.dumps(duplicateresult)
                    })

            setready(dstpath,archive,duplicateresult,foldername)
            
    except Exception as identifier:
        identifier = com.cleanerr(str(identifier))
        result['status'] = 'error'
        result['message'] = identifier
        now = datetime.now()
        dt_string = now.strftime("%Y-%m-%d %H:%M:%S")
        nupdated = com.update('ingested_archives',
        {
            'name': archive,
            'date': dt_string
        },
        {
            'name': archive,
            'foldername': foldername,
            'date': dt_string,
            'status': 'error',
            'message': identifier
        })
        if nupdated < 1: 
            com.insert('ingested_archives',{
                'name': archive,
                'foldername': foldername,
                'date': dt_string,
                'status': 'error',
                'message': identifier
            })
        logging.exception("Error during reading of files")
        
    return result

def genarchivegifs(foldername):
    try:
        lswcdir = os.path.join(cfg.datapath, foldername,'CNG Version/')
        lgifdir = os.path.join(cfg.datapath, foldername,'rotatingImages/')
        if not os.path.exists(lgifdir):
            os.mkdir(lgifdir)
        gifgen.gifgen(lswcdir,lgifdir,foldername)
        result = {"status": "success"}
        logging.info(
            "gifs generated genarchivegifs" + str(result))
    except Exception:
        result = {"status": "error"}
        logging.exception("Error generating gifs")
    return result

def passpath(pathname):
    if not os.path.exists(pathname):
        raise FileNotFoundError('Directory does not exist: {}'.format(pathname))
    directory, filename = os.path.split(pathname)
    parent = Path(pathname).parent
    if not filename in os.listdir(parent):
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

def autopvecfix(pvecpath,pvecnotinrelease,notinpvec):
    toremove1 = []
    toremove2 = []
    for item in pvecnotinrelease:
        matches = [s for s in notinpvec if item in s]
        if len(matches) == 1:
            # unique match found, fix:
            # rename file to found match
            oldpvecpath = os.path.join(pvecpath,item + '.CNG.pvec')
            newpvecpath = os.path.join(pvecpath,matches[0] + '.CNG.pvec')
            os.rename(oldpvecpath,newpvecpath)
            # add for removal from both sets
            toremove1.append(item)
            toremove2.append(matches[0])
    for item in toremove1:
        pvecnotinrelease.remove(item)
    for item in toremove2:
        notinpvec.remove(item)
    return (pvecnotinrelease,notinpvec)

def prechecks(datapath,metapath,foldername=''):
    """ Runs prechecks for the files in datapath and metapath:
    1) Number of files same in all directories
    2) Neurons in CNG Version matching neurons in metadata
    3) Can find csv file
    4) Group folder names matching groups in metadata
    """
    

    metalist = os.listdir(metapath)
    try:
        passpath(metapath + '/CNG Version')
    except FileNotFoundError as e:
        try:
            passpath(metapath + '/CNG version')
            os.rename(metapath + '/CNG version',metapath + '/CNG Version')
        except FileNotFoundError as e:
            raise FileNotFoundError("SWC files meta folder missing for archive")
    nondata = {'.DS_Store','._.DS_Store','desktop.ini'}
    # Loop over all meta folders
    metafiles = []
    metafiles = filenames(metapath,['.swc'])
    if len(metafiles) == 0:
        raise FileNotFoundError('No files in meta data directory: {}'.format(metapath))
    releasedir = datapath + '/CNG Version/'
    
    #Check swc folder exists
    try:
        passpath(datapath + '/CNG Version')
    except FileNotFoundError as e:
        try:
            passpath(datapath + '/CNG version')
            os.rename(datapath + '/CNG version',datapath + '/CNG Version')
        except FileNotFoundError as e:
            raise FileNotFoundError("SWC files ongoing folder missing for archive")
    

    imgpath = datapath + '/Images'
    # Check img folder exists
    passpath(imgpath)
    try:
        passpath(imgpath)
    except FileNotFoundError as e:
        raise FileNotFoundError("Image folder missing for archive")

    #Check measurements folder exists
    passpath(datapath + '/Measurements')
    try:
        passpath(datapath + '/Measurements')
    except FileNotFoundError as e:
        raise FileNotFoundError("Measurements folder missing for archive")

    # Check remaining issues folder exists
    rempath = datapath + '/Remaining issues'
    passpath(rempath)
    try:
        passpath(rempath)
    except FileNotFoundError as e:
        raise FileNotFoundError("Remaining issues folder missing for archive")

    # Check source folder exists
    sourcepath = datapath + '/Source-Version'
    passpath(sourcepath)
    try:
        passpath(sourcepath)
    except FileNotFoundError as e:
        raise FileNotFoundError("Source folder missing for archive")

    stdpath = datapath + '/Standardization log'
    #Check standardization log exists
    try:
        passpath(stdpath)
    except FileNotFoundError as e:
        raise FileNotFoundError("Standardization folder missing for archive")

    pvecpath = datapath + '/pvec'
#    try:
#        passpath(pvecpath)
#    except FileNotFoundError as e:
#        raise FileNotFoundError("Pvec folder missing for archive")
    
    
    
    # Check if meta folder is in release dir. 
    releasefiles = filenames(releasedir,['.swc'])
    cngfiles = os.listdir(releasedir)
    for item in cngfiles:
        assert os.path.getsize(os.path.join(releasedir,item)) != 0, "File {} has a size of 0".format(item) 
    if len(releasefiles) == 0:
        raise FileNotFoundError('No files in data directory: {}'.format(releasefiles))
    # Calculate set difference between release and meta folders
    (metafilenames,metapaths) = zip(*metafiles)
    (releasefilenames,releasepaths) = zip(*releasefiles)
    metaset = set(metafilenames)
    metaset.discard('desktop') # disregard desktop.ini
    releaseset = set(releasefilenames)
    releaseset.discard('desktop') # disregard desktop.ini
    notinrelease = metaset.difference(releaseset)
    if bool(notinrelease):
        raise FileNotFoundError('Files exist in metadata folder that are not in CNG Version  folder: {}'.format(str(notinrelease)))
    notinmeta = releaseset.difference(metaset)
    if bool(notinmeta):
        raise FileNotFoundError('Files exist in CNG Version  folder that are not in metadata folder: {}'.format(str(notinmeta)))

    releasefilenames = [item[0].split('.')[0] for item in releasefiles]
    releaseset = set(releasefilenames)
    releaseset.discard('desktop') # disregard desktop.ini

    checkneuronsinmes(releaseset,foldername,datapath,'All')
    checkneuronsinmes(releaseset,foldername,datapath,'AP')
    checkneuronsinmes(releaseset,foldername,datapath,'APA')
    checkneuronsinmes(releaseset,foldername,datapath,'APB')
    checkneuronsinmes(releaseset,foldername,datapath,'AX')
    checkneuronsinmes(releaseset,foldername,datapath,'BS')
    checkneuronsinmes(releaseset,foldername,datapath,'BSA')
    checkneuronsinmes(releaseset,foldername,datapath,'NEU')
    checkneuronsinmes(releaseset,foldername,datapath,'PR')

    """
    # Check if pvec folder is complete 
    pvecfiles = []
    pvecfiles = filenames(pvecpath ,['.pvec'])
    pvecfilenames = [item[0].split('.')[0] for item in pvecfiles]

    

    # Calculate set difference between release and pvec folders

    pvecset = set(pvecfilenames)
    pvecset.discard('desktop') # disregard desktop.ini
    assert len(pvecset) == len(releaseset), "The number of files in pvec and swc file folders must be the same"
    pvecnotinrelease = pvecset.difference(releaseset)
    notinpvec = releaseset.difference(pvecset)
    if bool(pvecnotinrelease) or bool(notinpvec):
        # try to autofix
        (pvecnotinrelease,notinpvec) = autopvecfix(pvecpath,pvecnotinrelease,notinpvec)

    if bool(pvecnotinrelease):
        #try one more time
        (pvecnotinrelease,notinpvec) = autopvecfix(pvecpath,pvecnotinrelease,notinpvec)
        if bool(pvecnotinrelease):
            # and another one...
            (pvecnotinrelease,notinpvec) = autopvecfix(pvecpath,pvecnotinrelease,notinpvec)
        if bool(pvecnotinrelease):
            raise FileNotFoundError('Files exist in pvec folder that are not in CNG Version  folder: {}'.format(str(pvecnotinrelease)))
    if bool(notinpvec):
        #try one more time
        (pvecnotinrelease,notinpvec) = autopvecfix(pvecpath,pvecnotinrelease,notinpvec)
        raise FileNotFoundError('Files exist in CNG Version  folder that are not in pvec folder: {}'.format(str(notinpvec)))
    """

    # Check if source folder is complete 
    #aneuron = releasefilenames[0]
    for aneuron in releasefilenames:
        sourcefile = glob.glob("{}/{}.*".format(sourcepath, aneuron)) 
        if len(sourcefile) == 0:
            continue
        sourcefile = sourcefile[0]
        srcext = os.path.splitext(sourcefile)[1] 
        break
    srcfiles = filenames(sourcepath)

    # check if any symlink
    haslinks = any([os.path.islink(os.path.join(sourcepath,item[0])) for item in srcfiles])
        

    srcfilenames = [item[0].split('.')[0] for item in srcfiles]

    # Calculate set difference between release and source folders
    if not haslinks:
        srcset = set(srcfilenames)
        srcset.discard('desktop') # disregard desktop.ini
        srcnotinrelease = srcset.difference(releaseset)
        if bool(srcnotinrelease):
            raise FileNotFoundError('Files exist in source folder that are not in CNG Version folder: {}'.format(str(srcnotinrelease)))
        notinsrc = releaseset.difference(srcset)
        if bool(notinsrc):
            raise FileNotFoundError('Files exist in CNG Version folder that are not in source folder: {}'.format(str(notinsrc)))

    # Check if remaining issues folder is complete 
    remfiles = filenames(rempath ,['.CNG.swc.std'])
    remfilenames = [item[0].split('.')[0] for item in remfiles]

    # Calculate set difference between release and rem folders

    remset = set(remfilenames)
    remset.discard('desktop') # disregard desktop.ini
    remnotinrelease = remset.difference(releaseset)
    remnotinrelease.discard('desktop') # disregard desktop.ini
    if bool(remnotinrelease):
        raise FileNotFoundError('Files exist in rem folder that are not in CNG Version  folder: {}'.format(str(remnotinrelease)))
    notinrem = releaseset.difference(remset)
    if bool(notinrem):
        raise FileNotFoundError('Files exist in CNG Version  folder that are not in rem folder: {}'.format(str(notinrem)))

    # Check if standardization folder is complete 
    stdfiles = filenames(stdpath ,['.std'])
    stdfilenames = [item[0].split('.')[0] for item in stdfiles]

    # Calculate set difference between release and std folders

    stdset = set(stdfilenames)
    stdset.discard('desktop') # disregard desktop.ini
    stdnotinrelease = stdset.difference(releaseset)
    stdnotinrelease.discard('desktop') # disregard desktop.ini
    if bool(stdnotinrelease):
        raise FileNotFoundError('Files exist in std folder that are not in CNG Version  folder: {}'.format(str(stdnotinrelease)))
    notinstd = releaseset.difference(stdset)
    if bool(notinstd):
        raise FileNotFoundError('Files exist in CNG Version  folder that are not in std folder: {}'.format(str(notinstd)))

    # Check if image folder is complete 
    imgfiles = filenames(imgpath ,['.png'])
    imgfilenames = [item[0].split('.')[0] for item in imgfiles]

    # Calculate set difference between release and img folders

    imgset = set(imgfilenames)
    imgset.discard('desktop') # disregard desktop.ini
    imgnotinrelease = imgset.difference(releaseset)
    #stdnotinrelease.discard('desktop') # disregard desktop.ini
    if bool(imgnotinrelease):
        raise FileNotFoundError('Files exist in img folder that are not in CNG Version folder: {}'.format(str(imgnotinrelease)))
    notinimg = releaseset.difference(imgset)
    if bool(notinimg):
        raise FileNotFoundError('Files exist in CNG Version  folder that are not in img folder: {}'.format(str(notinimg)))

    namedict = {}
    splitpath = datapath.split("/")
    archive = splitpath[len(splitpath)-1]
    for item in releasefilenames:
        if com.checkindb("neuron","neuron_name",{"neuron_name": item}):
            new_name = "{}_{}".format(archive,item)
            namedict[item] = new_name
            sourcefile = glob.glob("{}/{}.*".format(sourcepath, item))[0]
            srcext = os.path.splitext(sourcefile)[1] 
            thismetapos = metafilenames.index("{}.CNG.swc".format(item))


            os.rename(os.path.join(metapaths[thismetapos],"{}.CNG.swc".format(item)),os.path.join(metapaths[thismetapos],"{}.CNG.swc".format(new_name)))
            os.rename(os.path.join(releasedir,"{}.CNG.swc".format(item)),os.path.join(releasedir,"{}.CNG.swc".format(new_name)))
            os.rename(os.path.join(sourcepath,"{}{}".format(item,srcext)),os.path.join(sourcepath,"{}{}".format(new_name,srcext)))
            os.rename(os.path.join(imgpath,"PNG","{}.png".format(item)),os.path.join(imgpath,"PNG","{}.png".format(new_name)))
            if os.path.exists(os.path.join(pvecpath,"{}.CNG.pvec".format(item))):
                os.rename(os.path.join(pvecpath,"{}.CNG.pvec".format(item)),os.path.join(pvecpath,"{}.CNG.pvec".format(new_name)))
            os.rename(os.path.join(stdpath,"{}.std".format(item)),os.path.join(stdpath,"{}.std".format(new_name)))
            os.rename(os.path.join(rempath,"{}.CNG.swc.std".format(item)),os.path.join(rempath,"{}.CNG.swc.std".format(new_name)))

            renamecsvneuron(namedict,foldername,datapath,'All')
            renamecsvneuron(namedict,foldername,datapath,'AP')
            renamecsvneuron(namedict,foldername,datapath,'APA')
            renamecsvneuron(namedict,foldername,datapath,'APB')
            renamecsvneuron(namedict,foldername,datapath,'AX')
            renamecsvneuron(namedict,foldername,datapath,'BS')
            renamecsvneuron(namedict,foldername,datapath,'BSA')
            renamecsvneuron(namedict,foldername,datapath,'NEU')
            renamecsvneuron(namedict,foldername,datapath,'PR')

def renamecsvneuron(namedict,foldername,path,type):
    #read csv, and split on "," the line
    csvname = '{}/Measurements/{}-{}.csv'.format(path,foldername,type)
    r = csv.reader(open(csvname)) # Here your csv file
    lines = list(r)

    for item in lines[1:]:
        if item[0] in namedict.keys():
            item[0] = namedict[item[0]]

    writer = csv.writer(open(csvname, 'w'))
    writer.writerows(lines)

def checkneuronsinmes(filenameset,foldername,path,type):
    csvname = '{}/Measurements/{}-{}.csv'.format(path,foldername,type)
    r = csv.reader(open(csvname)) # Here /your csv file
    lines = list(r)
    neuronnameset = set([item[0] for item in lines[1:]])
    if filenameset.symmetric_difference(neuronnameset):
        notincsv = filenameset.difference(neuronnameset)
        if notincsv:
            raise KeyError("Some folder neuron filenames are not in csvfile for -{}-: {}".format(type,', '.join(notincsv)))
        notinfiles = neuronnameset.difference(filenameset)
        if notinfiles:
            raise FileNotFoundError("Some csv neurons for -{}- are not in folder filenames: {}".format(type,', '.join(notinfiles)))
        

def citstr(astr):
    return "'" + astr + "'"

def setready(folderpath,archive,duplicateresult,foldername):
    """ Sets all neurons in the archive's path as ready for ingestion in db
    """
    neuronfolder = folderpath + '/CNG Version'
    archive = namefromfolder(foldername)
    neuronfiles = os    .listdir(neuronfolder)
    neuronduplicates = {item["Duplicate"]: {
        "Original": item["Original"],
        "dupimg": item["dupimg"],
        "orgimg": item["orgimg"],
        "srcfilesame": item["srcfilesame"]
    }  for item in duplicateresult}
    now = datetime.now()
    dt_string = now.strftime("%Y-%m-%d %H:%M:%S")
    for jtem in neuronfiles:
        neuron_name = jtem[0:-8]
        if com.isindb('ingestion','neuron_name',neuron_name):
            continue
        elif neuron_name in neuronduplicates.keys():
            dupmessage = """
            <table>
        <tbody><tr>
            <th>
                This neuron
            </th>
            <th>{}</th>
        </tr>
        <tr>
            <td>
                <img width=320 src="{}">
            </td>
            <td>
                <img width=320 src="{}">
            </td>
        </tr>
        <tr>
            <td colspan=2>
                Same sourcefile: {}
            </td>
        </tr>
    </tbody></table>
            """.format(neuronduplicates[neuron_name]["Original"],neuronduplicates[neuron_name]["dupimg"],neuronduplicates[neuron_name]["orgimg"],neuronduplicates[neuron_name]["srcfilesame"])
            com.insert('ingestion',{
                'neuron_name': neuron_name,
                'status': 'warning',
                'archive': archive,
                'ingestion_date': dt_string,
                'message': dupmessage
            })
        else:
            com.insert('ingestion',{
                'neuron_name': neuron_name,
                'status': 'read',
                'archive': archive,
                'ingestion_date': dt_string,
                'message': "Neuron ready for ingestion"
            })
    if len(duplicateresult) > 1:
        status = 'warning'
        message = 'Duplicates detected'
    else:
        status = 'read'
        message = 'Archive read successfully'
    nupdated = com.update('ingested_archives',{'foldername': foldername},{
        'date': dt_string, 
        'status': status,
        'message': message
    })
    if nupdated < 1: 
        com.insert('ingested_archives',{
            'name': archive,
            'foldername': foldername,
            'date': dt_string,
            'status': status,
            'message': message
        })
    metadict = ingest.readmetadata(foldername)
    writeack(metadict[next(iter(metadict))])

def deleteempty(foldername):
    if com.getnneurons(foldername) == 0:
        return revertarchive(foldername)
    else:
        return {'message': 'Archive not empty; aborting archive delete', "status": "success"}

def revertarchive(foldername):
    try:
        archive = namefromfolder(foldername)
        (neuronarr,neuronids) = com.getarchiveneurons(archive)
        measids = com.getarchivemeasurements(archive)
        com.deleteingestedneurons(neuronarr)
        com.deletearchive(foldername,neuronarr)
        com.deletemeasurements(measids)
        
        datadir = os.path.join(cfg.datapath,foldername)
        deleteallfiles(datadir)

        metadir = os.path.join(cfg.metapath,foldername)
        deleteallfiles(metadir)
        result = {'message': 'Archive deleted', "status": "success"}
    except Exception as e:
        result = {'message': 'Error: {}'.format(str(e)), "status": "error"}
        logging.exception("Error during revert archive: {}".format(foldername))
    return result

def deingestarchive(foldername):
    try:
        archive = namefromfolder(foldername)
        (neuronarr,neuronids) = com.getarchiveneurons(archive)
        measids = com.getarchivemeasurements(archive)
        com.deleteingestedneurons(neuronarr)
        com.deletearchiveingestion(foldername)
        com.deletemeasurements(measids)
        
        result = {'message': 'Archive deleted', "status": "success"}
    except Exception as e:
        result = {'message': 'Error: {}'.format(str(e)), "status": "error"}
        logging.exception("Error during revert archive: {}".format(foldername))
    return result

def deleteneuron(neuronname):
    try:
        ###
        
        foldername = com.getneuronfolder(neuronname)
        swcfile = os.path.join(cfg.datapath, foldername, 'CNG Version',neuronname + '.CNG.swc') 
        os.remove(swcfile)
        imgfile = os.path.join(cfg.datapath, foldername, 'Images/PNG',neuronname + '.png') 
        os.remove(imgfile)
        pvecfile = os.path.join(cfg.datapath, foldername, 'pvec',neuronname + '.CNG.pvec') 
        os.remove(pvecfile)
        remfile = os.path.join(cfg.datapath, foldername, 'Remaining issues',neuronname + '.CNG.swc.std') 
        os.remove(remfile)
        #TODO add to delete source file
        stdfile = os.path.join(cfg.datapath, foldername, 'Standardization log',neuronname + '.std') 
        os.remove(stdfile)
        #TODO add to delete metadata swc file 

        com.deleteneuron(neuronname)
        com.deletemyneuron(neuronname)

        result = {'message': 'Neuron deleted', "status": "success"}
    except Exception as e:
        result = {'message': 'Error: {}'.format(str(e)), "status": "error"}
        logging.exception("Error during delete neuron: {}".format(neuronname))
    return result

    
    

def deleteallfiles(folder):
    try:
        for filename in os.listdir(folder):
            file_path = os.path.join(folder, filename)
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        os.rmdir(folder)
    except Exception as e:
        logging.exception('Failed to delete %s. Reason: %s' % (folder, e))
    

def readpvecmes(foldername):
    """
    Calls pvec conversion service, writes to files and returns json object 
    """
    swcpath = os.path.join(cfg.datapath,foldername,'CNG Version')
    swcfiles = os.listdir(swcpath)
    
    #interact with pvec calculation service
    pvecurl = cfg.pvecurl
    r = requests.get(pvecurl + 'clearpvecs')
    
    for item in swcfiles:
        files = {'file': open(os.path.join(swcpath,item),'rb')}
        r = requests.post(pvecurl + 'sendfile', files=files)
    r = requests.get(pvecurl + 'calcpvecs')
    time.sleep(len(swcfiles)/15)
    r = requests.get(pvecurl + 'getjson')
    ar = r.json()
    
    neuron_names = [item[0:-8] for item in swcfiles]
    measurementsmap = ingest.mapneurontomeasurements(foldername)
    datarows = []
    pvecpath = os.path.join(cfg.datapath,foldername,"pvec")
    if not os.path.isdir(pvecpath):
        os.mkdir(pvecpath)
    for neuron_name in neuron_names:
        
        pvecpath = os.path.join(cfg.datapath,foldername,"pvec",neuron_name + ".CNG.pvec")
        if os.path.isfile(pvecpath):
            with open(pvecpath) as pfile:
                line1 = pfile.readline()
                coeffs = pfile.readline().split()
                coeffs = [float(item) for item in coeffs]
            nmes = measurementsmap[0][neuron_name]
            pvecmes ={
                "neuron_name": neuron_name,
                "distance": line1[0],
                "Sfactor": line1[1],
                "data": coeffs + [float(nmes[item]) if not math.isnan(nmes[item]) else float(0) for item in nmes]
            }
        else:
            npvec = ar['pvecs'][neuron_name]
            # write to pvec file as it is needed later in ingestion
            with open(pvecpath,'w') as pfile:
                line1 = '{} {}\n'.format(npvec['distance'],npvec['Sfactor'])
                line2 = ' '.join([item for item in npvec['vector']])
                pfile.writelines([line1,line2])
            nmes = measurementsmap[0][neuron_name]
            pvecmes ={
                "neuron_name": neuron_name,
                "distance": npvec['distance'],
                "Sfactor": npvec['Sfactor'],
                "data": [float(item) for item in npvec['vector']] + [float(nmes[item]) if not math.isnan(nmes[item]) else float(0) for item in nmes]
            }
        datarows.append(pvecmes)
    return datarows

def importpvec(neuron_id,neuron_name,archive):
    pvecpath = os.path.join(cfg.datapath,archive,"pvec",neuron_name + ".CNG.pvec")
    with open(pvecpath) as pfile:
        line1 = pfile.readline().split()
        line2 = pfile.readline().split()
    dpvec = {
        "neuron_id": neuron_id,
        "distance": line1[0],
        "sfactor": line1[1],
        "coeffs": "{{{}}}".format(",".join(line2))
    }
    com.insert("pvec",dpvec)


def getarchivecsv():
    # fetch archives from csv
    # add information from ingested archives
    csvpath = cfg.readyarchives
    
    archives = []
    try:
        with open(csvpath, newline='') as csvfile:
            areader = csv.reader(csvfile, delimiter=',', quotechar='"')
            row = next(areader)
    
        for anitem in row:
            item = namefromfolder(anitem)
            res = com.getfolderneuronstatus(item)
            ares = com.getarchiveingestionstatus(anitem)
            swcdir = cfg.remotepath + anitem + '_Final/CNG Version/'
            nneurons = len(os.listdir(swcdir))
            if not ares:
                archiverecord = {
                    'name': anitem,
                    "message": "Ready for reading", 
                    "status": "ready", 
                    "link": "", 
                    "neurons": [], 
                    "nneurons": nneurons, 
                    "json": []
                }
                ingestdate = datetime.now().date().strftime('%Y-%m-%d')
            elif not res:
                ingestdate = datetime.now().date().strftime('%Y-%m-%d')
                archiverecord = {
                    'name': anitem, 
                    "status": ares["status"], 
                    "link": '',
                    "message": ares["message"], 
                    "neurons": [],
                    "nneurons": nneurons,
                    "json": ares['json']
                    }
            else:
                # check all statuses
                statuses = [d["status"] for d in res]
                # set archive status to 
                # 1) ingested if ALL neurons have status ingested
                # 2) partial if ANY neurons have status ingested
                # 3) read if NO neurons have status ingested
                ingested = [s == "ingested" for s in statuses]
                published = [s == "public" for s in statuses]
                if all(ingested):
                    archivestatus = 'ingested'
                elif all(published):
                    archivestatus = 'public'
                elif any(ingested) or any(published):
                    archivestatus = 'partial'
                else:
                    archivestatus = 'read'
                
                adate = res[0]["ingestion_date"]
                archiverecord = ({
                    'name': anitem,
                    'status': archivestatus,
                    'message': ares["message"],
                    'link': cfg.webserver + 'NeuroMorpho_ArchiveLinkout.jsp?ARCHIVE={}&DATE={}'.format(item,adate),
                    'neurons': res,
                    'nneurons': nneurons,
                    "json": ares['json']
                })
            archives.append(archiverecord)   
    except FileNotFoundError as e:
        return {
            'status': 'error',
            'data': str(e)
        }

    return {
        'data': archives,
        'status': 'success'
    }



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

def writeack(ackdict):
    """ Writes the acknowledgement to the file on the ssh server 
    Opens file on remote server
    Reads lines until line containing START ACK is found
    Parses Lab names of lines until alphetic order of 
    """
    lab = ackdict["acknowledgement"]
    if lab is not None and not isinstance(lab,float):
        if islocal:
            ackpath = cfg.sshdir + 'acknowl.jsp'
            f = open(ackpath,'r+')
        else:
            sftp = create_sftp_client(cfg.sshhost)
            ackpath = cfg.sshdir + 'acknowl.jsp'
            f = sftp.file(ackpath,'r+')

        with f as sfile:
            line = sfile.readline()
            # FIND start of list
            while line != "" and not "START ACK" in line:
                line = sfile.readline()

            line = sfile.readline()
            while line != "" and not line[10:].casefold() > lab.casefold():
                pos = sfile.tell()
                line = sfile.readline()
            
            restoffile = sfile.readlines()
            ackline = "<p><li><b>{}</b><br>{}<br>{}</li></p>\n".format(lab,ackdict['address1'],ackdict['address2'])
            if line != ackline:
                towrite = [ackline] + [line] + restoffile
                sfile.seek(pos)
                sfile.writelines(towrite)

        f.close()
        if not islocal:
            sftp.close()
            sftp.sshclient.close()

def genwinjsp(foldername,ingestdate=""):
    """ Writes the win.jsp announcement of the number of files and archive name. 
    If the combo is found it looks at the date of insertion. If within a week, nothing is written.
    Opens file on remote server
    Reads lines until line containing START ACK is found
    Parses Lab names of lines until alphetic order of 
    """
    archive = namefromfolder(foldername)
    if ingestdate == "":
        table = 'version'
        res = com.getarchiveneuronstatus(archive)
        ingestdate = res[0]["ingestion_date"]
    else:
        table = 'pubversion'

    version = com.getcurrentversion(table)
    (neuronlist,neuronids) = com.getarchiveneurons(archive)
    nneurons = len(neuronlist)
    if nneurons == 1:
        plural = ''
    else:
        plural = 's'

    # get ingestion date
    

    # set and increase version number
    com.setversionarchives(archive,ingestdate,version['id'],table)

    if islocal:
        winpath = cfg.sshdir + 'WIN.jsp'
        f = open(winpath,'r+')
    else:
        sftp = create_sftp_client(cfg.sshhost)
        winpath = cfg.sshdir + 'WIN.jsp'
        f = sftp.file(winpath,'r+')

    with f as sfile:
        line = sfile.readline()
        # FIND start of list
        while line != "" and not "START WIN" in line:
            line = sfile.readline()
        pos = sfile.tell()
        winlines = ["""

<br><b>What's new in version {}.{}.{} ?</b><br>
<ul>
""".format(version['major'],version['minor'],version['patch'])]
        winlines.append('    <li>{} reconstruction{} (<a target="_blank" href="NeuroMorpho_ArchiveLinkout.jsp?ARCHIVE={}&DATE={}">{} archive</a>)</li>'.format(nneurons,plural,archive,ingestdate,archive))
        winlines.append("</ul>")

        restoffile = sfile.readlines()
        towrite = winlines + restoffile
        sfile.seek(pos)
        sfile.writelines(towrite)

    f.close()
    if not islocal:
        sftp.close()
        sftp.sshclient.close()
    return (version,nneurons)

def writeendings(foldername):
    """ Writes the endings to either archive_swc.xml if swc, or archive_all.xml for other source files. 
    Looks for line <archive name="[archive_name]">. If line found, read all names for that archive.
    Add any endings missing, then saves file.
    """
    def writeswcfile(xmlfile, endingslist):
        """
        internal function to write to a file
        """
        if islocal:
            f = open(xmlfile,'r+')
        else:
            sftp = create_sftp_client(cfg.sshhost)
            f = sftp.file(xmlfile,'r+')
        with f as sfile:
            start = sfile.tell()
            line = sfile.readline()
            prevpos = 0
            # FIND start of list
            while line != "" and not linetofind in line:
                prev2pos = prevpos
                prevpos = sfile.tell()
                line = sfile.readline()
            if linetofind in line:
                
                endtofind = "archive"
                namere = "\s*\<neuronname\>([^\<]*)"
                line1 = sfile.readline()
                line2 = sfile.readline()
                neuron_names = []
                
                while not "</XMLROOT>" in line1 and line1 != "" and not endtofind in line1:
                    neuron_names.append(re.match(namere,line1).group(1))
                    pos = sfile.tell()
                    line1 = sfile.readline()
                    line2 = sfile.readline()
                restoffile = sfile.readlines()
                endingsection = []
                for item in neuronlist:
                    if item not in neuron_names:
                        endingsection.append("""        <neuronname>{}<ext>{}</ext>
            </neuronname>\n""".format(item,endingdict[item]))
                towrite = endingsection + [line1] + [line2] + restoffile
                sfile.seek(pos)
                sfile.writelines(towrite)
                sfile.flush()
            else:
                #archive not found and must be added
                #sfile.seek(start)
                #oldcontent = sfile.readlines()
                endingsection = ['    <archive name="{}">\n'.format(archive)] 
                for item in neuronlist:
                    endingsection.append("""        <neuronname>{}<ext>{}</ext>
            </neuronname>\n""".format(item,endingdict[item]))
                endingsection.append("""    </archive>
    </XMLROOT>""")
                #newcontent = oldcontent[:-2] + endingsection
                sfile.seek(prev2pos)
                sfile.writelines(endingsection)
                sfile.flush()
        f.close()
        if not islocal:
            sftp.close()
            sftp.sshclient.close()

    archive = namefromfolder(foldername)
    (neuronlist,neuronids) = com.getarchiveneurons(archive)
    sourcepath = cfg.datapath + foldername + '/Source-Version/'
    # check ending for first neuron in neuronlist
    endingdict = {}
    for item in neuronlist:
        sourcefile = glob.glob("{}/{}.*".format(sourcepath, item))[0]
        endingdict[item] = os.path.splitext(sourcefile)[1]
        
    linetofind = 'archive name="{}'.format(archive)
    
    swcenddict = {key: val for (key,val) in endingdict.items() if val == ".swc"}
    otherdict = {key: val for (key,val) in endingdict.items() if val != ".swc"}
    if len(swcenddict) > 0:
        xmlpath = cfg.sshdir + 'xml/archive_swc.xml'
        writeswcfile(xmlpath,swcenddict)
    if len(otherdict) > 0:
        xmlpath = cfg.sshdir + 'xml/archive_all.xml'
        writeswcfile(xmlpath,otherdict)
      


class DuplicateException(Exception):
    # Constructor or Initializer 
    def __init__(self, value): 
        self.value = value 
  
    # __str__ is to print() the value 
    def __str__(self): 
        return(repr(self.value))


def exporttomain(foldername):
    archive = namefromfolder(foldername)
    status = "success"
    message = "Neuron exported to main"
    (resultnames, resultids) = com.getarchiveneurons(archive)  # should be status 3 add new method
    for item in resultnames:
        try:
            status = "public"
            myitem = exportneuron(item)

        except mysql.connector.errors.IntegrityError as e:
            # If it's a duplicate entry error
            if '1062' in str(e):
                print(f"Ignoring duplicated entry error: {e}")
                continue  # Continue with the next item
            else:
                # If it's another type of IntegrityError
                oldid = 0
                status = 'error'
                message = str(e)
                logging.exception("Error during export of neurons to main")

        except Exception as e:
            oldid = 0
            status = 'error'
            message = str(e)
            logging.exception("Error during export of neurons to main")

        finally:
            com.updateneuronstatus(item, status, message)

    if status == 'error':
        return []
    else:
        pass  # Add an indented block here
        return resultnames


# Original Copy
def exporttomainOriginal(foldername):
    # exports all ready neurons and the sub structures to mysql db from postgres
    # after insertion, retrieves the id and writes it back to the postgres db.
    # also updates export table
    # calls other functions as needed, run by either UI or automatic
    # TODO support archive version
    archive = namefromfolder(foldername)
    status = "success"
    (resultnames, resultids) = com.getarchiveneurons(archive)  # should be status 3 add new method
    for item in resultnames:
        try:
            status = "public"
            myitem = exportneuron(item)

            message = "Neuron exported to main"
        except Exception as e:
            oldid = 0
            status = 'error'
            message = str(e)
            logging.exception("Error during export of neurons to main")
        com.updateneuronstatus(item, status, message)
    if status == 'error':
        return []
    else:
        return resultnames

def updatetickertape():
    num_neuron = com.countneurons()

    if islocal:
        dirpath = cfg.sshdir
        winpath = dirpath + 'index.jsp'
        f = open(winpath,'r+')
    else:
        sftp = create_sftp_client(cfg.sshhost)
        winpath = cfg.sshdir + 'index.jsp'
        f = sftp.file(winpath,'r+')
    
    with f as sfile:
        line = sfile.readline()
        # FIND start of list
        while line != "" and not "TOTAL NEURON" in line:
            line = sfile.readline()
        pos = sfile.tell()

        #skip the current line
        sfile.readline()
        infoline = ['<li style="font-weight: bold; font-size: 12px; width: 300px; height: 20px;">{} digital reconstructions</li>\n'.format(num_neuron)]

        restoffile = sfile.readlines()
        towrite = infoline + restoffile
        sfile.seek(pos)
        sfile.writelines(towrite)

    f.close()
    if not islocal:
        sftp.close()
        sftp.sshclient.close()


def updateinfo(foldername,version,dt_string):
    archive = namefromfolder(foldername)
    table = 'pubversion'
    nneurons= com.countneurons()
    (neuronlist,neuronids) = com.getarchiveneurons(archive)
    ninarchive = len(neuronlist) 

    if islocal:
        dirpath = cfg.sshdir
        winpath = dirpath + 'Header.jsp'
        f = open(winpath,'w+')
    else:
        sftp = create_sftp_client(cfg.sshhost)
        winpath = cfg.sshdir + 'Header.jsp'
        f = sftp.file(winpath,'r+')

    with f as sfile:
        line = sfile.readline()
        # FIND start of list
        while line != "" and not "START INFO" in line:
            line = sfile.readline()
        pos = sfile.tell()

        #skip the current line
        sfile.readline()
        infoline = ["{}.{}.{} - Released: {} - Content: {} cells </font></td>\n".format(version['major'],version['minor'],version['patch'],dt_string,nneurons)]

        restoffile = sfile.readlines()
        towrite = infoline + restoffile
        sfile.seek(pos)
        sfile.writelines(towrite)

    f.close()
    if not islocal:
        sftp.close()
        sftp.sshclient.close()


    if islocal:
        dirpath = cfg.sshdir
        winpath = dirpath + 'about.jsp'
        f = open(winpath,'w+')
    else:
        sftp = create_sftp_client(cfg.sshhost)
        winpath = cfg.sshdir + 'WIN.jsp'
        f = sftp.file(winpath,'r+')

    with f as sfile:
        line = sfile.readline()

        #skip the current line
        while line != "" and not "VERSION INF1" in line:
            line = sfile.readline()
        #skip the current line
        pos = sfile.tell()
        sfile.readline()
        #infoline = ['	finalOutput=finalOutput+"<table width=\\"100%\\" border=\\"0\\" cellpadding=\\"3\\" cellspacing=\\"2\\" class=\\"tab\\"><tr><td colspan=\\"2\\" align=\\"center\\" valign=\\"top\\" class=\\"rhstyle\\"><strong>Quick Facts</strong></td><td width=\\"23%\\" align=\\"center\\" valign=\\"top\\" class=\\"headstyle\\"><strong>v{}.{}.{}</strong></td></tr>";\n'.format(version['major'],version['minor'],version['patch'])]
        
        #infoline = ['        <td align="center" valign="top" class="headstyle"><strong class="headstyle">v{}.{}.{}</strong></td>\n'.format(version['major'],version['minor'],version['patch'])]

        restoffile = sfile.readlines()
        towrite = infoline + restoffile
        #sfile.seek(pos)
        #sfile.writelines(towrite)
    
    with sftp.file(winpath,'r+') as sfile:
        line = sfile.readline()

        #skip the current line
        while line != "" and not "VERSION INF2" in line:
            line = sfile.readline()
        #skip the current line
        pos = sfile.tell()
        sfile.readline()
        #infoline = ['	finalOutput=finalOutput+"<table width=\\"100%\\" border=\\"0\\" cellpadding=\\"3\\" cellspacing=\\"2\\" class=\\"tab\\"><tr><td colspan=\\"2\\" align=\\"center\\" valign=\\"top\\" class=\\"rhstyle\\"><strong>Quick Facts</strong></td><td width=\\"23%\\" align=\\"center\\" valign=\\"top\\" class=\\"headstyle\\"><strong>v{}.{}.{}</strong></td></tr>";\n'.format(version['major'],version['minor'],version['patch'])]
        
        #infoline = ['        <td align="center" valign="top" class="headstyle"><strong class="headstyle">v{}.{}.{}</strong></td>\n'.format(version['major'],version['minor'],version['patch'])]
       # infoline = ['        <td align="center" valign="top" class="headstyle"><strong class="headstyle">v{}.{}</strong></td>\n'.format(version['major'],version['minor'])]

        restoffile = sfile.readlines()
        towrite = infoline + restoffile
        #sfile.seek(pos)
        #sfile.writelines(towrite)

    f.close()
    if not islocal:
        sftp.close()
        sftp.sshclient.close()

def publishtweet(version,nneurons,folder):

    archive = namefromfolder(folder)
    neuron_name=com.getfirstneuronname(archive)
    

    api = twitter.Api(**cfg.twitterparams)
    if nneurons == 1:
        plural = ''
    else:
        plural = 's'
    message = "New agile release of http://NeuroMorpho.org available, v{}.{}.{}, including {} novel reconstruction{} in the {} archive. http://neuromorpho.org/WIN.jsp".format(version['major'],version['minor'],version['patch'],nneurons,plural,archive)
    
    logging.info("http://neuromorpho.org/images/imageFiles/{}/{}.png".format(archive,neuron_name))

    with open(os.path.join(cfg.datapath,folder,'Images/PNG','{}.png'.format(neuron_name)),'rb') as fp:

        api.PostUpdate(message,media=fp)

def tweetfolder(target, csv_filepath):
    results = []
    logging.info("io.py target = {}".format(target))
    with open(csv_filepath, 'r', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            for word in row:
                if target in word:
                    results.append(word)
    logging.info("io.py results = {}".format(results))
    return results


# new twitter v2 end point
def publishtweets(version,nneurons,archivename,neuron_name,folders):
    
    #archive = namefromfolder(folder)
    #api = twitter.Api(**cfg.twitterparams)
    logging.info("folders = {}".format(archivename))

    folder_name = com.getfoldername(archivename)
    logging.info("new folder name = {}".format(folder_name))
    folder = folders[0]
    client = tweepy.Client(consumer_key='y6vLTNiRFwNpcUd4Rk6ntVDo3',
                         consumer_secret='FdSETIgoxXIGkcJseOvgIGQcyZtUr7eFqzdoUB8I9WciJSWFaB',
                         access_token='223121018-2YOxlA3Babx1pqbhtyOHsEYA7l1siy6VenVr46w6',
                         access_token_secret='wfrCDCrkZfu87VbpWH4rcx2OwSi4YhW37ug2oHzisOQ2L')

    consumer_key = 'y6vLTNiRFwNpcUd4Rk6ntVDo3'
    consumer_secret = 'FdSETIgoxXIGkcJseOvgIGQcyZtUr7eFqzdoUB8I9WciJSWFaB'
    access_token = '223121018-2YOxlA3Babx1pqbhtyOHsEYA7l1siy6VenVr46w6'
    access_token_secret = 'wfrCDCrkZfu87VbpWH4rcx2OwSi4YhW37ug2oHzisOQ2L'

    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)

    api = tweepy.API(auth)

    if nneurons == 1:
        plural = ''
    else:
        plural = 's'
    message = "New agile release of http://NeuroMorpho.org available, v{}.{}.{}, including {} novel reconstruction{} in the {} archive. http://neuromorpho.org/WIN.jsp".format(version['major'],version['minor'],version['patch'],nneurons,plural,archivename)
    
    #logging.info("http://neuromorpho.org/images/imageFiles/{}/{}.png".format(archivename,neuron_name))
    image_path = os.path.join(cfg.datapath, folder_name, 'Images/PNG', '{}.png'.format(neuron_name))
    media = api.media_upload(image_path)
    media_id = media.media_id

    tweet_id = client.create_tweet(text=message, media_ids=[media_id])

    id = tweet_id.data['id']
    
    return id
    #client.create_tweet(text=message)

    # Post the tweet with the image
    #media = api.media_upload(image_path)
    #api.update_status(status=message, media_ids=[media.media_id_string])

    # with open(image_path, 'rb') as fp:
    #     api.PostUpdate(message)
    # with open(os.path.join(cfg.datapath,folder,'Images/PNG','{}.png'.format(neuron_name)),'rb') as fp:
    #     api.PostUpdate(message)
    #     api.create_tweet(text=message,)


def exportneuron(neuron_name):

    item = com.getneurondata(neuron_name)
    myitem = mapneuronfields(item)
    oldid = com.myinsert('neuron',myitem)
    com.insertbrainregions(item["regionlabels"],oldid)
    com.insertcelltypes(item['celltypelabels'],oldid)
    com.exportmeasurements(item['id'],oldid,item['name'])
    #com.exportdetailedmeasurements(item['id'],oldid,item['name'])
    com.insertdeposition(oldid,item)
    com.insertcompleteness(item['id'],oldid,item)
    com.inserttissueshrinkage(item['id'],oldid)
    com.myinsert('file',{
        'neuron_id': oldid,
        'filename': neuron_name,
        'type': 'swc'
    })
    com.exportpublication(oldid,item['id'])
    com.exportpvec(item["id"],oldid)
    if cfg.sshdir == cfg.sshreviewdir:
        transferneuronfiles(neuron_name)
    status = 'success'
    neuronstatus = 'ingested'
    message = 'Neuron exported successfully'
    com.updateneuronstatus(neuron_name,neuronstatus,message)
    return {
        'status': status,
        'message': message
    }

def checkduplicatesinternal(datarows,pcalevel,duplicatelevel):
    duplojson = {}
    duplojson["pcalevel"] = pcalevel
    duplojson["datarows"] = datarows
    duplojson["duplicatelevel"] = duplicatelevel
    jsonpayload = json.dumps(duplojson)
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
    response = requests.post(cfg.duplicateinternalurl,data=jsonpayload,headers=headers)
    resd = response.json()
    return resd

def checkduplicates(neuron_id):
    # check duplicates for a given neuron. 
    # Fetches pvec and measurements from db
    # Sends them then to the application server for 
    duplojson = {}
    (measurements,pvec) = com.getpvecmes(neuron_id)
    duplojson['pvec'] = pvec
    duplojson['measurements'] = measurements
    duplojson = json.dumps(duplojson)
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
    response = requests.post(cfg.duplicateinternalurl,data=duplojson,headers=headers)
    resd = response.json()
    lim =  resd["similar_neuron_ids"]['1']["similarity"]
    if float(lim) > cfg.similaritylim:
        raise DuplicateException("Duplicate of neuron: {}".format(resd["similar_neuron_ids"]['1']["neuron_id"]))


def transferneuronfiles(neuron_name):
    def checkdir(path):
        try:
            if islocal:
                os.chdir(path)
            else:
                sftp.chdir(path)
        except IOError as e:
            if islocal:
                os.mkdir(path)
            else:
                sftp.mkdir(path)
    foldername = com.getneuronfolder(neuron_name)
    archive = namefromfolder(foldername)
    if not islocal:
        sftp = create_sftp_client(cfg.sshhost)
    datadir = cfg.sshdir + 'dableFiles/' + archive.lower() + '/'
    swcdir = datadir + 'CNG version/'
    remdir = datadir + 'Remaining issues/'
    stddir = datadir + 'Standardization log/'
    srcdir = datadir + 'Source-Version/'
    gifdir = cfg.sshdir + 'rotatingImages/'
    imgdir = cfg.sshdir + 'images/imageFiles/' + archive + '/'
    checkdir(datadir)
    checkdir(swcdir)
    checkdir(remdir)
    checkdir(stddir)
    checkdir(srcdir)
    checkdir(imgdir)
    lswcdir = cfg.datapath + foldername + '/CNG Version/'
    lremdir = cfg.datapath + foldername + '/Remaining issues/'
    lstddir = cfg.datapath + foldername + '/Standardization log/'
    lsrcdir = cfg.datapath + foldername + '/Source-Version/'
    lgifdir = cfg.datapath + foldername + '/rotatingImages/'
    limgdir = cfg.datapath + foldername + '/Images/PNG/'

    if islocal:
        # check first if the file exists
        swcfile = swcdir + neuron_name + '.CNG.swc'
        if not os.path.exists(swcfile):
            shutil.copy(lswcdir + neuron_name + '.CNG.swc',swcfile)
        remfile = remdir + neuron_name + '.CNG.swc.std'
        if not os.path.exists(remfile):
            shutil.copy(lremdir + neuron_name + '.CNG.swc.std',remfile)
        stdfile = stddir + neuron_name + '.std'
        if not os.path.exists(stdfile):
            shutil.copy(lstddir + neuron_name + '.std',stdfile)
        imgfile = imgdir + neuron_name + '.png'
        if not os.path.exists(imgfile):
            shutil.copy(limgdir + neuron_name + '.png',imgfile)
        
    else:
        sftp.put(lswcdir + neuron_name + '.CNG.swc',swcdir + neuron_name + '.CNG.swc')
        sftp.put(lremdir + neuron_name + '.CNG.swc.std',remdir + neuron_name + '.CNG.swc.std')

    sourcefile = glob.glob(lsrcdir + neuron_name + '.*')[0]
    #logging.info("sourcefile = {}".format(sourcefile))
    filename, file_extension = os.path.splitext(sourcefile)
    

    if islocal:
        srcfile = srcdir + neuron_name + file_extension
        if not os.path.exists(srcfile):
            shutil.copy(sourcefile,srcfile)
    else:
        if os.path.islink(sourcefile):
            targetneuron = utils.path_leaf(os.readlink(sourcefile))
            sftp.put(os.path.join(lsrcdir,targetneuron),srcdir + targetneuron)
            stdin, stdout, ssh_stderr = sftp.sshclient.exec_command('ln -s "{}" "{}"'.format(os.path.join(srcdir,targetneuron),srcdir + neuron_name + file_extension))
            logging.warning('Command failed: {}, {} '.format('ln -s {} {}'.format(os.path.join(srcdir,targetneuron),srcdir + neuron_name + file_extension),ssh_stderr.read()))
        else:
            sftp.put(sourcefile,srcdir + neuron_name + file_extension)
    
    lstdfile = lstddir + neuron_name + '.std'
    stdfile = stddir + neuron_name + '.std' 
      
    #if islocal:
    #    shutil.copy(lstdfile,stdfile)
    #else:
    if not islocal:
        if os.path.islink(lstdfile):
            targetneuron = utils.path_leaf(os.readlink(lstdfile))
            sftp.put(os.path.join(lstddir,targetneuron),stddir + targetneuron)
            stdin, stdout, ssh_stderr = sftp.sshclient.exec_command('ln -s "{}" "{}"'.format(os.path.join(stddir,targetneuron),stdfile))
            logging.warning('Command failed: {}, {} '.format('ln -s {} {}'.format(os.path.join(stddir,targetneuron),stdfile),ssh_stderr.read()))
        else:
            sftp.put(lstdfile,stdfile) 
    
    #if islocal:
    #    shutil.copy(limgdir + neuron_name + '.png',imgdir + neuron_name + '.png')
    #else:
    if not islocal:
        sftp.put(limgdir + neuron_name + '.png',imgdir + neuron_name + '.png')
        sftp.close()
        sftp.sshclient.close()
        

    # only the swc files to main
    # datadir = cfg.sshmaindir + 'dableFiles/' + archive.lower() + '/'
    # swcdir = datadir + 'CNG version/'
    # try:
    #     sftp.chdir(datadir)
    # except IOError as e:
    #     sftp.mkdir(datadir)
    # try:
    #     sftp.chdir(swcdir)
    # except IOError as e:
    #     sftp.mkdir(swcdir)
           
    # sftp.put(lswcdir + neuron_name + '.CNG.swc',swcdir + neuron_name + '.CNG.swc')

    # sftp.close()
    # sftp.sshclient.close()


def transfergif(neuron_name):
    foldername = com.getneuronfolder(neuron_name)
    if islocal:
        # copy gif file using shutil
        lgifdir = cfg.datapath + foldername + '/rotatingImages/'
        gifdir = cfg.sshdir + 'rotatingImages/'
        # check if the file exists
        giffile = gifdir + neuron_name + '.CNG.gif'
        if not os.path.exists(giffile):
            shutil.copy(lgifdir + neuron_name + '.CNG.gif',giffile)
    else:
        sftp = create_sftp_client(cfg.sshhost)
        lgifdir = cfg.datapath + foldername + '/rotatingImages/'
        gifdir = cfg.sshdir + 'rotatingImages/'
        sftp.put(lgifdir + neuron_name + '.CNG.gif',gifdir + neuron_name + '.CNG.gif')
        sftp.close()
        sftp.sshclient.close()
        
def mapneuronfields(pgdict):
    archdict = {'archive_name': pgdict['archive_name'], 
        'archive_URL': pgdict['archive_url']}
    archive_id = com.checkexists('archive','archive_name', archdict)
    species_id = com.checkexists('species','species', {'species': pgdict['species_name']})
    strain_id = com.checkexists('animal_strain','strain_name', {'strain_name': pgdict['strain_name']})
    format_id = com.checkexists('original_format','original_format', {
        'original_format': pgdict['reconstruction'] + '.' + pgdict['originalformat_name']})
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
    result['article_title'] = com.escapechars(remove_html_tags(str(article['ArticleTitle']))).encode('ascii', 'xmlcharrefreplace').decode()
    if "Abstract" in article.keys():
        result['article_abstract'] = com.escapechars(remove_html_tags(str(article['Abstract']['AbstractText'][0])))
    else:
        result['article_abstract'] = ""
    result['article_URL'] = 'https://www.ncbi.nlm.nih.gov/pubmed/{}/'.format(pmid)
    authors = article['AuthorList']
    nauthors = len(authors)
    if "ForeName" in authors[0].keys() and "LastName" in authors[0].keys():
        result["first_author"] = authors[0]['ForeName'] + " " + authors[0]['LastName']
    else:
        result["first_author"] = ""
    if "ForeName" in authors[nauthors-1].keys() and "LastName" in authors[nauthors-1].keys():
        result["last_author"] = authors[nauthors-1]['ForeName'] + " " + authors[nauthors-1]['LastName']
    else:
        result["last_author"] = ""
    result["journal"] = article['Journal']['Title']
    neloc = len(article['ELocationID'])
    if neloc > 0:
        result["doi"] = article['ELocationID'][len(article['ELocationID'])-1].split("'")[0]
        if len(result["doi"]) < 8:
            result["doi"] = article['ELocationID'][0].split("'")[0]
    else:
        result["doi"] = ""
    if len(article['ArticleDate']) > 0:
        result["year"] = article['ArticleDate'][0]['Year']
    else:    
        result["year"]= article['Journal']['JournalIssue']['PubDate']['Year']
    return result

def fetchurlreference(refurl):
    if not validators.url(refurl):
        raise ValueError('Invalid url provided: {}',format(refurl))
    webpage = urlopen(refurl)
    soup = BeautifulSoup(webpage, "lxml")
    result = {}
    result['article_title'] = soup.find('meta', attrs={'name': 'eprints.title'})['content']
    result['article_URL'] = refurl
    result["first_author"] = ""
    result["last_author"] = ""
    result["journal"] = ""
    result["doi"] = ""
    result['year'] = ""
    result['article_abstract'] = ""
    return result

def fetchdoiarticle(doi):
    works = Works()
    rec = works.doi(doi)
    result = {}
    # change this to True if manual
    manual = False
    if manual:
        # Change here if a manual ingestion of article is needed.
        result = {
            'year': '2023',
            'journal': 'Brain Communications',
            'article_title': 'BDDF released from blood platelets prevents dendritic atrophy of lesioned adult CNS neurons',
            'first_author': 'Andrew Want',
            'last_author': 'James Morgan'
        }
    else:
        if rec is None:
            rec = requests.get('https://api.datacite.org/dois/{}'.format(doi)).json()
            if 'data' not in rec.keys():
                raise ValueError('DOI not found: {}. Manual mode for publication needed for ingestion'.format(doi))
            details = rec['data']['attributes']
            authors = details['contributors']
            nauthors = len(authors)
            result['article_title'] = details['titles'][0]['title']
            result["first_author"] = details['contributors'][0]['givenName'] + " " + details['contributors'][0]['familyName']
            if "givenName" in authors[nauthors-1].keys() and "familyName" in authors[nauthors-1].keys():
                result["last_author"] = authors[nauthors-1]['givenName'] + " " + authors[nauthors-1]['familyName']
            else:
                result["last_author"] = ""
            result["journal"] = details['publisher']
            result['year'] = details['publicationYear']
        else:
            result['article_title'] = rec['title'][0].encode('ascii', 'xmlcharrefreplace').decode()
            if 'article_abstract' in result.keys():
                result['article_abstract'] =  re.match("<[^>]*>([^<]*)", rec.get('abstract','')).group(1)
            else:
                result['article_abstract'] = ""
            result['article_URL'] = rec.get('URL','')
            authors = rec['author']
            nauthors = len(authors)
            if "given" in authors[0].keys() and "family" in authors[0].keys():
                result["first_author"] = authors[0]['given'] + " " + authors[0]['family']
            else:
                result["first_author"] = ""
            if "given" in authors[nauthors-1].keys() and "family" in authors[nauthors-1].keys():
                result["last_author"] = authors[nauthors-1]['given'] + " " + authors[nauthors-1]['family']
            else:
                result["last_author"] = ""
            if len(rec['container-title']) > 0:
                result["journal"] = rec['container-title'][0]
            else:
                result["journal"] = ""
            result["year"] = rec['issued']['date-parts'][0][0]
    result["doi"] = doi
    return result


def remove_html_tags(text):
    """Remove html tags from a string"""
    import re
    clean = re.compile('<.*?>')
    return re.sub(clean, '', text)

def transferimages():

    lsimgdir = cfg.scrollpath
    simgdir = cfg.sshmaindir + 'images/scrollingText/'
    sfiles = os.listdir(lsimgdir)
    if not islocal:
        sftp = create_sftp_client(cfg.sshhost)
    for item in sfiles:
        if islocal:
            if os.path.isfile(lsimgdir + item):
                shutil.copy(lsimgdir + item,simgdir + item)
        #logging.info("Putting file: {} ".format(item))
        else:
            sftp.put(lsimgdir + item,simgdir + item)
    if not islocal:
        sftp.close()
        sftp.sshclient.close()


def mainrelease(foldername,dt_string):
    # check that archive has status "published"
    # sync arhives using rsync
    # import to mysql all records
    archive = namefromfolder(foldername)
    print("Dt string in main release".format(dt_string))
    if not islocal:
        sftp = create_sftp_client(cfg.sshhost)
        sshc = sftp.sshclient
    srcdir = cfg.sshdir + "dableFiles/{}/".format(archive.lower())
    destdir = cfg.sshmaindir + "dableFiles/{}/".format(archive.lower())
    logging.info("main release {} *** {}".format(srcdir,destdir))
    logging.info("archive name = {} *** foldername = {} ".format(archive, foldername))
    stdin, stdout, stderr = sshc.exec_command('rsync --links -rupv {} {}'.format(srcdir,destdir))
    srcdir = cfg.sshdir + "images/imageFiles/{}/".format(archive)
    destdir = cfg.sshmaindir + "images/imageFiles/{}/".format(archive)
    logging.info("main release {} *** {}".format(srcdir,destdir))
    stdin, stdout, stderr = sshc.exec_command('rsync -rup {} {}'.format(srcdir,destdir))
    srcdir = cfg.sshdir + "rotatingImages/"
    destdir = cfg.sshmaindir + "rotatingImages/"
    logging.info("main release {} *** {}".format(srcdir,destdir))
    stdin, stdout, stderr = sshc.exec_command('rsync -rup {} {}'.format(srcdir,destdir))
    srcfile = cfg.sshdir + "acknowl.jsp"
    destfile = cfg.sshmaindir + "acknowl.jsp"
    if not islocal:
        stdin, stdout, stderr = sshc.exec_command('sudo rsync -rup {} {}'.format(srcfile,destfile))
    else:
        # run rsync command locally
        subprocess.run(['rsync', '-rup', srcfile, destfile])
    
    neuron_names = exporttomain(foldername)
    archivestatus = com.getarchiveingestionstatus(foldername)
    com.updateuploaddate(neuron_names,dt_string,archivestatus["date"])
    utils.writeimages()
    transferimages()
    
    #stdin, stdout, stderr = sshc.exec_command('curl "http://localhost:8983/solr/search-Main/dataimport?command=full-import')
    #stdin, stdout, stderr = sshc.exec_command('curl "http://localhost:8983/solr/search-Review/dataimport?command=full-import')
    #stdin, stdout, stderr = sshc.exec_command('curl "http://localhost:8983/solr/neuron/dataimport?command=full-import')
    if not islocal:
        sftp.close()
        sshc.close()

def solrcommand(target):
    """
    docstring
    """
    if not islocal:
        sftp = create_sftp_client(cfg.sshhost)
        sshc = sftp.sshclient
        print("sending remote request")
        stdin, stdout, stderr = sshc.exec_command('curl "http://localhost:8983/solr/{}/dataimport?command=full-import"'.format(target))
        print("remote execution requested: out: {}, err:{}".format(stdout.read(),stderr.read()))
        sftp.close()
        sshc.close()
    else:
        print("sending local request")
        subprocess.run(['curl', 'http://localhost:8983/solr/{}/dataimport?command=full-import'.format(target)])

def solrcheckcommand(target):
    """
    docstring
    """
    if not islocal:
        sftp = create_sftp_client(cfg.sshhost)
        sshc = sftp.sshclient
        print("sending remote request: solr check")
        stdin, stdout, stderr = sshc.exec_command('curl "http://localhost:8983/solr/{}/dataimport?command=status"'.format(target))
        output = stdout.read()
        print(output)
        try:
            # check for well formed xml in response
            x = ET.fromstring(output)
        except ET.ParseError as e:
            stdin, stdout, stderr = sshc.exec_command('sudo service solr restart')
            time.sleep(10)
            stdin, stdout, stderr = sshc.exec_command('curl "http://localhost:8983/solr/{}/dataimport?command=status"'.format(target))
            # don't catch 
            output = stdout.read()
            x = ET.fromstring(output)
            
        sftp.close()
        sshc.close()
    else:
        print("sending local request")
        subprocess.run(['curl', 'http://localhost:8983/solr/{}/dataimport?command=status'.format(target)])

def tomcatcommand(app):
    """
    docstring
    """
    if not islocal:
        sftp = create_sftp_client(cfg.sshhost)
        sshc = sftp.sshclient
        print("sending remote request")
        stdin, stdout, stderr = sshc.exec_command('curl -u cliusr:100Neuraldb http://localhost:8080/manager/text/reload?path=/{}'.format(app))
        print("remote execution requested: out: {}, err:{}".format(stdout.read(),stderr.read()))
        sftp.close()
        sshc.close()   
    else:
        print("sending local request")
        subprocess.run(['curl', '-u', 'cliusr:100Neuraldb', 'http://localhost:8080/manager/text/reload?path=/{}/'.format(app)])

def mainworkflow():
    """
    defines the worflow to be executed for the main release
    """
        
    waittime = 60*60
    t6 = tasks.Workflowcomp(solrcheckcommand,waittime)
    t5 = tasks.Workflowcomp(solrcommand,waittime,t6,'search-Main')
    t4 = tasks.Workflowcomp(solrcommand,waittime,t5,'pvec')
    t3 = tasks.Workflowcomp(solrcommand,waittime,t4,'search-Review')
    t2 = tasks.Workflowcomp(solrcommand,waittime,t3,'morphometry')
    t1 = tasks.Workflowcomp(solrcommand,waittime,t2,'neuron')
    t0 = tasks.Workflowcomp(tomcatcommand,1,t1,'search-Main')

    t = Thread(target = t0.execute, args=('neuroMorpho',))
    t.start()

def reviewworkflow():
    """
    docstring
    """
    t0 = tasks.Workflowcomp(tomcatcommand,1)

    t = Thread(target = t0.execute, args=("neuroMorphoDev",))
    t.start()

'''
    Create tweet with fixed message
    fetch and return tweet id
'''
def createtweet(tweet_link, url):
    client = tweepy.Client(consumer_key='y6vLTNiRFwNpcUd4Rk6ntVDo3',
                           consumer_secret='FdSETIgoxXIGkcJseOvgIGQcyZtUr7eFqzdoUB8I9WciJSWFaB',
                           access_token='223121018-2YOxlA3Babx1pqbhtyOHsEYA7l1siy6VenVr46w6',
                           access_token_secret='wfrCDCrkZfu87VbpWH4rcx2OwSi4YhW37ug2oHzisOQ2L')

    consumer_key = 'y6vLTNiRFwNpcUd4Rk6ntVDo3'
    consumer_secret = 'FdSETIgoxXIGkcJseOvgIGQcyZtUr7eFqzdoUB8I9WciJSWFaB'
    access_token = '223121018-2YOxlA3Babx1pqbhtyOHsEYA7l1siy6VenVr46w6'
    access_token_secret = 'wfrCDCrkZfu87VbpWH4rcx2OwSi4YhW37ug2oHzisOQ2L'

    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)

    api = tweepy.API(auth)

    message = "New report using reconstructions from NeuroMorpho.Org: " + tweet_link

    tweet_id = client.create_tweet(text=message)
    id = tweet_id.data['id']

    return id

'''
    Create tweet with new customize message (2024/04/02)
    fetch and return tweet id
'''
def createtweets(tweet_link, url):
    client = tweepy.Client(consumer_key='y6vLTNiRFwNpcUd4Rk6ntVDo3',
                           consumer_secret='FdSETIgoxXIGkcJseOvgIGQcyZtUr7eFqzdoUB8I9WciJSWFaB',
                           access_token='223121018-2YOxlA3Babx1pqbhtyOHsEYA7l1siy6VenVr46w6',
                           access_token_secret='wfrCDCrkZfu87VbpWH4rcx2OwSi4YhW37ug2oHzisOQ2L')

    consumer_key = 'y6vLTNiRFwNpcUd4Rk6ntVDo3'
    consumer_secret = 'FdSETIgoxXIGkcJseOvgIGQcyZtUr7eFqzdoUB8I9WciJSWFaB'
    access_token = '223121018-2YOxlA3Babx1pqbhtyOHsEYA7l1siy6VenVr46w6'
    access_token_secret = 'wfrCDCrkZfu87VbpWH4rcx2OwSi4YhW37ug2oHzisOQ2L'

    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)

    api = tweepy.API(auth)

    message = "" + tweet_link

    tweet_id = client.create_tweet(text=message)
    id = tweet_id.data['id']

    return id

'''
    Create tweet with customize message
    fetch and return tweet id
'''
def createtweetcustomize(tweet_link):
    client = tweepy.Client(consumer_key='y6vLTNiRFwNpcUd4Rk6ntVDo3',
                           consumer_secret='FdSETIgoxXIGkcJseOvgIGQcyZtUr7eFqzdoUB8I9WciJSWFaB',
                           access_token='223121018-2YOxlA3Babx1pqbhtyOHsEYA7l1siy6VenVr46w6',
                           access_token_secret='wfrCDCrkZfu87VbpWH4rcx2OwSi4YhW37ug2oHzisOQ2L')

    consumer_key = 'y6vLTNiRFwNpcUd4Rk6ntVDo3'
    consumer_secret = 'FdSETIgoxXIGkcJseOvgIGQcyZtUr7eFqzdoUB8I9WciJSWFaB'
    access_token = '223121018-2YOxlA3Babx1pqbhtyOHsEYA7l1siy6VenVr46w6'
    access_token_secret = 'wfrCDCrkZfu87VbpWH4rcx2OwSi4YhW37ug2oHzisOQ2L'

    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)

    api = tweepy.API(auth)

    message = tweet_link

    tweet_id = client.create_tweet(text=message)
    id = tweet_id.data['id']


    return id


'''
    use tweet link to obtain 'Embedded Tweet'
'''
def embedded_tweet(tweet_url):
    oembed_url = "https://publish.twitter.com/oembed"
    params = {'url': tweet_url}
    try:
        response = requests.get(oembed_url, params=params)

        if response.status_code == 200:
            data = response.json()
            embed_code = data.get('html')
            return embed_code
        else:
            print("Failed to fetch Twitter embed code. Status code:", response.status_code)
            return None
    except requests.exceptions.RequestException as e:
        print("An error occurred:", e)
        return None


def tweet_index_embed(embed_code):
    if not islocal:
        sftp = create_sftp_client(cfg.sshhost)
        winpath = '/usr/share/tomcat/apache-tomcat-7.0.54/webapps/neuroMorpho/' + 'index.jsp'
        with sftp.file(winpath, 'r+') as sfile:
            lines = sfile.readlines()
            updated_lines = []

            for line in lines:
                updated_lines.append(line)
                if "<!-- START EMBED -->" in line:
                    updated_lines.append(embed_code + "\n")

            sfile.seek(0)
            sfile.writelines(updated_lines)
        sftp.close()
        sftp.sshclient.close()
    else:
        winpath = cfg.sshdir + 'index.jsp'
        with open(winpath, 'r+') as file:
            lines = file.readlines()
            updated_lines = []

            for line in lines:
                updated_lines.append(line)
                if "<!-- START EMBED -->" in line:
                    updated_lines.append(embed_code + "\n")

            file.seek(0)
            file.writelines(updated_lines)




