# Como Configurar Oracle Client no Render

## Problema
O servidor Oracle exige criptografia nativa (modo thick), o que requer o Oracle Instant Client instalado.

## Solução Automática (via render.yaml)

O arquivo `render.yaml` já está configurado para tentar baixar e instalar o Oracle Instant Client automaticamente durante o build.

## Solução Manual (Recomendada)

Se o download automático não funcionar (a Oracle pode exigir autenticação), siga estes passos:

### 1. Configurar Variáveis de Ambiente no Render

1. Acesse o painel do Render: https://dashboard.render.com
2. Vá em **Environment** (ou **Environment Variables**)
3. Adicione as seguintes variáveis:

```
ORACLE_CLIENT_LIB_DIR=/opt/render/project/src/oracle/instantclient_21_13
LD_LIBRARY_PATH=/opt/render/project/src/oracle/instantclient_21_13:$LD_LIBRARY_PATH
```

**OU** se o Oracle Client foi instalado em `$HOME/oracle/instantclient_21_13/instantclient_21_13`:

```
ORACLE_CLIENT_LIB_DIR=$HOME/oracle/instantclient_21_13/instantclient_21_13
LD_LIBRARY_PATH=$HOME/oracle/instantclient_21_13/instantclient_21_13:$LD_LIBRARY_PATH
```

### 2. Instalar Oracle Instant Client Manualmente

#### Opção A: Via Build Script Customizado

1. Crie um arquivo `build.sh` na raiz do projeto:

```bash
#!/bin/bash
set -e

# Instalar dependências do sistema
apt-get update && apt-get install -y wget unzip libaio1 curl

# Instalar Python dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Baixar e instalar Oracle Instant Client
mkdir -p $HOME/oracle/instantclient_21_13
cd $HOME/oracle/instantclient_21_13

# Baixar Oracle Instant Client (pode exigir autenticação)
# Você pode precisar baixar manualmente e fazer upload
curl -L -o instantclient-basic.zip \
  "https://download.oracle.com/otn_software/linux/instantclient/2113000/instantclient-basic-linux.x64-21.13.0.0.0dbru.zip" \
  || echo "⚠️  Download falhou - use método manual"

if [ -f instantclient-basic.zip ]; then
  unzip -q instantclient-basic.zip
  rm instantclient-basic.zip
  echo "✅ Oracle Instant Client instalado"
else
  echo "⚠️  Oracle Client não encontrado - configure manualmente"
fi
```

2. No Render, configure o **Build Command** para:
```bash
chmod +x build.sh && ./build.sh
```

#### Opção B: Fazer Upload Manual do Oracle Client

1. **Baixe o Oracle Instant Client**:
   - Acesse: https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
   - Baixe o "Basic Package" (instantclient-basic-linux.x64-21.13.0.0.0dbru.zip)
   - **Nota**: Pode exigir login na Oracle

2. **Crie um diretório no projeto**:
   - Crie `oracle/instantclient_21_13/` na raiz do projeto
   - Extraia o Oracle Client lá
   - Faça commit e push

3. **Configure o render.yaml** para usar o caminho local:
   ```yaml
   envVars:
     - key: ORACLE_CLIENT_LIB_DIR
       value: /opt/render/project/src/oracle/instantclient_21_13
   ```

### 3. Verificar se está Funcionando

Após o deploy, verifique os logs do Render. Você deve ver:
- `✅ Modo thick ativado` ou
- `✅ Oracle Instant Client instalado`

Se ainda houver erro, verifique:
- Se o caminho `ORACLE_CLIENT_LIB_DIR` está correto nos logs
- Se o `LD_LIBRARY_PATH` inclui o caminho do Oracle Client
- Se as bibliotecas necessárias (`libaio1`) estão instaladas

### 4. Variáveis de Ambiente Necessárias no Render

Certifique-se de que todas estas variáveis estão configuradas no Render:

```
ORACLE_DSN=db.freesql.com:1521/23ai_mb9q7
ORACLE_USER=SQL_NRHDYLQ3XIT2QAXIM21V7DMOZ7
ORACLE_PASSWORD=sua_senha_aqui
JWT_SECRET_KEY=sua_chave_secreta_aqui
ALLOWED_ORIGINS=*
ORACLE_CLIENT_LIB_DIR=$HOME/oracle/instantclient_21_13/instantclient_21_13
LD_LIBRARY_PATH=$HOME/oracle/instantclient_21_13/instantclient_21_13:$LD_LIBRARY_PATH
```

## Troubleshooting

### Erro: "DPY-3001" ou "Native Network Encryption"
- **Causa**: Oracle Client não encontrado ou não configurado corretamente
- **Solução**: Verifique se `ORACLE_CLIENT_LIB_DIR` está correto e se o Oracle Client foi instalado

### Erro: "ModuleNotFoundError"
- **Causa**: Caminho do Oracle Client incorreto
- **Solução**: Verifique os logs do build para ver onde o Oracle Client foi instalado

### Erro: "libaio.so.1: cannot open shared object file"
- **Causa**: Biblioteca `libaio1` não instalada
- **Solução**: Adicione `apt-get install -y libaio1` no build command

## Alternativa: Usar Oracle Cloud

Se você tiver acesso ao Oracle Cloud, pode configurar o banco para aceitar conexões sem criptografia nativa, permitindo o uso do modo thin (sem Oracle Client).

