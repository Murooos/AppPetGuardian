# Oracle Instant Client para Render

## ⚠️ Importante

Este diretório deve conter a versão **Linux** do Oracle Instant Client, não a versão Windows.

## Como adicionar o Oracle Client Linux

### Opção 1: Baixar e extrair aqui

1. Baixe o Oracle Instant Client Basic para Linux x64:
   - https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
   - Baixe: `instantclient-basic-linux.x64-23.9.0.23.10dbru.zip` (ou versão mais recente)

2. Extraia aqui:
   ```bash
   unzip instantclient-basic-linux.x64-23.9.0.23.10dbru.zip -d oracle/
   ```

3. A estrutura deve ficar:
   ```
   oracle/
     instantclient_23_9/
       oci.dll (arquivos .so no Linux, não .dll)
       ...
   ```

### Opção 2: Deixar o Render baixar automaticamente

O `render.yaml` já está configurado para baixar automaticamente durante o build.

## Para desenvolvimento local (Windows)

Use o Oracle Client em `venv\instantclient_23_9` (já configurado).

## Para produção (Render - Linux)

Use o Oracle Client em `oracle/instantclient_23_9` (versão Linux).

