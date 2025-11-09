import pymysql

try:
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        password='1527PGCmlj@',
        database='aplicativo',
        port=3306
    )
    print("Conexão OK!")
    conn.close()
except Exception as e:
    print("Erro:", e)
