import psycopg2
import psycopg2.extras
import paramiko
import mysql.connector as mysc
from . import cfg
from . import io
from datetime import datetime



def pgconnect(f):
    #decorator for postgres operations
    def pgconnect_(*args, **kwargs):
        conn = psycopg2.connect(host="localhost",database="nmo", user="nmo", password="100neuralDB")
        conn.autocommit = True
        try:
            rv = f(conn, *args, **kwargs)
        except Exception:
            raise
        finally:
            conn.close()
        return rv
    return pgconnect_


def escapechars(a_string):
    tdict = {
        "]":  "",
        "[":  "",
        "^":  "",
        "$":  "",
        "*":  "",
        ".":  "",
        "'":  ""
    }
    for item in tdict:
        a_string = a_string.replace(item, tdict[item])
    return a_string

def myconnect(f):
    #decorator for MySQL operations
    def myconnect_(*args, **kwargs):
        conn = mysc.connect(user=cfg.dbuser, password=cfg.dbpass, host=cfg.dbhost, database=cfg.dbsel)
        conn.autocommit = True
        try:
            rv = f(conn, *args, **kwargs)
        except Exception:
            raise
        finally:
            conn.close()
        return rv
    return myconnect_

@pgconnect
def getarchiveneuronstatus(conn,archive):
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    stmt = "SELECT * from ingestion where archive = '{}'".format(archive)
    cur.execute(stmt)
    result = []
    res = cur.fetchone()
    if res:
        res = dict(res)
    while res:
        result.append(res)
        res = cur.fetchone()
        if res:
            res = dict(res)
    return result

@pgconnect
def deletearchive(conn,archive):
    cur = conn.cursor()
    stmt = "DELETE FROM archive where name = '{}'".format(archive)
    cur.execute(stmt)
    stmt = "DELETE FROM ingested_archives where name = '{}'".format(archive)
    cur.execute(stmt)
    stmt = "DELETE FROM ingestion where archive = '{}'".format(archive)
    cur.execute(stmt)

@myconnect
def deleteingestedneurons(conn,neuronarr):
    cur = conn.cursor()
    stmt = "DELETE FROM neuron where neuron.neuron_name IN ('{}')".format("','".join(neuronarr))
    cur.execute(stmt)
    

@pgconnect
def getarchiveingestionstatus(conn,archive):
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    stmt = "SELECT name, date, message, status from ingested_archives where name = '{}'".format(archive)
    cur.execute(stmt)
    res = cur.fetchone()
    if res:
        result = dict(res)
    else:
        result = {}
    return result

@pgconnect
def getpvec(conn,neuron_id):
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute('select * from pvec where neuron_id ={}'.format(neuron_id))
    res = cur.fetchall()
    if res:
        result = dict(res[0])
    else:
        result = {}
    return result   


def exportpvec(neuron_id,oldid):
    dpvec = getpvec(neuron_id)
    dpvec["Sfactor"] = dpvec.pop("sfactor")
    del dpvec["id"]
    dpvec["neuron_id"] = oldid
    coeffs = dpvec["coeffs"]
    del dpvec["coeffs"]
    dcoeffs = {"coeff{0:0=2d}".format(i): j for (i,j) in enumerate(coeffs)}
    newd = {**dpvec,**dcoeffs}
    myinsert("persistance_vector",newd)


@myconnect
def insertbrainregions(conn,regdict,neuron_id):
    # inserts a region by checking if exists in region table and then in the connecting table 
    regionlabels = ['region1','region2','region3','region3B']
    cur = conn.cursor()
    level = 0
    for item in regionlabels:
        level += 1
        name = escapechars(regdict[item])
        statement = "select id from brainRegion where name = '{}'".format(name)
        cur.execute(statement)
        res = cur.fetchone()  
        if res is None:
            brid = myinsert('brainRegion',{'name': name})
        else:
            brid = res[0]
        myinsert('brainRegion_neuron',{'brainRegionLevel': level, 'brainRegionId': brid,'neuronId': neuron_id})

