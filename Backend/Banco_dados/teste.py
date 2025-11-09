import oracledb
import os
from dotenv import load_dotenv

load_dotenv()

# Tentar usar o modo thick (requer Oracle Client instalado)
try:
    oracledb.init_oracle_client()
    print("Modo thick ativado (Oracle Client detectado)")
except Exception:
    print("Modo thin ativado (Oracle Client não encontrado)")

try:
    # Configuração do DSN Oracle
    local_dsn = os.getenv("ORACLE_DSN", "db.freesql.com:1521/23ai_mb9q7")
    user = os.getenv("ORACLE_USER", "SQL_NRHDYLQ3XIT2QAXIM21V7DMOZ7")
    password = os.getenv("ORACLE_PASSWORD", "<CURRENT_PASSWORD>")
    
    conn = oracledb.connect(
        user=user,
        password=password,
        dsn=local_dsn,
        # Desabilitar criptografia nativa se possível
        config_dir=None,
        wallet_location=None
    )
    print("Conexão OK!")
    conn.close()
except Exception as e:
    print("Erro:", e)
