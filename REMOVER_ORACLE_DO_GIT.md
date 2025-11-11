# 🚫 Remover Oracle Client do Git

## ⚠️ Problema

O GitHub não permite arquivos maiores que 100MB. O Oracle Instant Client contém arquivos grandes (ex: `libociei.so` com 195MB).

## ✅ Solução

### 1. O `.gitignore` já foi criado

O arquivo `.gitignore` já está configurado para ignorar:
- `oracle/` - Diretório do Oracle Client
- `venv/instantclient_*/` - Oracle Client no venv

### 2. Remover do Git (se já foi adicionado)

Execute estes comandos no terminal:

```bash
# Remover do índice do Git (mas manter os arquivos localmente)
git rm -r --cached oracle/

# Fazer commit da remoção
git commit -m "Remover Oracle Client do Git (arquivos muito grandes)"

# Fazer push
git push
```

### 3. Verificar

Após o push, verifique:
- ✅ O diretório `oracle/` não aparece mais no GitHub
- ✅ Os arquivos ainda existem localmente (não foram deletados)
- ✅ O `.gitignore` está funcionando

## 🚀 No Render

O `render.yaml` já está configurado para **baixar automaticamente** o Oracle Client durante o build. Não precisa fazer upload manual!

## 📝 Importante

- **NÃO** faça commit do Oracle Client no Git
- O Render vai baixar automaticamente durante o build
- Mantenha o Oracle Client localmente em `venv\instantclient_23_9` para desenvolvimento