@myconnect
def insertcelltypes(conn,celldict,neuron_id):
    # inserts a region by checking if exists in region table and then in the connecting table 
    typelabels = ['class1','class2','class3','class3B','class3C']
    cur = conn.cursor()
    level = 0
    for item in typelabels:
        level += 1
        name = celldict[item]
        statement = "select id from cellType where name = '{}'".format(name)
        cur.execute(statement)
        res = cur.fetchone()  
        if res is None:
            brid = myinsert('cellType',{'name': name})
        else:
            brid = res[0]
        myinsert('cellType_neuron',{'cellTypeLevel': level, 'cellTypeId': brid,'neuronId': neuron_id})

def insertdeposition(oldid,adict):
    data = {'neuron_id': oldid,
        'neuron_name': adict['name'],
        'deposition_date': adict['depositiondate'],
        'upload_date': adict['uploaddate']}
    myinsert('deposition',data)

@pgconnect
def inserttissueshrinkage(conn,neuron_id,oldid):
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    stmt = """SELECT name, shrinkage, reported_value, reported_xy, reported_z, corrected_value, corrected_xy, corrected_z 
    FROM neuron,shrinkagevalue 
    WHERE neuron.shrinkagevalue_id = shrinkagevalue.id and neuron.id = {} """.format(neuron_id)
    cur.execute(stmt)
    res = cur.fetchone()
    typedict = {"reported and corrected": 1,
        "reported and not corrected": 2,
        "Not reported": 3,
        "not applicable": 4,
        "Not applicable": 4}
    repdict = {"reported and corrected": 'Reported',
        "reported and not corrected": 'Reported',
        "Not reported": 'Not reported',
        "not applicable": "Not applicable",
        "Not applicable": "Not applicable"}
    corrdict = {"reported and corrected": 'Corrected',
        "reported and not corrected": 'Not corrected',
        "Not reported": '',
        "not applicable": '',
        "Not applicable": ''}
    data = {'neuron_name': res['name'],
        'shrinkage_reported': repdict[res['shrinkage']],
        'shrinkage_corrected': corrdict[res['shrinkage']],
        'reported_value': res['reported_value'],
        'reported_xy': res['reported_xy'],
        'reported_z': res['reported_z'],
        'corrected_value': res['corrected_value'],
        'corrected_xy': res['corrected_xy'],
        'corrected_z': res['corrected_z'],
        'shrinkage_type_id': typedict[res['shrinkage']],
        'neuron_id': oldid
    }
    myinsert('Tissue_shrinkage',data)

@pgconnect
def insertcompleteness(conn,neuron_id,oldid,adict):
    cur = conn.cursor()
    stmt = "SELECT completeness, domain, morph_attributes FROM neuron_structure WHERE neuron_id = {}".format(neuron_id)
    cur.execute(stmt)
    res = cur.fetchall()
    morph_attr = res[0][2]
    dcompl = {item[1]: item[0] for item in res}
    #decide domain 
    data = {}
    
    dkeys = dcompl.keys()
    has_soma = adict['has_soma']
    cdict = {'Complete':2, 'Moderate': 1, 'Incomplete':0}
    combdict = {'Complete':{'Complete': 7, 'Moderate': 6, 'Incomplete': 5},
        'Moderate':{'Complete': 8, 'Moderate': 4, 'Incomplete': 3},
        'Incomplete':{'Complete': 14, 'Moderate': 1, 'Incomplete':13},
    }
    data = {'PMID': adict['publication_pmid'],
        'domain_id': 0,
        'den_integrity_id': -1,
        'ax_integrity_id': -1,
        'den_ax_integrity_id': -1,
        'attributes_id': 3,
        'curated': 1,
        'neu_integrity_id': -1,
        'pr_integrity_id': -1
    }
    if 'NEU' in dkeys:
        data['neu_integrity_id'] = cdict[dcompl['NEU']]
        if has_soma:
            data['domain_id'] = 9
        else:
            data['domain_id']  = 8
    elif 'PR' in dkeys:
        data['pr_integrity_id'] = cdict[dcompl['PR']]
        if has_soma:
            data['domain_id']  = 11
        else:
            data['domain_id']  = 10
    elif 'AP' in dkeys or 'BS' in dkeys:
        if 'AP' in dkeys:
            data['den_integrity_id'] = cdict[dcompl['AP']]
            if 'AX' in dkeys:
                data['den_ax_integrity_id'] = combdict[dcompl['AP']][dcompl['AX']]
        else:
            data['den_integrity_id'] = cdict[dcompl['BS']]
            if 'AX' in dkeys:
                data['den_ax_integrity_id'] = combdict[dcompl['BS']][dcompl['AX']]
        if 'AX' in dkeys:
            data['ax_integrity_id'] = cdict[dcompl['AX']]
            if has_soma:
                data['domain_id']  = 7
            else:
                data['domain_id']  = 5
        else:
            if has_soma:
                data['domain_id']  = 6
            else:
                data['domain_id']  = 4
    else:
        #only axon
        data['ax_integrity_id'] = cdict[dcompl['AX']]
        if has_soma:
            data['domain_id']  = 3
        else:
            data['domain_id']  = 1
    data['attributes_id'] = morph_attr
    data['neuron_id'] = oldid
    myinsert('neuron_completeness',data)
        


