import time

#TODO write parser that creates worflow list from json or keyword list
#TODO parser should also start thread

class Workflowcomp:
    """
    Class for a component in a workflow
    """
    def __init__(self, compfunc, sleeptime=0, nextcomp=None,nextarg=None):
        """
        docstring
        """
        self.cf = compfunc
        self.nc = nextcomp
        self.st = sleeptime
        self.na = nextarg

    def execute(self,*args,**kwargs):
        """
        docstring
        """
        self.cf(*args,**kwargs)
        print("Waiting for {}s".format(self.st))
        time.sleep(self.st)
        if self.nc is not None: 
            self.nc.execute(self.na)


    