# Configuração do Oracle Instant Client no Render

## Problema
O servidor Oracle exige criptografia nativa (modo thick), o que requer o Oracle Instant Client instalado.

## Solução Automática (via render.yaml)
O arquivo `render.yaml` já está configurado para baixar e instalar o Oracle Instant Client automaticamente durante o build.

## Solução Manual (se a automática não funcionar)

### 1. Configurar Variáveis de Ambiente no Render

No painel do Render, vá em **Environment** e adicione as seguintes variáveis:

```
ORACLE_CLIENT_LIB_DIR=/opt/render/project/src/oracle/instantclient_21_13
LD_LIBRARY_PATH=/opt/render/project/src/oracle/instantclient_21_13:$LD_LIBRARY_PATH
```

### 2. Instalar Oracle Instant Client Manualmente

Se o download automático não funcionar, você pode:

1. **Baixar o Oracle Instant Client**:
   - Acesse: https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
   - Baixe o "Basic Package" (instantclient-basic-linux.x64-21.13.0.0.0dbru.zip)

2. **Fazer upload para o Render**:
   - Crie um diretório `oracle` na raiz do projeto
   - Extraia o Oracle Client lá
   - Faça commit e push

3. **Ou usar um script de build customizado**:
   - Adicione um script que baixa o Oracle Client de uma fonte alternativa
   - Configure o caminho nas variáveis de ambiente

### 3. Verificar se está funcionando

Após o deploy, verifique os logs do Render. Você deve ver:
- `✅ Modo thick ativado` ou
- `✅ Oracle Instant Client instalado`

Se ainda houver erro, verifique:
- Se o caminho `ORACLE_CLIENT_LIB_DIR` está correto
- Se o `LD_LIBRARY_PATH` inclui o caminho do Oracle Client
- Se as bibliotecas necessárias (`libaio1`) estão instaladas

## Alternativa: Usar Oracle Cloud (se disponível)

Se você tiver acesso ao Oracle Cloud, pode configurar o banco para aceitar conexões sem criptografia nativa, permitindo o uso do modo thin.