@pgconnect
def exportmeasurements(conn,neuron_id,oldid,neuron_name):
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    stmt = "select measurements.* from measurements,neuron where neuron.id = {} AND neuron.summary_meas_id = measurements.id".format(neuron_id)
    cur.execute(stmt)
    res = cur.fetchone()
    res2 = {item[0].upper() + item[1:]: res[item] for item in res.keys()}
    del res2['Id']
    res2['Neuron_name'] = neuron_name 
    res2['neuron_id'] = oldid
    myinsert('measurements',res2)
    return res2


@pgconnect
def getrowasdict(conn,table,id):
    statement = """
    SELECT column_name
    FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name   = '{}'""".format(table)
    cur = conn.cursor()
    cur.execute(statement)
    result = cur.fetchall()
    cols = [item[0] for item in result]
    statement = "SELECT {} from {} where {}.id = {}".format(','.join(cols),table,table,id)
    cur.execute(statement)
    result = cur.fetchone()
    if result is None:
        return None
    else:
        #resdict =  dict(zip(cols,result))
        resdict =  {table + '_' + key: val for key,val in zip(cols,result)}
        return resdict

@pgconnect
def getmyregions(conn,path):
    statement = "select name from region where path @> '{}' order by path".format(path)
    cur = conn.cursor()
    cur.execute(statement)
    res = cur.fetchall()
    result = {}
    regionlabels = ['region1','region2','region3','region3B']
    defaultval = ['Not reported'] * 4
    result = {key:val for key,val in zip(regionlabels,defaultval)}
    for ix in range(len(res)):
        result[regionlabels[ix]] = res[ix][0]
    return result

@pgconnect
def getmycelltypes(conn,path):
    statement = "select name from celltype where path @> '{}' order by path".format(path)
    cur = conn.cursor()
    cur.execute(statement)
    res = cur.fetchall()
    result = {}
    typelabels = ['class1','class2','class3','class3B','class3C']
    defaultval = ['Not reported'] * 5
    result = {key:val for key,val in zip(typelabels,defaultval)}
    for ix in range(len(res)):
        result[typelabels[ix]] = res[ix][0]
    return result

# @myconnect
# def insertbrainregions(conn,neuron_id,:
#     # checks if region exists at specified level
#     cur = conn.cursor()
#     statement = """SELECT 
#     DISTINCT brainRegion_neuron.brainRegionId, 
#     brainRegion_neuron.brainRegionLevel, 
#     brainRegion.name, 
#     brainRegion_neuron.brainRegionLevel 
#     FROM 
#         brainRegion_neuron 
#     INNER JOIN 
#         brainRegion 
#     ON 
#         ( 
#             brainRegion_neuron.brainRegionId = brainRegion.id) 
#     WHERE 
#         brainRegion_neuron.brainRegionLevel = {} 
#     AND brainRegion.name = '{}';""".format(level,name)
#     cur.exexute(statement)
#     res = cur.fetchall()
#     return len(res) > 0

