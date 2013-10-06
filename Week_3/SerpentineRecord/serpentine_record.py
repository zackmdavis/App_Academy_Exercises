import sqlite3
from pdb import set_trace as debug

class MassObject:
    def __init__(self, attributes):
        for name, value in attributes.items():
            setattr(self, name, value)

class SqlObject(MassObject):
    def __init__(self, db_connection, table_name, attributes = {}, id = None):
        super().__init__(attributes)
        self.table_name = table_name
        self.attributes = attributes
        self.id = id
        self.db_connection = db_connection
        self.db_connection.row_factory = sqlite3.Row
        self.cursor = db_connection.cursor()

    # TODO: update self.attributes and thus __repr__ when attributes
    # change
    def __repr__(self):
        return "<" + str(self.table_name) + " " + str(self.attributes)[1:-1] + ">"

    @staticmethod
    def dict_from_row(row):
        row_dict = {}
        for key in row.keys():
            row_dict[key] = row[key]
        return row_dict

    @classmethod
    def all(cls, db_connection, table_name):
        query = "SELECT * FROM {0};".format(table_name)
        results = db_connection.execute(query).fetchall()
        result_dicts = [cls.dict_from_row(row) for row in results]
        return [SqlObject(db_connection, table_name, rd, id) for rd in result_dicts]

    @classmethod
    def find(cls, db_connection, table_name, id):
        query = "SELECT * FROM {0} WHERE id = ?;".format(table_name)
        result = db_connection.execute(query, (id,)).fetchone()
        result_dict = cls.dict_from_row(result)
        return SqlObject(db_connection, table_name, result_dict, id)

    @staticmethod
    def question_marks(n):
        if n == 1:
            return "?"
        else:
            marks_string = "("
            for _ in range(n-1):
                marks_string += "?, "
            marks_string += "?)"
            return marks_string

    def create(self):
        attribute_names, attribute_values = zip(*self.attributes.items())
        query = "INSERT INTO {0} {1} VALUES {2};".format(self.table_name, attribute_names, SqlObject.question_marks(len(attribute_values)))
        print(query)
        self.cursor.execute(query, attribute_values)
        self.db_connection.commit()
        self.id = self.cursor.lastrowid

    # apparently not working yet
    def update(self):
        nonid_attributes = self.attributes.copy()
        del nonid_attributes['id']
        print(nonid_attributes)
        set_string = ["{0} = ?".format(k) for k in nonid_attributes]
        set_string = ", ".join(set_string)
        query = "UPDATE {0} SET {1} WHERE id = ?".format(self.table_name, set_string)
        print(query)
        self.cursor.execute(query, tuple(nonid_attributes.values())+(self.id,))

    def save(self):
        if self.id is None:
            self.create()
        else:
            self.update()
