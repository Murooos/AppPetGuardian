import psycopg2
import psycopg2.extras
import os
from dotenv import load_dotenv
from urllib.parse import urlparse

load_dotenv()

class DBHandler:
    def __init__(self):
        # Obter DATABASE_URL do ambiente (formato do Render.com)
        database_url = os.getenv("DATABASE_URL")
        
        if not database_url:
            # Se não tiver DATABASE_URL, tentar construir a partir de variáveis individuais
            db_host = os.getenv("DB_HOST")
            db_port = os.getenv("DB_PORT", "5432")
            db_name = os.getenv("DB_NAME")
            db_user = os.getenv("DB_USER")
            db_password = os.getenv("DB_PASSWORD")
            
            if all([db_host, db_name, db_user, db_password]):
                database_url = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
            else:
                raise Exception(
                    "DATABASE_URL não configurada. Configure DATABASE_URL ou as variáveis "
                    "DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD no arquivo .env"
                )
        
        try:
            # Parse da URL para garantir compatibilidade
            # O Render.com pode fornecer URLs com formato específico
            parsed = urlparse(database_url)
            
            # Conectar ao PostgreSQL
            self.conn = psycopg2.connect(
                host=parsed.hostname,
                port=parsed.port or 5432,
                database=parsed.path[1:] if parsed.path else None,  # Remove a barra inicial
                user=parsed.username,
                password=parsed.password,
                sslmode='require'  # Render.com requer SSL
            )
            
            # Configurar cursor para retornar dicionários
            self.cursor = self.conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            self._dict_mode = True
            
        except Exception as e:
            error_msg = str(e)
            raise Exception(
                f"Erro ao conectar ao PostgreSQL: {error_msg}. "
                f"Verifique se DATABASE_URL está correta no arquivo .env"
            ) from e

    def _row_to_dict(self, row):
        """Converte uma linha do PostgreSQL em dicionário (já vem como dict com RealDictCursor)"""
        if not self._dict_mode:
            return row
        return dict(row) if row else None

    def execute(self, query, params=None):
        try:
            # PostgreSQL usa %s para placeholders, mas psycopg2 aceita %(nome)s para parâmetros nomeados
            if params is None:
                self.cursor.execute(query)
            elif isinstance(params, dict):
                # Converter :param para %(param)s para compatibilidade com código existente
                # ou usar diretamente %(param)s
                self.cursor.execute(query, params)
            else:
                # Se params for uma tupla ou lista, usar %s
                self.cursor.execute(query, params)
            
            # Verificar se é uma query SELECT
            if query.strip().upper().startswith("SELECT"):
                rows = self.cursor.fetchall()
                # Converter para lista de dicionários
                if self._dict_mode and rows:
                    return [self._row_to_dict(row) for row in rows]
                return rows
            else:
                # Para INSERT, UPDATE, DELETE - fazer commit
                self.conn.commit()
                # Retornar o ID gerado se for INSERT
                if query.strip().upper().startswith("INSERT"):
                    return self.cursor.rowcount
                return None
        except Exception as e:
            self.conn.rollback()
            raise

    def close(self):
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