""" @pgconnect
def getregionname(conn,path):
    cur = conn.cursor()
    stmt = "select name from region where path = '{}'".format(path)
    cur.execute(stmt)
    res = cur.fetchone()
    return res[0] """

""" def checkregion(path):
    # checks if Region at level as indicated by path
    # if not, inserts item and then checks parent path by recursive call
    # if so, checks parents to see if they are the same by recursive call
    patharr = path.split('.')
    level = len(patharr)
    name = getregionname(path)
    if checkreglvl(name,level):
        insertregion
    if level !=1:
        checkregion('.'.join(patharr[0:-1])) """

@pgconnect
def getneuronsforexport(conn,neuronclause = ''):
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    stmt = """SELECT neuron.*
    FROM 
        neuron 
    INNER JOIN 
        export 
    ON 
        ( 
            export.neuron_id = neuron.id) 
    WHERE 
        (export.status = 'ready' OR export.status = 'error'{})""".format(neuronclause)
    cur.execute(stmt)
    res = cur.fetchall()
    return res

@pgconnect
def getneuronforexport(conn,neuron_name):
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    stmt = """SELECT neuron.*
    FROM 
        neuron 
    WHERE 
        neuron.name = '{}'""".format(neuron_name)
    cur.execute(stmt)
    res = cur.fetchall()
    return res


def getneurondata(neuron_name):
    alist = getneuronforexport(neuron_name)
    item = alist[0]
    archive_id = item['archive_id']
    item = {**item, **getrowasdict('archive',archive_id)}

    region_id = item['region_id']
    item = {**item, **getrowasdict('region',region_id)}
    item = {**item, **getmyregions(item['region_path'])}

    celltype_id = item['celltype_id']
    item = {**item, **getrowasdict('celltype',celltype_id)}
    item = {**item, **getmycelltypes(item['celltype_path'])}

    publication_id = item['publication_id']
    item = {**item, **getrowasdict('publication',publication_id)}

    expcond_id = item['expcond_id']
    item = {**item, **getrowasdict('expcond',expcond_id)}

    summary_meas_id = item['summary_meas_id']
    item = {**item, **getrowasdict('measurements',summary_meas_id)}

    originalformat_id = item['originalformat_id']
    item = {**item, **getrowasdict('originalformat',originalformat_id)}

    staining_id = item['staining_id']
    item = {**item, **getrowasdict('staining',staining_id)}

    shrinkagevalue_id = item['shrinkagevalue_id']
    item = {**item, **getrowasdict('shrinkagevalue',shrinkagevalue_id)}

    strain_id = item['strain_id']
    item = {**item, **getrowasdict('strain',strain_id)}

    species_id = item['strain_species_id']
    item = {**item, **getrowasdict('species',species_id)}

    expcond_id = item['expcond_id']
    item = {**item, **getrowasdict('expcond',expcond_id)}
    
    return item

def getallreadydata():
    # gets all ready neurons
    # prepares full dict for neuron, including measurements, shrinkage, region  pvec
    neurons = getneuronsforexport()

    result = []
    for item in neurons:
        archive_id = item['archive_id']
        item = {**item, **getrowasdict('archive',archive_id)}

        region_id = item['region_id']
        item = {**item, **getrowasdict('region',region_id)}
        item = {**item, **getmyregions(item['region_path'])}

        celltype_id = item['celltype_id']
        item = {**item, **getrowasdict('celltype',celltype_id)}
        item = {**item, **getmycelltypes(item['celltype_path'])}

        publication_id = item['publication_id']
        item = {**item, **getrowasdict('publication',publication_id)}

        expcond_id = item['expcond_id']
        item = {**item, **getrowasdict('expcond',expcond_id)}

        summary_meas_id = item['summary_meas_id']
        item = {**item, **getrowasdict('measurements',summary_meas_id)}

        originalformat_id = item['originalformat_id']
        item = {**item, **getrowasdict('originalformat',originalformat_id)}

        staining_id = item['staining_id']
        item = {**item, **getrowasdict('staining',staining_id)}

        shrinkagevalue_id = item['shrinkagevalue_id']
        item = {**item, **getrowasdict('shrinkagevalue',shrinkagevalue_id)}

        strain_id = item['strain_id']
        item = {**item, **getrowasdict('strain',strain_id)}

        species_id = item['strain_species_id']
        item = {**item, **getrowasdict('species',species_id)}

        expcond_id = item['expcond_id']
        item = {**item, **getrowasdict('expcond',expcond_id)}
        
        result.append(item)
    return result

