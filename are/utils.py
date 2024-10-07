import logging
import glob
from PIL import Image, ImageDraw,ImageFont
import PIL
import os,operator, sys
from . import cfg,com,io
import filecmp


def addunderscore(archive):
    """
    Adds underscore to an archive so that it may be processed
    """
    pass



def writeimages(namesmsg = {},imgsize=(300,20),fntsize=12):
    """
    writes images according to filenames in keys in dict namesmsg with values messages
    """
    if len(namesmsg) == 0: 
        metrics = com.getmetrics()
        logging.info("Ticker Tape : {} ".format(metrics))
        namesmsg = {
            "111.png": "{} digital reconstructions".format(metrics["nneurons"]), 
            "222.png": "Contributions from {} laboratories".format(metrics["nlabs"]),
            "333.png": "Reconstructions from {} celltypes".format(metrics["ncelltypes"]),
            #"444.png": "Reconstructions from {} brain regions".format(metrics["nregions"]),
            # the number has to match about.jsp
            "444.png": "Reconstructions from {} brain regions".format(470),
            "555.png": ">{} million h of manual reconstructions".format(6.63), # 6.631902
            "666.png": "{} meters reconstructed neuropil".format(794),# 794.2777602921731
            "777.png": "{} million neuronal branches".format(25.14), # 25.1373
            "888.png": "Visitors from {} countries".format(210), # 210
            "999.png": "{} billion dollar branches downloaded".format(1.9)   
        }

    W, H = imgsize
    fnt = ImageFont.truetype(font="fonts/verdanab.ttf",size=12)
    for item in namesmsg:
        animg = Image.new(mode="RGBA", size=imgsize)
        
        d = ImageDraw.Draw(animg)
        w, h = d.textsize(namesmsg[item],font=fnt)
        d.text(((W-w)/2,(H-h)/2),namesmsg[item] ,font=fnt,fill=(0,0,0,255))
        imgpath = os.path.join(cfg.scrollpath,item)
        animg.save(imgpath,'PNG')

def swcsomafirst(archive,remotedir=cfg.sshreviewdir,mirrordirs=[]):
    """
    For a given archive folder reaarranges the swc files so that the soma is first, 
    either locally and/or possible at target servers 
    Local targets indicated by list of basefolders 
    Remote targets indicated by a dict of servernames and basefolders. 
    """
    def representsint(s):
        try: 
            int(s)
            return True
        except ValueError:
            return False

    neurons = com.my_getarchiveneurons(archive)
    sftp = io.create_sftp_client('cng.gmu.edu')
    for item in neurons:
        itemchanged = False
        neuronpath = os.path.join(remotedir,'dableFiles',archive.lower(),'CNG version',item + '.CNG.swc')
        with sftp.file(neuronpath,'r') as sfile:
            lines = sfile.readlines()
        newlines = []
        nsomas = 0
        swcstartct = 0
        #Keeping track of old indices
        oldixs = []
        curix = 1
        for line in lines:
            elems = line.strip().split()
            if len(elems) > 0 and elems[0] == '1':
                swcstart = swcstartct
            swcstartct += 1
            
            if len(elems) > 1 and elems[1] == '1':
                newlines.insert(swcstart+nsomas,line)
                nsomas += 1
                if swcstart + nsomas != swcstartct:
                    itemchanged = True
            else:
                newlines.append(line)   
        print('Archive: {}, cell: {}. Rearranged: {}'.format(archive,item,itemchanged))

        if itemchanged:
            rowct = 1
            correctedlines = []
            for line in newlines:
                elems = line.strip().split()
                if representsint(elems[0]):
                    elems[0] = str(rowct)
                    #Convert to relevant values
                    elems = [str(rowct), str(int(elems[1])), str(float(elems[2])), str(float(elems[3])), str(float(elems[4])), str(float(elems[5])), str(int(elems[6]))]
                    if elems[1] != '1' and elems[6] != '1' and int(elems[0]) > nsomas+1:
                        elems[6] = str(int(elems[6]) + nsomas-1)
                    newline = ' ' + ' '.join(elems) + '\n'
                    correctedlines.append(newline)
                    rowct += 1
                else:
                    correctedlines.append(line)
            with sftp.file(neuronpath,'w') as sfile:
                sfile.writelines(correctedlines)
    sshc = sftp.sshclient
    for item in mirrordirs:
        srcpath = os.path.join(remotedir,'dableFiles',archive.lower(),'CNG version/')
        dstpath = os.path.join(item,'dableFiles',archive.lower(),'CNG version/')
        sshc.exec_command("sudo rsync -ruv '{}' '{}'".format(srcpath,dstpath))
    sshc.close()
    sftp.close()        


