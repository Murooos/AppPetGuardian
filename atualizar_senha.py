"""
Script para atualizar a senha do Oracle no arquivo .env
"""
from pathlib import Path
import re

env_path = Path(__file__).parent / ".env"

if not env_path.exists():
    print(f"ERRO: Arquivo .env não encontrado em: {env_path}")
    exit(1)

# Ler o arquivo atual
print(f"Lendo arquivo .env: {env_path}")
with open(env_path, 'r', encoding='utf-8') as f:
    conteudo = f.read()

# Mostrar a linha atual da senha
linha_atual = [linha for linha in conteudo.split('\n') if 'ORACLE_PASSWORD' in linha and not linha.strip().startswith('#')]
if linha_atual:
    print(f"\nLinha atual encontrada:")
    print(f"  {linha_atual[0]}")
else:
    print("\nAVISO: Linha ORACLE_PASSWORD não encontrada!")

# Solicitar a nova senha
print("\n" + "="*60)
print("ATUALIZAR SENHA DO ORACLE")
print("="*60)
nova_senha = input("\nDigite a nova senha do Oracle (ou pressione Enter para cancelar): ").strip()

if not nova_senha:
    print("Operação cancelada.")
    exit(0)

# Substituir a senha no conteúdo
# Padrão: ORACLE_PASSWORD=qualquer_coisa (sem espaços ao redor do =)
padrao = r'^(\s*ORACLE_PASSWORD\s*=\s*).*$'
novo_conteudo = re.sub(padrao, r'\1' + nova_senha, conteudo, flags=re.MULTILINE)

# Verificar se houve mudança
if novo_conteudo == conteudo:
    print("\nAVISO: Nenhuma alteração foi feita. Verifique o formato do arquivo .env")
    exit(1)

# Fazer backup
backup_path = env_path.with_suffix('.env.backup')
print(f"\nCriando backup: {backup_path}")
with open(backup_path, 'w', encoding='utf-8') as f:
    f.write(conteudo)

# Salvar o novo conteúdo
print(f"Salvando alterações em: {env_path}")
with open(env_path, 'w', encoding='utf-8') as f:
    f.write(novo_conteudo)

print("\n" + "="*60)
print("SENHA ATUALIZADA COM SUCESSO!")
print("="*60)
print(f"\nBackup salvo em: {backup_path}")
print(f"Nova senha tem {len(nova_senha)} caracteres")

# Verificar se foi salvo corretamente
with open(env_path, 'r', encoding='utf-8') as f:
    conteudo_verificacao = f.read()
    linha_nova = [linha for linha in conteudo_verificacao.split('\n') if 'ORACLE_PASSWORD' in linha and not linha.strip().startswith('#')]
    if linha_nova:
        print(f"\nVerificação - Linha atualizada:")
        # Mostrar apenas o tamanho da senha, não o valor
        partes = linha_nova[0].split('=')
        if len(partes) == 2:
            print(f"  {partes[0]}=*** ({len(partes[1].strip())} caracteres)")

