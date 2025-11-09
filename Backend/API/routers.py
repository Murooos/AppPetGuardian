from fastapi import APIRouter, HTTPException
from pathlib import Path
import sys

BASE_DIR = Path(__file__).resolve().parent
sys.path.append(str(BASE_DIR / "Banco_dados"))

from models import Animal

router = APIRouter(prefix="/animais", tags=["Animais"])

# Banco de dados fake (apenas exemplo)
animais = []

@router.get("/")
def listar_animais():
    from Banco_dados.scrips import ver_animais
    animais = ver_animais()
    return animais

@router.post("/")
def adicionar_animal(animal: Animal):
    animais.append(animal)
    return {"mensagem": "Animal adicionado com sucesso!", "animal": animal}

@router.get("/{id}")
def buscar_animal(id: int):
    for a in animais:
        if a.id == id:
            return a
    raise HTTPException(status_code=404, detail="Animal não encontrado")
