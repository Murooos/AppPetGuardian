# 📦 Como Adicionar Oracle Client para o Render

## ⚠️ Importante

Você tem o Oracle Client em `venv\instantclient_23_9` (versão **Windows**). Para o Render funcionar, você precisa da versão **Linux**.

## 🚀 Solução: Adicionar Oracle Client Linux ao Projeto

### Opção 1: Baixar e Adicionar ao Projeto (Recomendado)

1. **Baixe o Oracle Instant Client para Linux**:
   - Acesse: https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
   - Baixe: `instantclient-basic-linux.x64-23.9.0.23.10dbru.zip` (ou versão mais recente)
   - **Nota**: Pode exigir login na Oracle

2. **Crie o diretório `oracle` na raiz do projeto**:
   ```bash
   mkdir oracle
   ```

3. **Extraia o Oracle Client lá**:
   ```bash
   unzip instantclient-basic-linux.x64-23.9.0.23.10dbru.zip -d oracle/
   ```

4. **A estrutura deve ficar assim**:
   ```
   oracle/
     instantclient_23_9/
       oci.so (arquivos .so, não .dll)
       genezi
       ...
   ```

5. **Faça commit e push**:
   ```bash
   git add oracle/
   git commit -m "Adicionar Oracle Instant Client Linux"
   git push
   ```

6. **O Render vai usar automaticamente** o Oracle Client do projeto!

### Opção 2: Deixar o Render Baixar Automaticamente

O `render.yaml` já está configurado para tentar baixar automaticamente. Se funcionar, não precisa fazer nada.

### Opção 3: Configurar Variáveis de Ambiente no Render

Se você preferir, pode configurar manualmente no painel do Render:

1. Acesse: https://dashboard.render.com
2. Vá em **Environment**
3. Adicione:
   ```
   ORACLE_CLIENT_LIB_DIR=/opt/render/project/src/oracle/instantclient_23_9
   LD_LIBRARY_PATH=/opt/render/project/src/oracle/instantclient_23_9:$LD_LIBRARY_PATH
   ```

## ✅ O que foi configurado

- ✅ `render.yaml` atualizado para procurar Oracle Client no projeto primeiro
- ✅ `gerenciador_conexão.py` atualizado para procurar em múltiplos caminhos
- ✅ Suporte para versão 23.9 e 21.13

## 📝 Próximos Passos

1. **Baixe a versão Linux** do Oracle Client
2. **Extraia em `oracle/instantclient_23_9/`**
3. **Faça commit e push**
4. **O Render vai usar automaticamente!**

## 🔍 Verificação

Após o deploy, verifique os logs do Render. Você deve ver:
- `✅ Oracle Client encontrado no projeto` ou
- `✅ Oracle Instant Client instalado`

