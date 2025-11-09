# 🚀 Guia de Deploy - Pet Guardian MVP

Este guia explica como fazer o deploy do Pet Guardian no Render.com (backend) e Netlify (frontend).

## 📋 Pré-requisitos

- Conta no [Render.com](https://render.com)
- Conta no [Netlify](https://netlify.com)
- Repositório Git (GitHub, GitLab ou Bitbucket)
- Variáveis de ambiente configuradas

## 🔧 Deploy no Render.com (Backend)

### Passo 1: Preparar o Repositório

1. Certifique-se de que todos os arquivos estão commitados:
```bash
git add .
git commit -m "Preparar para deploy"
git push origin main
```

### Passo 2: Criar Serviço no Render.com

1. Acesse [Render.com Dashboard](https://dashboard.render.com)
2. Clique em **"New +"** → **"Web Service"**
3. Conecte seu repositório Git
4. Configure o serviço:
   - **Name**: `pet-guardian-api` (ou o nome que preferir)
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `cd Backend/API && python -m uvicorn main:app --host 0.0.0.0 --port $PORT`

### Passo 3: Configurar Variáveis de Ambiente

No painel do Render, vá em **Environment** e adicione:

```
ORACLE_DSN=db.freesql.com:1521/23ai_mb9q7
ORACLE_USER=SQL_NRHDYLQ3XIT2QAXIM21V7DMOZ7
ORACLE_PASSWORD=sua_senha_aqui
JWT_SECRET_KEY=sua_chave_secreta_super_segura_aqui
ALLOWED_ORIGINS=https://seu-site.netlify.app
```

**Importante**: 
- Gere uma chave JWT segura (pode usar: `python -c "import secrets; print(secrets.token_urlsafe(32))"`)
- Após fazer o deploy no Netlify, atualize `ALLOWED_ORIGINS` com a URL do seu site

### Passo 4: Deploy Automático

O Render fará o deploy automaticamente. Aguarde alguns minutos e anote a URL do serviço (ex: `https://pet-guardian-api.onrender.com`)

## 🌐 Deploy no Netlify (Frontend)

### Passo 1: Preparar o Frontend

1. Atualize o `index.html` com a URL da API do Render (se necessário)
2. Certifique-se de que o `netlify.toml` está configurado corretamente

### Passo 2: Deploy via Git

1. Acesse [Netlify Dashboard](https://app.netlify.com)
2. Clique em **"Add new site"** → **"Import an existing project"**
3. Conecte seu repositório Git
4. Configure o build:
   - **Build command**: (deixe vazio ou `echo "No build needed"`)
   - **Publish directory**: `.` (raiz do projeto)
   - **Base directory**: (deixe vazio)

### Passo 3: Configurar Variáveis de Ambiente (Opcional)

No painel do Netlify, vá em **Site settings** → **Environment variables** e adicione:

```
REACT_APP_API_URL=https://pet-guardian-api.onrender.com
```

### Passo 4: Atualizar CORS no Render

Após obter a URL do Netlify (ex: `https://pet-guardian.netlify.app`), volte ao Render e atualize:

```
ALLOWED_ORIGINS=https://pet-guardian.netlify.app
```

## ✅ Verificação

1. **Backend**: Acesse `https://pet-guardian-api.onrender.com/health` - deve retornar `{"status": "ok"}`
2. **Frontend**: Acesse a URL do Netlify e verifique se o status da API aparece como "Online"

## 🔍 Troubleshooting

### Backend não inicia no Render

- Verifique se o `Start Command` está correto
- Verifique os logs no painel do Render
- Certifique-se de que todas as dependências estão no `requirements.txt`

### CORS Error no Frontend

- Verifique se `ALLOWED_ORIGINS` no Render contém a URL exata do Netlify
- Certifique-se de que não há espaços extras na URL

### API Offline no Frontend

- Verifique se a URL da API no `index.html` está correta
- Verifique se o serviço no Render está rodando (não em "sleep")
- No plano gratuito do Render, o serviço pode entrar em "sleep" após inatividade

## 📝 Notas Importantes

- **Render Free Tier**: O serviço pode entrar em "sleep" após 15 minutos de inatividade. O primeiro acesso após o sleep pode demorar ~30 segundos.
- **Netlify Free Tier**: Inclui HTTPS automático e deploy contínuo via Git.
- **Variáveis Sensíveis**: Nunca commite arquivos `.env` com credenciais reais. Use sempre variáveis de ambiente nos serviços.

## 🎉 Pronto!

Seu MVP está no ar! Compartilhe as URLs:
- **Frontend**: `https://seu-site.netlify.app`
- **Backend API**: `https://pet-guardian-api.onrender.com`
- **API Docs**: `https://pet-guardian-api.onrender.com/docs`

