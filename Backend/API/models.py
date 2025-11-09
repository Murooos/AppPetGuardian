from pydantic import BaseModel
from typing import Optional
from datetime import date, datetime

# Modelo Animal
class Animal(BaseModel):
    id: Optional[int] = None
    nome: str
    especie: str
    raca: Optional[str] = None
    datanascimento: Optional[date] = None
    tutorid: Optional[int] = None
    convenioid: Optional[int] = None

# Modelo Usuário
class Usuario(BaseModel):
    id: Optional[int] = None
    nome: str
    endereco: Optional[str] = None
    telefone: Optional[str] = None
    email: Optional[str] = None
    convenioid: Optional[int] = None
    senha: Optional[str] = None

# Modelo Convênio
class Convenio(BaseModel):
    id: Optional[int] = None
    nome: str
    tipoplano: Optional[str] = None
    datavalidade: Optional[date] = None

# Modelo Clínica
class Clinica(BaseModel):
    id: Optional[int] = None
    nome: str
    endereco: Optional[str] = None
    telefone: Optional[str] = None
    email: Optional[str] = None
    senha: Optional[str] = None

# Modelo Veterinário
class Veterinario(BaseModel):
    id: Optional[int] = None
    nome: str
    telefone: Optional[str] = None
    email: Optional[str] = None
    registroprofissional: Optional[str] = None
    clinicaid: Optional[int] = None
    senha: Optional[str] = None

# Modelo Histórico Médico
class HistoricoMedico(BaseModel):
    id: Optional[int] = None
    dataconsulta: date
    animalid: int
    veterinarioid: int
    diagnostico: Optional[str] = None
    tratamento: Optional[str] = None
    observacoes: Optional[str] = None
    exameclinico: Optional[str] = None
