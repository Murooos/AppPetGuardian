# 🔧 Troubleshooting - Deploy Render.com

## ❌ Erro: "requirements.txt não encontrado"

### Possíveis Causas e Soluções:

#### 1. Arquivo não está commitado no Git

**Solução:**
```bash
# Verifique se o arquivo está no repositório
git status

# Se não estiver, adicione e faça commit
git add requirements.txt
git commit -m "Adicionar requirements.txt"
git push origin main
```

#### 2. Render não está usando o render.yaml

**Solução:**
- No painel do Render, vá em **Settings** → **Build & Deploy**
- Verifique se o **Build Command** está configurado manualmente
- Se estiver, remova a configuração manual e deixe o Render usar o `render.yaml`
- Ou configure manualmente:
  - **Build Command**: `pip install --upgrade pip && pip install -r requirements.txt`

#### 3. Arquivo está em local diferente

**Solução:**
- Verifique se o `requirements.txt` está na **raiz do repositório**
- Se estiver em outro local, ajuste o caminho no `render.yaml`:
  ```yaml
  buildCommand: pip install --upgrade pip && pip install -r /caminho/para/requirements.txt
  ```

#### 4. Render não detecta automaticamente o Python

**Solução:**
- Certifique-se de que o arquivo `runtime.txt` existe na raiz (já criado)
- Ou configure manualmente no Render:
  - **Environment**: `Python 3`
  - **Python Version**: `3.11.0`

### ✅ Verificação Rápida

1. **Verifique se o arquivo existe:**
   ```bash
   ls -la requirements.txt
   ```

2. **Verifique se está no Git:**
   ```bash
   git ls-files | grep requirements.txt
   ```

3. **Verifique o conteúdo do arquivo:**
   ```bash
   cat requirements.txt
   ```

### 🔄 Solução Alternativa (Configuração Manual no Render)

Se o `render.yaml` não estiver funcionando, configure manualmente no painel do Render:

1. Acesse o serviço no Render
2. Vá em **Settings** → **Build & Deploy**
3. Configure:
   - **Build Command**: `pip install --upgrade pip && pip install -r requirements.txt`
   - **Start Command**: `cd Backend/API && python -m uvicorn main:app --host 0.0.0.0 --port $PORT`
   - **Python Version**: `3.11.0`

### 📝 Checklist

- [ ] `requirements.txt` existe na raiz do projeto
- [ ] `requirements.txt` está commitado no Git
- [ ] `render.yaml` está na raiz do projeto
- [ ] `runtime.txt` existe (opcional, mas recomendado)
- [ ] Repositório está conectado ao Render
- [ ] Build Command está configurado corretamente

### 🆘 Se Nada Funcionar

1. **Crie um novo serviço no Render** e configure manualmente
2. **Verifique os logs** no painel do Render para ver o erro exato
3. **Teste localmente** se o requirements.txt funciona:
   ```bash
   pip install -r requirements.txt
   ```

