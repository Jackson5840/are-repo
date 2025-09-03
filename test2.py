from are import com
from are import ingest
from are import cfg

#archivepath = cfg.archivepath + '/Abdolhoseini_Final'

# b = ingest.mapneurontomeasurements('Bailey')
b = ingest.ingestneuron('2C5_1')
print('test')

# adict = {
#     'class1': 'test1',
#     'class2': 'Not ported',
#     'class3': 'Not  reported',
#     'class3B': 'test4'
# }

# print(com.ingest_celltype(adict))
# print('success')