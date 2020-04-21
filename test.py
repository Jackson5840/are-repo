from flask import Flask,jsonify
from are import com
app = Flask(__name__)

@app.route('/')
def ingest():
    s= {'status': 'success'}
    try:
        sum_mes_id = com.insert('measurements',{'soma_surface': 103})
        shrinkval_id = com.insert('shrinkagevalue',{'reported_val': 0.75})
        d ={ 
            'name': 'testname',
            'archive': 'testarchive',
            'archiveurl': 'http://test.com',
            'species': 'rat',
            'expcond': 'gruesome',
            'age': 'adult',
            'region': 'A.B',
            'celltype': 'C.D',
            'depodate': '2020-01-01',
            'uploaddate': '2020-02-02',
            'magnification': 1,
            'objective': 'dry',
            'orgformat': 'DAT',
            'protocol': 'in vivo',
            'slicedir': 'coronal',
            'slicethickness': 0.5,
            'staining': 'Fiddlers Green',
            'strain': 'Wistar', 
            'has_soma': 1,
            'shrinkage': 'not reported',
            'agescale': 'D',
            'gender': 'F',
            'max_age': 5.2,
            'min_age': 4.1,
            'min_weight': 6.4, 
            'max_weight': 3.5, 
            'note': 'nice experiment',
            'pmid': 1111111,
            'doi': 'doi.org/test/11111',
            'sum_mes_id': sum_mes_id,
            'shrinkval_id': shrinkval_id,
            'url_ref': 'http://testing.com'
        }
        print(com.insertneuron(d))
    except Exception as e:
        s['status'] = 'error'
        s['message'] = str(e)
        print(s)
    return jsonify(s)


