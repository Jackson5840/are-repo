import psycopg2

def connect():
    conn = psycopg2.connect(host="localhost",database="nmo", user="nmo", password="100%db")
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

def insertneuron(d):
    #inserts one neuron with values from dictionary d
    # TODO add parameters. 
    conn=connect()
    cur = conn.cursor()
    statement = """CALL ingest_data('{}', '{}', '{}',  '{}', '{}','{}' , '{}' , '{}','{}', '{}',{},'{}', '{}','{}', '{}', {}, '{}',
        '{}',  cast({} as boolean), '{}' , '{}' , '{}', {}, {},{},{}, '{}', {},'{}', {}, {},'{}',  null)""".format(
     d['name'],d['archive'],d['archiveurl'],d['species'],d['expcond'],d['age'],d['region'],d['celltype'],d['depodate'],d['uploaddate'],
     str(d['magnification']),d['objective'],d['orgformat'],d['protocol'],d['slicedir'],str(d['slicethickness']),d['staining'],d['strain'],
     str(d['has_soma']),d['shrinkage'],d['agescale'],d['gender'],str(d['max_age']),str(d['min_age']),str(d['min_weight']),
     str(d['max_weight']),d['note'],str(d['pmid']),d['doi'],str(d['sum_mes_id']),str(d['shrinkval_id']),d['url_ref'])
    cur.execute(statement)
    result = cur.fetchone()
    neuron_id = result[0]
    conn.close()
    return neuron_id