def checkswctosource(sourcefolder,swcfolder):
    """
    1) Checks if numbers of files in source folder is the same as in the swcfolder
    2) If not, for all sourcefiles, find the patterns in the swc files folder matching the sourcefile.
    3) Change name of the sourcefile to match the first swc file (in alphabetic order)
    4) Create soft links to match with the swc-files
    checks and return dict with similar files, with name of first occurrence as key, 
    and the duplicates as vals. 
    """
    sourcefiles = os.listdir(sourcefolder)
    swcfiles = os.listdir(swcfolder)
    if len(sourcefiles) == len(swcfiles):
        return {}
    swcmatches = {}
    allmatches = []
    for item in sourcefiles:
        nname,nending = item.split('.')
        longermatches = [asrc for asrc in sourcefiles if asrc != item and nname in asrc]
        searchpath = os.path.join(swcfolder,nname) + '?*.CNG.swc'
        thematches = glob.glob(searchpath)
        if len(thematches) > 0:
            swcmatches[item] = [os.path.basename(anit).split('.')[0]+ '.' + nending for anit in thematches]
            # if there is a longer match then remove it
            swcmatches[item] = [ansrc for ansrc in swcmatches[item] if not any([lmatch.split('.')[0] in ansrc for lmatch in longermatches])]
            allmatches += swcmatches[item]
            if len(swcmatches[item]) == 0:
                del swcmatches[item]
    allmatches = set(allmatches)
    swcfiles = set(swcfiles)
    thediff =swcfiles.difference(allmatches)
    return swcmatches

    

def checkduplicatefiles(folder,swcfolder=''):
    """
    docstring
    """
    
    dirpath = os.path.abspath(folder)
    # make a generator for all file paths within dirpath
    
    
    all_files = ( os.path.join(basedir, filename) for basedir, dirs, files in os.walk(dirpath) for filename in files   )
    # make a generator for tuples of file path and size: ('/Path/to/the.file', 1024)
    files_and_sizes = ( (path, os.path.getsize(path)) for path in all_files )
    sorted_files_with_size = sorted( files_and_sizes, key = operator.itemgetter(1) )
    folderfiles = [os.path.splitext(path_leaf(item[0]))[0] for item in sorted_files_with_size]
    folderfilesext = [path_leaf(item[0]) for item in sorted_files_with_size]
    if swcfolder != '':
        swcfiles = [path_leaf(item).split('.')[0] for item in os.listdir(swcfolder)]
        missingfiles = [item for item in swcfiles if item not in folderfiles]
    else:
        missingfiles = [] 
    prevsize = 0
    prevname = ""
    thesims = {}
    grouptocellmap = {}
    for item in sorted_files_with_size:
        if (item[1] == prevsize and filecmp.cmp(item[0],prevname)):
            if prevname in thesims.keys():
                thesims[prevname].append(item[0])
            else:
                thesims[prevname] = [item[0]]
                groupname = prevname.split('_')[0]
                grouptocellmap[groupname] = prevname
        else:
            prevname = item[0]  
            prevsize = item[1] 
    for item in thesims:
        for subitem in thesims[item]:
            pass
            #os.remove(subitem)
        
        
        #assert len(itemparts) == 1 and len(missingfiles) != 0, "Source files are fewer than SWC files, but no group designated through SWC filename"
    for item in folderfilesext:
        # add items missing in the swcfiles
        itemparts = item.split("_")
        itemending = os.path.splitext(item)[1]
        thisgroup = itemparts[0]
        missingsims = [mitem + itemending for mitem in missingfiles if path_leaf(mitem).split('_')[0] == thisgroup]
        
        for mitem in missingsims:
            if item in thesims.keys():
                thesims[item].append(mitem)
            else:
                thesims[item] = [mitem]
    
    return thesims

def path_leaf(path):
        head, tail = os.path.split(path)
        return tail or os.path.basename(head)

def createsymlinks(target,sources,folder,server=""):
    """
    create symlinks to target neuron for all source neurons in a specified folder at the designated server (if provided, otherwise create locally).
    """
    folder = folder.replace(' ','\ ')
    targetpath = os.path.join(folder,path_leaf(target))
    if server != "":
        sftp = io.create_sftp_client(server)
        sshc = sftp.sshclient
    for item in sources[target]:
        itempath = os.path.join(folder,path_leaf(item))
        if server != "":
            sshc.exec_command('ln -s {} {}'.format(targetpath,itempath))
        else:
            os.system('ln -s {} {}'.format(targetpath,itempath))

def createmetachildren(sources,folder):
    """
    create metadata children for all source neurons in a specified folder locally
    Goes through files and if finding match, creates children for that file
    """
    for (root,_,files) in os.walk(folder,topdown=False):
        for file in files:
            neuron = file.split('.')[0]
            sourcekeys = list(sources.keys())
            if len(sourcekeys) > 0:
                ending = sourcekeys[0].split('.')[-1]
            if neuron in [item.split(".")[0] for item in sourcekeys]:
                for child in sources[neuron + '.' + ending]:
                    childname =  child.split('.')[0] + '.CNG.swc'
                    childpath = os.path.join(root,childname)
                    open(childpath,'w').close()
                os.remove(os.path.join(root,file))



def loginit():
    logging.basicConfig(filename='app.log', filemode='w', format='%(asctime)s %(name)-12s %(levelname)-8s %(message)s')
    logging.warning('This will get logged to a file')