def cleanstr(astring):
    astring = astring.replace(' ','_')
    return "".join([c for c in astring if c.isalpha() or c.isdigit() or c == '_']).rstrip()

def cleanerr(astring):
    return "".join([c for c in astring if c.isalpha() or c.isdigit() or c == '_' or c == ' ']).rstrip()

def cleanval(astring):
    return astring.replace(',','')

def connect():  
    conn = psycopg2.connect(host="localhost",database="nmo", user="nmo", password="100neuralDB")
    conn.autocommit = True
    return conn

def insert(tablename,data):
    # takes data with fields as keys in dictionary, data as values
    conn=connect()
    cur = conn.cursor()
    # clean 'NULL' Values
    values = ''
    data = {item: data[item] for item in data if data[item] is not None } 
    data = {item: data[item] for item in data if data[item] != 'NULL'}
    
        
    for item in data:
        if isinstance(data[item],str):
            values += "'{}',".format(data[item])
        else:
            values += str(data[item]) + ','
    values = values[:-1]
    
    fields = ",".join(data.keys())
    if len(data) == 0:
        statement = "INSERT INTO {}(id) VALUES(DEFAULT)".format(tablename)
    else:
        statement = """INSERT INTO {}({}) VALUES ({}) """.format(tablename,fields,values)
    cur.execute(statement)  
    cur.execute("SELECT currval(pg_get_serial_sequence('{}','id'))".format(tablename))
    result = cur.fetchone()
    inserted_id = result[0]
    conn.close()
    return inserted_id

@myconnect
def myinsert(conn,tablename,data):
    # takes data with fields as keys in dictionary, data as values
    cur = conn.cursor()
    data = {item: data[item] for item in data if data[item] is not None}
    fields = ",".join(data.keys())
    values = "','".join([str(item) for item in data.values()])
    statement = """INSERT INTO {}({}) VALUES ('{}') """.format(tablename,fields,values)
    cur.execute(statement)  
    cur.execute("select LAST_INSERT_ID()")
    result = cur.fetchone()
    inserted_id = result[0]
    return inserted_id

@pgconnect
def updateneuronstatus(conn,neuron_name, status,message = ''):
    cur = conn.cursor()
    stmt = "UPDATE ingestion set status = '{}', message = '{}' where neuron_name = '{}'".format(status,message,neuron_name)
    cur.execute(stmt)


def isindb(tablename, column, value):
    # check if value in table of specified column is in db
    conn=connect()
    cur = conn.cursor()
    statement = "SELECT {} FROM {} where {} = '{}'".format(column,tablename,column,value)
    cur.execute(statement)
    result = cur.fetchone()
    return result is not None

def ingestneuron(d):
    #inserts one neuron with values from dictionary d
    # TODO add parameters. 
    nonechecks= ['min_weight','max_weight']
    for item in nonechecks:
        if d[item] == 'Not reported': 
            d[item] = 'NULL'
    if d['shrinkval_id'] == 0:
        d['shrinkval_id'] = "NULL"
    if d['URL_reference'] is None:
        d['URL_reference'] = " "
    else:
        d['URL_reference']  = "'{}'".format(d['URL_reference'])

    for item in d:
        if isinstance(d[item],str):
            d[item] = escapechars(d[item])
    conn=connect()
    cur = conn.cursor()
    statement = """CALL ingest_data('{}', '{}', '{}',  '{}', '{}','{}' , '{}' , '{}','{}', '{}','{}','{}', '{}','{}', '{}', '{}', '{}', '{}', cast({} as boolean), '{}' , '{}' , '{}', {}, {},{},{}, '{}', '{}','{}', '{}', {},'{}','{}',  null)""".format(d['neuron_name'],d['archive'],d['URL_reference'],d['species'],d['expercond'],d['age_classification'],d['region'],d['celltype'],d['deposition_date'],d['uploaddate'],
     d['magnification'],d['objective'],d['format'],d['protocol'],d['slice_direction'],str(d['thickness']),d['stain'],d['strain'],
     str(d['has_soma']),d['shrinkage_reported'],d['age_scale'],d['gender'],str(d['max_age']),str(d['min_age']),d['min_weight'],
     d['max_weight'],d['note'],str(d['pmid']),d['doi'],str(d['sum_mes_id']),str(d['shrinkval_id']),d['reconstruction'],d['URL_reference'])
    cur.execute(statement)
    result = cur.fetchone()
    neuron_id = result[0]
    conn.close()
    return neuron_id

