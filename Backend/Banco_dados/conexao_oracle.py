import oracledb
import os
from dotenv import load_dotenv
from pathlib import Path

# Carregar variáveis de ambiente do arquivo .env
env_path = Path(__file__).parent.parent.parent / ".env"
print(f"🔍 Procurando arquivo .env em: {env_path}")
print(f"   Arquivo existe? {env_path.exists()}")

# Carregar o arquivo .env explicitamente
if env_path.exists():
    load_dotenv(dotenv_path=env_path, override=True)
    print(f"✅ Arquivo .env carregado")
    
    # Debug: mostrar conteúdo do arquivo .env (apenas linhas relevantes)
    try:
        with open(env_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            print(f"📄 Conteúdo do arquivo .env (primeiras 10 linhas):")
            for i, line in enumerate(lines[:10], 1):
                # Ocultar senhas e valores sensíveis
                if 'PASSWORD' in line or 'SECRET' in line:
                    print(f"   {i}: {line.split('=')[0] if '=' in line else line.strip()}=***")
                else:
                    print(f"   {i}: {line.strip()}")
    except Exception as e:
        print(f"⚠️  Não foi possível ler o arquivo .env: {e}")
else:
    load_dotenv()  # Tentar carregar da raiz do projeto
    print(f"⚠️  Arquivo .env não encontrado no caminho esperado, tentando carregar da raiz...")

# Tentar usar o modo thick (requer Oracle Client instalado)
# Permite especificar o caminho manualmente via variável de ambiente ORACLE_CLIENT_LIB_DIR
oracle_client_path = os.getenv("ORACLE_CLIENT_LIB_DIR")
print(f"🔍 ORACLE_CLIENT_LIB_DIR lido: {oracle_client_path}")

# Debug: verificar todas as variáveis relacionadas ao Oracle
print(f"🔍 Variáveis Oracle carregadas:")
print(f"   ORACLE_CLIENT_LIB_DIR: {os.getenv('ORACLE_CLIENT_LIB_DIR', 'NÃO DEFINIDO')}")
print(f"   ORACLE_DSN: {os.getenv('ORACLE_DSN', 'NÃO DEFINIDO')}")
print(f"   ORACLE_USER: {os.getenv('ORACLE_USER', 'NÃO DEFINIDO')}")

thick_mode_activated = False

try:
    if oracle_client_path:
        # Verificar se o caminho existe
        if not os.path.exists(oracle_client_path):
            print(f"⚠️  AVISO: O caminho especificado não existe: {oracle_client_path}")
            print(f"   Verifique se o caminho está correto no arquivo .env")
        else:
            print(f"✅ Caminho existe: {oracle_client_path}")
            # Verificar se há DLLs no diretório
            dll_files = [f for f in os.listdir(oracle_client_path) if f.endswith('.dll')]
            print(f"   DLLs encontradas: {len(dll_files)}")
            if len(dll_files) == 0:
                print(f"   ⚠️  AVISO: Nenhuma DLL encontrada no diretório!")
        
        # Tentar inicializar com caminho específico
        oracledb.init_oracle_client(lib_dir=oracle_client_path)
        print(f"✅ Modo thick ativado (Oracle Client encontrado em: {oracle_client_path})")
        thick_mode_activated = True
    else:
        print("⚠️  ORACLE_CLIENT_LIB_DIR não definido. Tentando encontrar no PATH...")
        # Tentar inicializar sem especificar caminho (procura no PATH)
        oracledb.init_oracle_client()
        print("✅ Modo thick ativado (Oracle Client detectado no PATH)")
        thick_mode_activated = True
except Exception as e:
    print("❌ Modo thin ativado (Oracle Client não encontrado)")
    if oracle_client_path:
        print(f"   Tentou usar o caminho: {oracle_client_path}")
        print(f"   Erro detalhado: {e}")
        print(f"   Tipo do erro: {type(e).__name__}")
    else:
        print("   ORACLE_CLIENT_LIB_DIR não está definido no arquivo .env")
        print("   Adicione a linha: ORACLE_CLIENT_LIB_DIR=C:\\caminho\\para\\instantclient_XX_X")

# Configuração do DSN Oracle
local_dsn = os.getenv("ORACLE_DSN", "db.freesql.com:1521/23ai_mb9q7")
user = os.getenv("ORACLE_USER", "SQL_NRHDYLQ3XIT2QAXIM21V7DMOZ7")
password = os.getenv("ORACLE_PASSWORD", "<CURRENT_PASSWORD>")

# Remover espaços extras e caracteres invisíveis
local_dsn = local_dsn.strip() if local_dsn else local_dsn
user = user.strip() if user else user
password = password.strip() if password else password

# Debug: verificar credenciais (sem mostrar valores)
print(f"\n🔍 Verificando credenciais:")
print(f"   DSN: {local_dsn}")
print(f"   User: {user}")
print(f"   Password length: {len(password) if password else 0} caracteres")
print(f"   Password contém espaços? {'Sim' if password and ' ' in password else 'Não'}")
print(f"   Password contém aspas? {'Sim' if password and ('"' in password or "'" in password) else 'Não'}")

try:
    # Tentar conexão
    print(f"\n🔌 Tentando conectar ao Oracle...")
    connection = oracledb.connect(
        user=user,
        password=password,
        dsn=local_dsn
    )
    print("Successfully connected to Oracle Database")
    
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM DUAL")
    
    for result in cursor.fetchall():
        print(result)
    
    cursor.close()
    connection.close()
except Exception as e:
    error_msg = str(e)
    print(f"\n❌ Erro ao conectar: {error_msg}")
    
    # Tratamento específico para erro de autenticação
    if "ORA-01017" in error_msg or "invalid credential" in error_msg.lower() or "logon denied" in error_msg.lower():
        print("\n" + "="*60)
        print("🔐 ERRO DE AUTENTICAÇÃO (ORA-01017)")
        print("="*60)
        print("\n💡 Possíveis causas:")
        print("1. Usuário ou senha incorretos")
        print("2. Usuário não tem permissão para acessar o banco")
        print("3. Senha contém caracteres especiais que precisam ser escapados")
        print("4. DSN (endereço do banco) incorreto")
        print("\n🔍 Verificações:")
        print(f"   - DSN usado: {local_dsn}")
        print(f"   - Usuário usado: {user}")
        print(f"   - Tamanho da senha: {len(password) if password else 0} caracteres")
        print("\n📝 Dicas:")
        print("   - Verifique se não há espaços extras no início/fim da senha no .env")
        print("   - Se a senha contém caracteres especiais, tente usar aspas no .env:")
        print("     ORACLE_PASSWORD=\"sua_senha_com_caracteres_especiais\"")
        print("   - Verifique se o DSN está no formato correto:")
        print("     host:porta/serviço ou host:porta/SID")
        print("="*60)
    elif "DPY-3001" in error_msg or "Native Network Encryption" in error_msg:
        print("\n" + "="*60)
        print("🔒 O servidor Oracle está exigindo criptografia nativa")
        print("   Isso requer o modo THICK (Oracle Instant Client)")
        print("="*60)
        print("\n📋 SOLUÇÃO: Instalar Oracle Instant Client")
        print("\n1. Baixe o Oracle Instant Client Basic:")
        print("   https://www.oracle.com/database/technologies/instant-client/downloads.html")
        print("\n2. Extraia em um diretório (ex: C:\\oracle\\instantclient_21_3)")
        print("\n3. Configure uma das opções abaixo:")
        print("\n   OPÇÃO A - Adicionar ao PATH do sistema:")
        print("   - Abra 'Variáveis de Ambiente' no Windows")
        print("   - Edite a variável PATH")
        print("   - Adicione: C:\\oracle\\instantclient_21_3")
        print("\n   OPÇÃO B - Especificar via variável de ambiente:")
        print("   - Crie/edite o arquivo .env na raiz do projeto")
        print("   - Adicione: ORACLE_CLIENT_LIB_DIR=C:\\oracle\\instantclient_21_3")
        print("\n4. Reinicie o terminal e execute novamente")
        print("="*60)
    else:
        print("\n💡 Dicas para resolver:")
        print("1. Verifique se as credenciais estão corretas no arquivo .env")
        print("2. Verifique se o DSN está correto")
        print("3. Verifique a conectividade de rede com o servidor Oracle")

