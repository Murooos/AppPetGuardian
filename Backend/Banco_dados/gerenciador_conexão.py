import oracledb
import os
from dotenv import load_dotenv

load_dotenv()

# Tentar usar o modo thick (requer Oracle Client instalado)
# Permite especificar o caminho manualmente via variável de ambiente ORACLE_CLIENT_LIB_DIR
oracle_client_path = os.getenv("ORACLE_CLIENT_LIB_DIR")

# Tentar caminhos padrão no Render
if not oracle_client_path:
    # Caminhos comuns no Render
    possible_paths = [
        os.path.expanduser("~/oracle/instantclient_21_13/instantclient_21_13"),
        "/opt/render/project/src/oracle/instantclient_21_13",
        os.path.expanduser("~/oracle/instantclient_21_13"),
    ]
    for path in possible_paths:
        if os.path.exists(path):
            oracle_client_path = path
            break

thick_mode_activated = False
try:
    if oracle_client_path:
        # Verificar se o caminho existe
        if os.path.exists(oracle_client_path):
            oracledb.init_oracle_client(lib_dir=oracle_client_path)
            thick_mode_activated = True
        else:
            # Tentar encontrar automaticamente
            oracledb.init_oracle_client()
            thick_mode_activated = True
    else:
        # Tentar inicializar sem especificar caminho (procura no PATH)
        oracledb.init_oracle_client()
        thick_mode_activated = True
except Exception as e:
    # Usa modo thin se o Oracle Client não estiver disponível
    thick_mode_activated = False
    pass

class DBHandler:
    def __init__(self):
        # Configuração do DSN Oracle
        local_dsn = os.getenv("ORACLE_DSN", "db.freesql.com:1521/23ai_mb9q7")
        user = os.getenv("ORACLE_USER", "SQL_NRHDYLQ3XIT2QAXIM21V7DMOZ7")
        password = os.getenv("ORACLE_PASSWORD", "<CURRENT_PASSWORD>")
        
        try:
            self.conn = oracledb.connect(
                user=user,
                password=password,
                dsn=local_dsn
            )
        except Exception as e:
            error_msg = str(e)
            if "DPY-3001" in error_msg or "Native Network Encryption" in error_msg:
                raise Exception(
                    "Erro: O servidor Oracle exige criptografia nativa (modo thick). "
                    "Instale o Oracle Instant Client e configure a variável ORACLE_CLIENT_LIB_DIR no .env. "
                    "Veja README_SETUP.md para instruções detalhadas."
                ) from e
            raise
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
        try:
            # Oracle aceita dicionários diretamente para parâmetros nomeados
            if params is None:
                self.cursor.execute(query)
            elif isinstance(params, dict):
                self.cursor.execute(query, params)
            else:
                self.cursor.execute(query, params)
            
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
        except Exception as e:
            self.conn.rollback()
            raise

    def close(self):
        self.cursor.close()
        self.conn.close()
