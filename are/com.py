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

def insertneuron(nname):
    #inserts one neuron with name nname
    # TODO add parameters. 
    conn=connect()
    cur = conn.cursor()
    statement = """CALL ingest_data('{}', 'Zhang4', 'http://zhang.com',  'monkey', 'testexpcond3','adult' , 'A.B' , 'C.D','04-15-2019', '10-15-2019',0.88,'dry', 'DAT','in vivo', 'coronal', 0.75, 'green fluorescent protein',
 'tststrain',  cast(1 as boolean), 'not reported' , 'D' , 'F', 1.3, 2.5,3.6,4.8, 'AA','NN', 2222222,'doi.org/1111', null)""".format(nname)
    cur.execute(statement)
    result = cur.fetchone()
    neuron_id = result[0]
    conn.close()
    return neuron_id