@myconnect
def getarticleid(conn,pmid):
    """ Gets the article id for insertion.
    """
    cur = conn.cursor()
    stmt = "SELECT DISTINCT article_id FROM neuron_article where PMID = {}".format(pmid)
    cur.execute(stmt)
    res = cur.fetchone()
    if res is None:
        pmrecord = io.fetchpmarticle(str(pmid))
        refrec = pmrecord
        del refrec["first_author"] 
        del refrec["last_author"] 
        del refrec["journal"] 
        del refrec["doi"] 
        del refrec["year"]
        res = myinsert('reference_article',refrec)
        stmt = "SELECT Paper_ID FROM AllPublications where PMID = {}".format(pmid)
        cur.execute(stmt)
        res2 = cur.fetchone()
        if res2 is None:
            pmrecord = io.fetchpmarticle(str(pmid))
            now = datetime.now()
            dt_string = now.strftime("%Y-%m-%d %H:%M:%S")
            myinsert('AllPublications', {
                'PMID': pmid,
                'DOI': pmrecord['doi'],
                'Year': pmrecord['year'],
                'Journal': pmrecord['journal'],
                'Paper_Title': pmrecord['article_title'],
                'First_Author': pmrecord['first_author'],
                'Last_Author': pmrecord['last_author'],
                'OCDate': dt_string,
                'Data_Status': 'In the repository'
            })
        return  res
    else:
        return res[0]


@pgconnect
def exportpublication(conn,oldid,neuron_id):
    """ Check if exists in neuron_article table. If so, select article id
    If not, check max. Increment article id and insert. Otherwise, insert with existing article id.
    """
    
    cur = conn.cursor()
    stmt = """SELECT publication.PMID from publication,neuron 
        WHERE neuron.publication_id = publication.id
        AND neuron.id={}""".format(neuron_id)
    cur.execute(stmt)
    res = cur.fetchone()
    pmid = res[0]
    
    article_id = getarticleid(pmid)
    

    myinsert('neuron_article',{
        'neuron_id': oldid,
        'article_id': article_id,
        'PMID': pmid
    })

    

@pgconnect
def ingestdomain(conn,neuron_id,domains,morph_attr):
    cur = conn.cursor()
    if "Soma" in domains:
        del domains["Soma"]
    for key in domains:
        stmt = "INSERT INTO neuron_structure (neuron_id, completeness, domain,morph_attributes) VALUES ({},'{}','{}',{})".format(neuron_id,domains[key],key,morph_attr)
        cur.execute(stmt)

@myconnect
def checkexists(conn,table,indexfield, fields):
    for item in fields:
        if isinstance(fields[item],str):
            fields[item] = escapechars(fields[item])
        if fields[item] == None:
            fields[item] = 'Not reported'
        if isinstance(fields[item],float) or isinstance(fields[item],int):
            fields[item] = str(fields[item])

    cur = conn.cursor()
    cur.execute("SELECT * from {} where {} = '{}'".format(table,indexfield,fields[indexfield]))
    res = cur.fetchone()
    if res is None:
        stmt = "insert into {} ({}) values ({})".format(table,','.join(fields.keys()),"'" + "','".join(fields.values()) + "'")
        cur.execute(stmt)
        cur.execute('select LAST_INSERT_ID()')
        res = cur.fetchone()
    return res[0]

