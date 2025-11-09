from fastapi import FastAPI
from pathlib import Path
import sys

# adiciona a raiz do projeto ao path
BASE_DIR = Path(__file__).resolve().parent
sys.path.append(str(BASE_DIR))
from routers import router
from authentic import auth_router
from models import Animal

app = FastAPI(title="API de Exemplo", version="1.0")

# Inclui rotas
app.include_router(router)
app.include_router(auth_router, prefix="/auth")

@app.get("/")
def raiz():
    return {"mensagem": "Bem-vindo à API!"}
