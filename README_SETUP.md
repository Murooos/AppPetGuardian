# Guia de Configuração do Ambiente - AppPetGuardian

## Problema com PowerShell

Se você encontrar o erro de política de execução do PowerShell, use uma das soluções abaixo.

## Solução 1: Usar o arquivo .bat (Recomendado)

Simplesmente execute:
```bash
ATIVAR_VENV.bat
```

## Solução 2: Alterar a Política de Execução do PowerShell

Execute no PowerShell **como Administrador**:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Depois, você pode ativar o ambiente virtual normalmente:
```powershell
.\venv\Scripts\Activate.ps1
```

## Solução 3: Usar activate.bat diretamente

No CMD (Prompt de Comando) ou PowerShell:
```bash
venv\Scripts\activate.bat
```

## Passos Completos para Configurar o Projeto

1. **Criar o ambiente virtual:**
   ```bash
   python -m venv venv
   ```

2. **Ativar o ambiente virtual:**
   - Opção A: Execute `ATIVAR_VENV.bat`
   - Opção B: No CMD: `venv\Scripts\activate.bat`
   - Opção C: No PowerShell (após alterar política): `.\venv\Scripts\Activate.ps1`

3. **Instalar as dependências:**
   
   **Opção A - Script automático (Recomendado):**
   ```bash
   INSTALAR_DEPENDENCIAS.bat
   ```
   
   **Opção B - Manual:**
   ```bash
   pip install -r requirements.txt
   ```
   
   **Opção C - Se tiver problema com oracledb:**
   ```bash
   pip install -r requirements-sem-oracle.txt
   pip install --upgrade oracledb
   ```

4. **Executar o projeto:**
   ```bash
   python start.py
   ```

## Nota sobre Políticas de Execução

- `RemoteSigned`: Permite scripts locais e scripts baixados assinados (mais seguro)
- `Bypass`: Desabilita todas as políticas (menos seguro, não recomendado)
- `Restricted`: Padrão do Windows, bloqueia todos os scripts

## Problema ao Instalar oracledb (Erro de Compilação)

Se você encontrar o erro: **"Microsoft Visual C++ 14.0 or greater is required"**, siga uma das soluções:

### Solução 1: Instalar Microsoft C++ Build Tools (Recomendado)

1. Baixe e instale o **Microsoft C++ Build Tools**:
   - Acesse: https://visualstudio.microsoft.com/visual-cpp-build-tools/
   - Baixe o instalador
   - Execute e selecione "Ferramentas de build do C++"
   - Instale e reinicie o terminal

2. Depois, tente instalar novamente:
   ```bash
   pip install -r requirements.txt
   ```

### Solução 2: Instalar oracledb Separadamente (Versão Mais Recente)

Tente instalar uma versão mais recente do oracledb que pode ter wheels pré-compilados:

```bash
pip install --upgrade oracledb
```

Depois instale o resto:
```bash
pip install fastapi uvicorn[standard] PyJWT python-dotenv
```

### Solução 3: Usar Python 3.11 ou 3.12

O Python 3.14 pode não ter wheels pré-compilados para oracledb. Considere usar Python 3.11 ou 3.12 que têm melhor suporte para wheels pré-compilados.

### Solução 4: Instalar Apenas as Dependências Essenciais Primeiro

```bash
pip install fastapi uvicorn[standard] PyJWT python-dotenv
```

Depois tente instalar o oracledb separadamente:
```bash
pip install oracledb --no-build-isolation
```

## Problema ao Conectar ao Oracle (Erro DPY-3001: Native Network Encryption)

Se você encontrar o erro: **"DPY-3001: Native Network Encryption and Data Integrity is only supported in python-oracledb thick mode"**, o servidor Oracle está exigindo criptografia nativa, que só funciona no modo thick.

### Solução: Instalar Oracle Instant Client (Modo Thick)

O modo thick requer o Oracle Instant Client instalado no sistema. Siga os passos:

#### Windows:

1. **Baixar o Oracle Instant Client:**
   - Acesse: https://www.oracle.com/database/technologies/instant-client/downloads.html
   - Baixe o **Oracle Instant Client Basic Package** (versão mais recente)
   - Escolha a versão compatível com seu sistema (32-bit ou 64-bit)

2. **Instalar o Oracle Instant Client:**
   - Extraia o arquivo ZIP em um diretório (ex: `C:\oracle\instantclient_21_3`)
   - Adicione o diretório ao PATH do sistema:
     - Abra "Variáveis de Ambiente" no Windows
     - Edite a variável PATH
     - Adicione o caminho do Instant Client (ex: `C:\oracle\instantclient_21_3`)

3. **Reiniciar o terminal** e testar novamente:
   ```bash
   python Backend/Banco_dados/conexao_oracle.py
   ```

#### Linux:

1. **Instalar via pacote:**
   ```bash
   # Ubuntu/Debian
   sudo apt-get install libaio1
   wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linux.x64-21.3.0.0.0.zip
   unzip instantclient-basic-linux.x64-21.3.0.0.0.zip
   sudo mv instantclient_21_3 /opt/oracle/
   sudo sh -c "echo /opt/oracle/instantclient_21_3 > /etc/ld.so.conf.d/oracle-instantclient.conf"
   sudo ldconfig
   ```

#### macOS:

1. **Instalar via Homebrew:**
   ```bash
   brew tap InstantClientTap/instantclient
   brew install instantclient-basic
   ```

### Verificar se o Modo Thick está Ativo

Após instalar o Oracle Instant Client, execute o script de teste:

```bash
python Backend/Banco_dados/conexao_oracle.py
```

Se você ver a mensagem **"Modo thick ativado (Oracle Client detectado)"**, o modo thick está funcionando corretamente.

### Nota sobre Modo Thin vs Thick

- **Modo Thin (padrão)**: Não requer Oracle Client, mas não suporta criptografia nativa
- **Modo Thick**: Requer Oracle Client instalado, suporta todas as funcionalidades do Oracle, incluindo criptografia nativa

O código tentará automaticamente usar o modo thick se o Oracle Client estiver disponível.

