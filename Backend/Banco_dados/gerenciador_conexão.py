import oracledb
import os
from dotenv import load_dotenv

load_dotenv()

# Tentar usar o modo thick (requer Oracle Client instalado)
# Se o Oracle Client não estiver instalado, isso falhará silenciosamente
# e o python-oracledb usará o modo thin automaticamente
try:
    oracledb.init_oracle_client()
except Exception:
    pass  # Usa modo thin se o Oracle Client não estiver disponível

class DBHandler:
    def __init__(self):
        # Configuração do DSN Oracle
        local_dsn = os.getenv("ORACLE_DSN", "db.freesql.com:1521/23ai_mb9q7")
        user = os.getenv("ORACLE_USER", "SQL_NRHDYLQ3XIT2QAXIM21V7DMOZ7")
        password = os.getenv("ORACLE_PASSWORD", "<CURRENT_PASSWORD>")
        
        self.conn = oracledb.connect(
            user=user,
            password=password,
            dsn=local_dsn,
            # Desabilitar criptografia nativa se possível
            config_dir=None,
            wallet_location=None
        )
        # Configurar cursor para retornar dicionários (similar ao DictCursor do MySQL)
        self.cursor = self.conn.cursor()
        # Oracle não tem DictCursor nativo, então vamos usar uma abordagem alternativa
        self._dict_mode = True

    def _row_to_dict(self, row, description):
        """Converte uma linha do Oracle em dicionário"""
        if not self._dict_mode:
            return row
        return {desc[0]: val for desc, val in zip(description, row)}

    def execute(self, query, params=None):
        self.cursor.execute(query, params or ())
        if query.strip().lower().startswith("select"):
            rows = self.cursor.fetchall()
            # Converter para dicionário se necessário
            if self._dict_mode and rows:
                description = self.cursor.description
                return [self._row_to_dict(row, description) for row in rows]
            return rows
        else:
            self.conn.commit()
            return None

    def close(self):
        self.cursor.close()
        self.conn.close()
