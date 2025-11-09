"""
Script para verificar variáveis de ambiente do arquivo .env
"""
from dotenv import load_dotenv
import os
from pathlib import Path

# Carregar o arquivo .env
env_path = Path(__file__).parent / ".env"
print(f"Carregando arquivo .env de: {env_path}")
print(f"   Arquivo existe? {env_path.exists()}\n")

if env_path.exists():
    load_dotenv(dotenv_path=env_path, override=True)
else:
    load_dotenv()

# Lista de variáveis para verificar
variaveis = [
    "ORACLE_DSN",
    "ORACLE_USER",
    "ORACLE_PASSWORD",
    "ORACLE_CLIENT_LIB_DIR",
    "JWT_SECRET_KEY",
    "ALLOWED_ORIGINS"
]

print("=" * 60)
print("VARIÁVEIS DE AMBIENTE CARREGADAS")
print("=" * 60)

for var in variaveis:
    valor = os.getenv(var)
    if valor:
        # Ocultar valores sensíveis
        if "PASSWORD" in var or "SECRET" in var:
            print(f"[OK] {var}: {'*' * min(len(valor), 20)} ({len(valor)} caracteres)")
        else:
            print(f"[OK] {var}: {valor}")
    else:
        print(f"[ERRO] {var}: NÃO DEFINIDO")

print("=" * 60)

# Verificar credenciais Oracle especificamente
print("\nDETALHES DAS CREDENCIAIS ORACLE:")
print("-" * 60)
dsn = os.getenv("ORACLE_DSN", "")
user = os.getenv("ORACLE_USER", "")
password = os.getenv("ORACLE_PASSWORD", "")

print(f"DSN: {dsn}")
print(f"   Tamanho: {len(dsn)} caracteres")
print(f"   Contém espaços? {'Sim' if ' ' in dsn else 'Não'}")

print(f"\nUser: {user}")
print(f"   Tamanho: {len(user)} caracteres")
print(f"   Contém espaços? {'Sim' if ' ' in user else 'Não'}")

print(f"\nPassword: {'*' * min(len(password), 20)}")
print(f"   Tamanho: {len(password)} caracteres")
print(f"   Contém espaços? {'Sim' if ' ' in password else 'Não'}")
print(f"   Contém aspas? {'Sim' if ('"' in password or "'" in password) else 'Não'}")
print(f"   Está vazia ou não atualizada? {'Sim' if not password or password == 'sua_senha_aqui' else 'Não'}")

print("\n" + "=" * 60)

