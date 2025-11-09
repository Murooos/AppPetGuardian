import oracledb
import os
from dotenv import load_dotenv

load_dotenv()

# Tentar usar o modo thick (requer Oracle Client instalado)
# Permite especificar o caminho manualmente via variável de ambiente ORACLE_CLIENT_LIB_DIR
oracle_client_path = os.getenv("ORACLE_CLIENT_LIB_DIR")

try:
    if oracle_client_path:
        oracledb.init_oracle_client(lib_dir=oracle_client_path)
        print(f"Modo thick ativado (Oracle Client encontrado em: {oracle_client_path})")
    else:
        oracledb.init_oracle_client()
        print("Modo thick ativado (Oracle Client detectado no PATH)")
except Exception as e:
    print("Modo thin ativado (Oracle Client não encontrado)")
    if oracle_client_path:
        print(f"Tentou usar o caminho: {oracle_client_path}")

try:
    # Configuração do DSN Oracle
    local_dsn = os.getenv("ORACLE_DSN", "db.freesql.com:1521/23ai_mb9q7")
    user = os.getenv("ORACLE_USER", "SQL_NRHDYLQ3XIT2QAXIM21V7DMOZ7")
    password = os.getenv("ORACLE_PASSWORD", "<CURRENT_PASSWORD>")
    
    conn = oracledb.connect(
        user=user,
        password=password,
        dsn=local_dsn
    )
    print("Conexão OK!")
    conn.close()
except Exception as e:
    error_msg = str(e)
    print(f"Erro: {error_msg}")
    if "DPY-3001" in error_msg or "Native Network Encryption" in error_msg:
        print("\n💡 Configure ORACLE_CLIENT_LIB_DIR no arquivo .env")
        print("   Exemplo: ORACLE_CLIENT_LIB_DIR=C:\\oracle\\instantclient_21_3")