def ingestregion(adict):
    # Checks dict for region fields
    # Wraps fields into array string for postgres stored procedure
    conn=connect()
    cur = conn.cursor()
    
    proceed = True
    path2 = ''

    reg1 = adict.get('region1','')
    if reg1 == 'Not reported' or reg1 == '':
        raise Exception('Region 1 must have value')
    else:
        pgarr = "'{{''{}''".format(reg1)
        path = cleanstr(reg1)
    reg2 = adict.get('region2','')
    if reg2 == 'Not reported' or reg2 == '':
        proceed = False
    else:
        pgarr += ",''{}''".format(reg2)
        path += '.' + cleanstr(reg2)
    reg3 = adict.get('region3','')
    if reg3 == 'Not reported' or reg3 == '' and proceed:
        proceed = False
    elif proceed:
        path += '.' + cleanstr(reg3)
        pgarr += ",''{}''".format(reg3)
    reg3B = adict.get('region3B','')
    if reg3B == 'Not reported' or reg3B == '' and proceed:
        pass        
    elif proceed:
        pgarr += ",''{}''".format(cleanval(reg3B))
        path += '.' + cleanstr(reg3B)
    pgarr += "}'"
    cur.execute("CALL ingest_region({},'{}')".format(pgarr,path)) #TODO check if paranthesis should be here
    cur.execute("SELECT id from region where path = '{}';".format(path))
    theid = cur.fetchone()
    conn.close()
    return theid[0]
    # Strips invalid characters from path elements string.
    # Concatenates path elements into ltree path
    # Calls stored procedure to ingest region at lowest level if needed
    # Regions at level 3A,B, C are ingested at same level in tree by calling procedure for each 


def ingestcelltype(adict):
    # Checks dict for celltype fields
    # Wraps fields into array string for postgres stored procedure
    conn=connect()
    cur = conn.cursor()
    
    proceed = True

    reg1 = adict.get('class1','')
    if reg1 == 'Not reported' or reg1 == '':
        raise Exception('class 1 must have value')
    else:
        pgarr = "'{{''{}''".format(reg1)
        path = cleanstr(reg1)
    reg2 = adict.get('class2','')
    if reg2 == 'Not reported' or reg2 == '':
        proceed = False
    else:
        pgarr += ",''{}''".format(reg2)
        path += '.' + cleanstr(reg2)
    reg3 = adict.get('class3','')
    if reg3 == 'Not reported'  or reg3 == '' and proceed:
        proceed = False
    elif proceed:
        path += '.' + cleanstr(reg3)
        pgarr += ",''{}''".format(reg3)
    reg3B = adict.get('class3B','')
    if reg3B == 'Not reported'  or reg3B == '' and proceed:
        proceed = False
    elif proceed:
        path += '.' + cleanstr(reg3B)
        pgarr += ",''{}''".format(reg3B)
    reg3C = adict.get('class3C','')
    if reg3C == 'Not reported' or reg3C == '' and proceed:
        pass        
    elif proceed:
        pgarr += ",''{}''".format(reg3C)
        path += '.' + cleanstr(reg3C)
    pgarr += "}'"
    cur.execute("CALL ingest_celltype({},'{}')".format(pgarr,path))
    cur.execute("SELECT id from celltype where path = '{}';".format(path))
    theid = cur.fetchone()

    conn.close()

    return theid[0]

def getneuronarchive(neuron_name):
    # get archive of ready neuron names
    conn = connect()
    cur = conn.cursor()

    statement = "SELECT archive FROM ingestion WHERE neuron_name = '{}'".format(neuron_name)
    cur.execute(statement)
    result = cur.fetchone()
    res = result[0]
    conn.close()
    return res

@pgconnect
def getarchiveneurons(conn,archive):
    cur = conn.cursor()
    statement = "SELECT neuron.name from neuron,archive where neuron.archive_id = archive.id AND archive.name = '{}'".format(archive)
    cur.execute(statement)
    res = cur.fetchall()
    result = [item[0] for item in res]
    return result

def setneuronerror(neuron_name,message):
    # get array of ready neuron names
    conn = connect()
    cur = conn.cursor()

    statement = "UPDATE ingestion SET status='error', message = '{}' WHERE neuron_name = '{}'".format(cleanerr(message),neuron_name)
    cur.execute(statement)
    conn.close()