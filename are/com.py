import psycopg2

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
    fields = ",".join(data.keys())
    values = ','.join([str(item) for item in data.values()])
    statement = """INSERT INTO {}({}) VALUES ({}) """.format(tablename,fields,values)
    cur.execute(statement)  
    cur.execute("SELECT currval(pg_get_serial_sequence('{}','id'))".format(tablename))
    result = cur.fetchone()
    inserted_id = result[0]
    conn.close()
    return inserted_id

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
    conn=connect()
    cur = conn.cursor()
    statement = """CALL ingest_data('{}', '{}', '{}',  '{}', '{}','{}' , '{}' , '{}','{}', '{}',{},'{}', '{}','{}', '{}', {}, '{}',
        '{}',  cast({} as boolean), '{}' , '{}' , '{}', {}, {},{},{}, '{}', {},'{}', {}, {},'{}',  null)""".format(
     d['neuron_name'],d['archive'],d['URL_reference'],d['species'],d['expercond'],d['age_classification'],d['region'],d['celltype'],d['deposition_date'],d['uploaddate'],
     str(d['magnification']),d['objective'],d['format'],d['protocol'],d['slice_direction'],str(d['thickness']),d['stain'],d['strain'],
     str(d['has_soma']),d['shrinkage_reported'],d['age_scale'],d['gender'],str(d['max_age']),str(d['min_age']),str(d['min_weight']),
     str(d['max_weight']),d['note'],str(d['pmid']),d['doi'],str(d['sum_mes_id']),str(d['shrinkval_id']),d['URL_reference'])
    cur.execute(statement)
    result = cur.fetchone()
    neuron_id = result[0]
    conn.close()
    return neuron_id

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
    cur.execute("CALL ingest_region({},'{}')".format(pgarr,path))
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

def getreadyneurons(archive):
    # get array of ready neuron names
    conn = connect()
    cur = conn.cursor()

    statement = "SELECT neuron_name FROM ingestion WHERE (status = 2 OR status = 5) AND archive = '{}'".format(archive)
    cur.execute(statement)
    result = cur.fetchall()
    res = [item[0] for item in result]
    conn.close()
    return res

def getneuronarchive(neuron_name):
    # get array of ready neuron names
    conn = connect()
    cur = conn.cursor()

    statement = "SELECT archive FROM ingestion WHERE neuron_name = '{}'".format(neuron_name)
    cur.execute(statement)
    result = cur.fetchone()
    res = result[0]
    conn.close()
    return res

def setneuronerror(neuron_name,message):
    # get array of ready neuron names
    conn = connect()
    cur = conn.cursor()

    statement = "UPDATE ingestion SET status=5, errors = '{}' WHERE neuron_name = '{}'".format(cleanerr(message),neuron_name)
    cur.execute(statement)
    conn.close()