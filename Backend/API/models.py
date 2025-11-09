from pydantic import BaseModel

class Animal(BaseModel):
    id: int
    nome: str
    especie: str
    idade: int
