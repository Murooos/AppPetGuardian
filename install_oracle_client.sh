#!/bin/bash
# Script para instalar Oracle Instant Client no Render

set -e

echo "🔧 Instalando Oracle Instant Client..."

# Criar diretório para o Oracle Client
ORACLE_CLIENT_DIR="$HOME/oracle/instantclient_21_13"
mkdir -p "$ORACLE_CLIENT_DIR"

# Baixar Oracle Instant Client Basic
cd "$ORACLE_CLIENT_DIR"

# Para Linux x64
echo "📥 Baixando Oracle Instant Client Basic para Linux x64..."
wget -q https://download.oracle.com/otn_software/linux/instantclient/2113000/instantclient-basic-linux.x64-21.13.0.0.0dbru.zip

# Extrair
echo "📦 Extraindo Oracle Instant Client..."
unzip -q instantclient-basic-linux.x64-21.13.0.0.0dbru.zip
rm instantclient-basic-linux.x64-21.13.0.0.0dbru.zip

# Configurar variável de ambiente
export ORACLE_CLIENT_LIB_DIR="$ORACLE_CLIENT_DIR/instantclient_21_13"
export LD_LIBRARY_PATH="$ORACLE_CLIENT_LIB_DIR:$LD_LIBRARY_PATH"

echo "✅ Oracle Instant Client instalado em: $ORACLE_CLIENT_LIB_DIR"
echo "📝 Configure a variável de ambiente ORACLE_CLIENT_LIB_DIR=$ORACLE_CLIENT_LIB_DIR no Render"

