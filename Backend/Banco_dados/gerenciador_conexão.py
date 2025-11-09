import pymysql

class DBHandler:
    def __init__(self):
        self.conn = pymysql.connect(
            host='127.0.0.1',
            user='root',
            password='1527PGCmlj@',
            database='aplicativo',
            port=3306,
            cursorclass=pymysql.cursors.DictCursor  # resultado em dicionário
        )
        self.cursor = self.conn.cursor()

    def execute(self, query, params=None):
        self.cursor.execute(query, params or ())
        if query.strip().lower().startswith("select"):
            return self.cursor.fetchall()
        else:
            self.conn.commit()
            return None

    def close(self):
        self.cursor.close()
        self.conn.close()
