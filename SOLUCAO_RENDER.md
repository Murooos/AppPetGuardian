# ✅ Solução Rápida - Erro requirements.txt no Render

## 🔍 Problema Comum

O Render não encontra o arquivo `requirements.txt` durante o build.

## 🚀 Solução Imediata

### Opção 1: Configuração Manual no Render (Recomendado)

1. Acesse o painel do seu serviço no Render
2. Vá em **Settings** → **Build & Deploy**
3. Configure manualmente:

   **Build Command:**
   ```
   pip install --upgrade pip && pip install -r requirements.txt
   ```

   **Start Command:**
   ```
   cd Backend/API && python -m uvicorn main:app --host 0.0.0.0 --port $PORT
   ```

4. Salve e faça um novo deploy

### Opção 2: Verificar se o arquivo está no Git

```bash
# Verifique se o requirements.txt está commitado
git status

# Se não estiver, adicione e faça commit
git add requirements.txt
git commit -m "Adicionar requirements.txt para deploy"
git push origin main
```

### Opção 3: Usar caminho absoluto

Se o arquivo estiver em outro local, ajuste o Build Command:

```
pip install --upgrade pip && pip install -r ./requirements.txt
```

## 📋 Checklist Rápido

- [ ] `requirements.txt` existe na raiz do projeto
- [ ] Arquivo está commitado no Git (`git ls-files | grep requirements.txt`)
- [ ] Build Command está configurado no Render
- [ ] Repositório está conectado corretamente ao Render

## 🔄 Próximos Passos

1. **Faça commit e push** do `requirements.txt` se ainda não fez
2. **Configure manualmente** no Render (Opção 1)
3. **Faça um novo deploy** e verifique os logs

## 📝 Nota Importante

O Render pode não usar automaticamente o `render.yaml` se você criou o serviço manualmente. Nesse caso, configure tudo manualmente no painel do Render.

