# 🚀 Configuração do Oracle Client no Render

## ⚠️ Problema
O servidor Oracle exige criptografia nativa (modo thick), o que requer o Oracle Instant Client instalado.

## ✅ Solução: Configurar Variáveis de Ambiente no Render

### Passo 1: Acessar o Painel do Render

1. Acesse: https://dashboard.render.com
2. Selecione seu serviço (pet-guardian-api)
3. Vá em **Environment** (menu lateral)

### Passo 2: Adicionar Variáveis de Ambiente

Adicione estas variáveis de ambiente no Render:

```
ORACLE_DSN=db.freesql.com:1521/23ai_mb9q7
ORACLE_USER=SQL_NRHDYLQ3XIT2QAXIM21V7DMOZ7
ORACLE_PASSWORD=sua_senha_aqui
JWT_SECRET_KEY=sua_chave_secreta_aqui
ALLOWED_ORIGINS=*
ORACLE_CLIENT_LIB_DIR=$HOME/oracle/instantclient_21_13/instantclient_21_13
LD_LIBRARY_PATH=$HOME/oracle/instantclient_21_13/instantclient_21_13:$LD_LIBRARY_PATH
```

### Passo 3: Verificar Build Command

O `render.yaml` já está configurado para tentar baixar o Oracle Client automaticamente. Se o download falhar (Oracle pode exigir autenticação), você verá um aviso nos logs.

### Passo 4: Verificar Logs

Após o deploy, verifique os logs do Render. Você deve ver:
- `✅ Oracle Instant Client instalado` ou
- `⚠️  Não foi possível baixar o Oracle Client automaticamente`

## 🔧 Se o Download Automático Falhar

### Opção 1: Usar Build Script Customizado

1. No Render, vá em **Settings** → **Build & Deploy**
2. Altere o **Build Command** para:

```bash
apt-get update && apt-get install -y wget unzip libaio1 curl &&
pip install --upgrade pip &&
pip install -r requirements.txt &&
mkdir -p $HOME/oracle/instantclient_21_13 &&
cd $HOME/oracle/instantclient_21_13 &&
# Baixar Oracle Client (pode exigir autenticação)
curl -L -o instantclient-basic.zip "https://download.oracle.com/otn_software/linux/instantclient/2113000/instantclient-basic-linux.x64-21.13.0.0.0dbru.zip" &&
unzip -q instantclient-basic.zip &&
rm instantclient-basic.zip &&
echo "✅ Oracle Client instalado"
```

### Opção 2: Fazer Upload Manual

1. Baixe o Oracle Instant Client:
   - https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
   - Baixe "Basic Package" (instantclient-basic-linux.x64-21.13.0.0.0dbru.zip)

2. Crie o diretório no projeto:
   ```bash
   mkdir -p oracle/instantclient_21_13
   ```

3. Extraia o Oracle Client lá e faça commit:
   ```bash
   unzip instantclient-basic-linux.x64-21.13.0.0.0dbru.zip -d oracle/instantclient_21_13/
   git add oracle/
   git commit -m "Adicionar Oracle Instant Client"
   git push
   ```

4. Configure a variável de ambiente no Render:
   ```
   ORACLE_CLIENT_LIB_DIR=/opt/render/project/src/oracle/instantclient_21_13/instantclient_21_13
   ```

## 📋 Checklist

- [ ] Variáveis de ambiente configuradas no Render
- [ ] Build Command configurado corretamente
- [ ] Oracle Client instalado (verificar logs)
- [ ] `ORACLE_CLIENT_LIB_DIR` aponta para o caminho correto
- [ ] `LD_LIBRARY_PATH` inclui o caminho do Oracle Client
- [ ] Teste de conexão bem-sucedido

## 🐛 Troubleshooting

### Erro: "DPY-3001" ou "Native Network Encryption"
- Verifique se `ORACLE_CLIENT_LIB_DIR` está correto
- Verifique se o Oracle Client foi instalado (logs do build)

### Erro: "libaio.so.1: cannot open shared object file"
- Adicione `apt-get install -y libaio1` no build command

### Erro: "ModuleNotFoundError: No module named 'Banco_dados'"
- Já foi corrigido no código, mas verifique se o deploy foi atualizado

## 📞 Suporte

Se ainda tiver problemas, verifique:
1. Logs do build no Render
2. Logs do runtime no Render
3. Variáveis de ambiente configuradas corretamente

