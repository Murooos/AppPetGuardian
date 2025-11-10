from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pathlib import Path
import sys
import os

# adiciona a raiz do projeto ao path
BASE_DIR = Path(__file__).resolve().parent
sys.path.append(str(BASE_DIR))
from routers import (
    router_animais,
    router_usuarios,
    router_convenios,
    router_clinicas,
    router_veterinarios,
    router_historico
)
from authentic import auth_router

app = FastAPI(title="API Pet Guardian", version="1.0")

# Configurar CORS para permitir requisições do Netlify
# Permitir explicitamente a origem do Netlify e outras origens comuns
allowed_origins_env = os.getenv("ALLOWED_ORIGINS", "*")
if allowed_origins_env == "*":
    # Permitir todas as origens quando for "*"
    allowed_origins = ["*"]
    allow_credentials = False
else:
    # Permitir origens específicas
    allowed_origins = [origin.strip() for origin in allowed_origins_env.split(",") if origin.strip()]
    allow_credentials = True

# Adicionar origem do Netlify por padrão se não estiver na lista
if allowed_origins != ["*"] and "https://pet-guardian.netlify.app" not in allowed_origins:
    allowed_origins.append("https://pet-guardian.netlify.app")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=allow_credentials,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
    expose_headers=["*"],
)

# Inclui rotas
app.include_router(router_animais)
app.include_router(router_usuarios)
app.include_router(router_convenios)
app.include_router(router_clinicas)
app.include_router(router_veterinarios)
app.include_router(router_historico)
app.include_router(auth_router, prefix="/auth")

@app.get("/")
def raiz():
    return {"mensagem": "Bem-vindo à API Pet Guardian!"}

@app.get("/health")
def health_check():
    return {"status": "ok", "service": "Pet Guardian API"}
