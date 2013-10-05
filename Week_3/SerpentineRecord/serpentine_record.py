import sqlite3

class MassObject:
    def __init__(self, attributes):
        for name, value in attributes.items():
            setattr(self, name, value)

class SqlObject:
    def __init__(self, db_connection, table_name):
        self.table_name = table_name
        self.db_connection = db_connection
        self.cursor = db_connection.cursor()

    def all(self):
        query = "SELECT * FROM {0}".format(self.table_name)
        return self.cursor.execute(query).fetchall()

if __name__ == "__main__":
    cxn = sqlite3.connect('my_database.db')
    users_object = SqlObject(cxn, 'users')
    for row in users_object.all():
        print(row)


