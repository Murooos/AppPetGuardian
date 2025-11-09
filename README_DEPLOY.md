# 🚀 Deploy Rápido - Pet Guardian MVP

## ⚡ Início Rápido

### 1️⃣ Render.com (Backend)

1. Acesse [render.com](https://render.com) e crie uma conta
2. Clique em **"New +"** → **"Web Service"**
3. Conecte seu repositório Git
4. Use as configurações do arquivo `render.yaml` ou configure manualmente:
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `cd Backend/API && python -m uvicorn main:app --host 0.0.0.0 --port $PORT`
5. Configure as variáveis de ambiente (veja `env.example`)
6. Aguarde o deploy e anote a URL (ex: `https://pet-guardian-api.onrender.com`)

### 2️⃣ Netlify (Frontend)

1. Acesse [netlify.com](https://netlify.com) e crie uma conta
2. Clique em **"Add new site"** → **"Import an existing project"**
3. Conecte seu repositório Git
4. Configure:
   - **Build command**: (deixe vazio)
   - **Publish directory**: `.`
5. O arquivo `netlify.toml` já está configurado
6. Aguarde o deploy e anote a URL (ex: `https://pet-guardian.netlify.app`)

### 3️⃣ Atualizar CORS

Após obter a URL do Netlify, volte ao Render e atualize a variável:
```
ALLOWED_ORIGINS=https://sua-url.netlify.app
```

## 📝 Variáveis de Ambiente Necessárias

### Render.com (Backend)
```
ORACLE_DSN=db.freesql.com:1521/23ai_mb9q7
ORACLE_USER=SQL_NRHDYLQ3XIT2QAXIM21V7DMOZ7
ORACLE_PASSWORD=sua_senha
JWT_SECRET_KEY=sua_chave_secreta
ALLOWED_ORIGINS=https://sua-url.netlify.app
```

## ✅ Verificar Deploy

- **Backend**: `https://sua-api.onrender.com/health`
- **Frontend**: `https://sua-url.netlify.app`
- **API Docs**: `https://sua-api.onrender.com/docs`

## 🔧 Troubleshooting

- **API Offline**: Verifique se o serviço no Render não está em "sleep" (plano gratuito)
- **CORS Error**: Verifique se `ALLOWED_ORIGINS` está correto no Render
- **Erro 500**: Verifique os logs no painel do Render

Para mais detalhes, consulte `DEPLOY.md`

