from fastapi import APIRouter, HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import datetime, timedelta
from models import Animal
import jwt

# Chave secreta para assinar o token (em produção, use .env)
SECRET_KEY = "minha_chave_super_secreta"

auth_router = APIRouter(tags=["Autenticação"])

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

# Usuário fake
fake_user = {"username": "admin", "password": "1234"}

def criar_token(dados: dict):
    expiracao = datetime.utcnow() + timedelta(hours=1)
    dados["exp"] = expiracao
    token = jwt.encode(dados, SECRET_KEY, algorithm="HS256")
    return token

@auth_router.post("/login")
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    if form_data.username != fake_user["username"] or form_data.password != fake_user["password"]:
        raise HTTPException(status_code=401, detail="Usuário ou senha inválidos")
    token = criar_token({"sub": form_data.username})
    return {"access_token": token, "token_type": "bearer"}

@auth_router.get("/me")
def perfil(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        return {"usuario": payload.get("sub")}
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expirado")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Token inválido")
