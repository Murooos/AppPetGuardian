# 🔧 Solução: Oracle Client e GitHub (Arquivos > 100MB)

## ⚠️ Problema

O GitHub não permite arquivos maiores que 100MB. O Oracle Instant Client contém arquivos grandes (ex: `libociei.so` com 195MB).

## ✅ Solução: Não Commitar o Oracle Client

O Oracle Instant Client **NÃO deve ser commitado** no Git. Ele deve ser:
- **Localmente**: Instalado manualmente em `venv/instantclient_23_9` (Windows)
- **No Render**: Baixado automaticamente durante o build OU instalado via variáveis de ambiente

## 📝 Passos para Resolver

### 1. Adicionar ao .gitignore

O arquivo `.gitignore` já foi criado com:
```
oracle/
venv/instantclient_*/
```

### 2. Remover do Git (se já foi commitado)

Execute estes comandos no terminal:

```bash
# Remover do índice do Git (mas manter os arquivos localmente)
git rm -r --cached oracle/
git rm -r --cached venv/instantclient_*/

# Fazer commit da remoção
git commit -m "Remover Oracle Client do Git (arquivos muito grandes)"

# Fazer push
git push
```

### 3. No Render: Usar Download Automático

O `render.yaml` já está configurado para baixar o Oracle Client automaticamente durante o build. Não precisa fazer upload manual.

## 🚀 Como Funciona Agora

### Desenvolvimento Local (Windows)
- Use o Oracle Client em `venv\instantclient_23_9`
- Configure `ORACLE_CLIENT_LIB_DIR` no `.env` apontando para esse caminho
- O código detecta automaticamente

### Produção (Render - Linux)
- O Render baixa o Oracle Client automaticamente durante o build
- Ou você pode configurar variáveis de ambiente no Render
- O código detecta automaticamente

## 📋 Variáveis de Ambiente no Render

Configure estas variáveis no painel do Render:

```
ORACLE_DSN=db.freesql.com:1521/23ai_mb9q7
ORACLE_USER=SQL_NRHDYLQ3XIT2QAXIM21V7DMOZ7
ORACLE_PASSWORD=sua_senha_aqui
JWT_SECRET_KEY=sua_chave_secreta_aqui
ALLOWED_ORIGINS=*
```

**Não precisa** configurar `ORACLE_CLIENT_LIB_DIR` - o Render vai baixar automaticamente!

## ✅ Verificação

Após fazer push sem o Oracle Client, verifique:
- ✅ O push foi bem-sucedido
- ✅ O diretório `oracle/` não aparece no GitHub
- ✅ O Render baixa o Oracle Client automaticamente durante o build


