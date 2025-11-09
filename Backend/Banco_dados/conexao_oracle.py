import oracledb
import os
from dotenv import load_dotenv

load_dotenv()

# Tentar usar o modo thick (requer Oracle Client instalado)
# Se o Oracle Client não estiver instalado, isso falhará silenciosamente
# e o python-oracledb usará o modo thin automaticamente
try:
    oracledb.init_oracle_client()
    print("Modo thick ativado (Oracle Client detectado)")
except Exception:
    print("Modo thin ativado (Oracle Client não encontrado)")

# Configuração do DSN Oracle
local_dsn = os.getenv("ORACLE_DSN", "db.freesql.com:1521/23ai_mb9q7")
user = os.getenv("ORACLE_USER", "SQL_NRHDYLQ3XIT2QAXIM21V7DMOZ7")
password = os.getenv("ORACLE_PASSWORD", "<CURRENT_PASSWORD>")

try:
    # Tentar conexão com criptografia desabilitada (se o servidor permitir)
    connection = oracledb.connect(
        user=user,
        password=password,
        dsn=local_dsn,
        # Desabilitar criptografia nativa se possível
        config_dir=None,
        wallet_location=None
    )
    print("Successfully connected to Oracle Database")
    
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM DUAL")
    
    for result in cursor.fetchall():
        print(result)
    
    cursor.close()
    connection.close()
except Exception as e:
    print(f"Erro ao conectar: {e}")
    print("\nDicas para resolver:")
    print("1. Instale o Oracle Instant Client (modo thick)")
    print("2. Ou configure o servidor Oracle para não exigir criptografia nativa")

