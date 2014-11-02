import pymongo

'''
This class will be used to get data out of the modules
collection in our database 

It will NOT be able to write to the database use the MongoDBAdmin
class for that
'''
class ModuleDB():

    """
    Currently all the init function does is grab a connection to the server
    and get access to the module collection
    """
    def __init__(self):
        try:

            # Try and get a connection
            self.conn = pymongo.MongoClient()

            # Set a flag that says we have a connection
            self.hasConnection = True
            print "Connection made"
            print self.conn.database_names()

            # Get access to the db
            self.db = self.conn['plannerDB']
            print self.db.collection_names()

            # Get access to the modules collection
            self.modules = self.db['modules']

        except pymongo.errors.ConnectionFailure, e:
            print "Could not connect to the database"
            self.hasConnection = False

    """
    Searches the database and looks for the given record

        Arguments:
                    query: Is a python dictionary containing the fragment of JSON
                           that we want matched. Eg. To search by module code query
                           would be {"code": "MAxxxx"}
    """
    def getModule(self, query):

        # Search the modules collection for the record given by query
        results = list(self.modules.find(query))

        if len(results) == 0:
            return {"name" : "Module Not Found"}

        return results[0]



"""
This is the Admin class so as well as inheriting all the
reading code it also has additional methods for adding new
records to the database - eventually
"""
class ModuleDBAdmin(ModuleDB):
    pass


