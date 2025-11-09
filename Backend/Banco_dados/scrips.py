from gerenciador_conexão import DBHandler
from pathlib import Path
import sys

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.append(str(BASE_DIR))

# Funções de leitura
def ver_animais():
    db = DBHandler()
    query = "SELECT * FROM animal WHERE ativo = 1"
    lista = db.execute(query)
    db.close()
    return lista

def ver_usuario():
    db = DBHandler()
    query = "SELECT * FROM usuario WHERE ativo = 1"
    lista = db.execute(query)
    db.close()
    return lista

def ver_convenio():
    db = DBHandler()
    query = "SELECT * FROM convenio WHERE ativo = 1"
    lista = db.execute(query)
    db.close()
    return lista

def ver_clinica():
    db = DBHandler()
    query = "SELECT * FROM clinica WHERE ativo = 1"
    lista = db.execute(query)
    db.close()
    return lista

def ver_veterinario():
    db = DBHandler()
    query = "SELECT * FROM veterinario WHERE ativo = 1"
    lista = db.execute(query)
    db.close()
    return lista

def ver_historicomedico():
    db = DBHandler()
    query = "SELECT * FROM historicomedico WHERE ativo = 1"
    lista = db.execute(query)
    db.close()
    return lista

# Funções de inserção
def inserir_animal(nome, especie, raca=None, datanascimento=None, tutorid=None, convenioid=None):
    db = DBHandler()
    query = """
        INSERT INTO animal (nome, especie, raca, datanascimento, tutorid, convenioid)
        VALUES (:nome, :especie, :raca, :datanascimento, :tutorid, :convenioid)
    """
    params = {
        'nome': nome,
        'especie': especie,
        'raca': raca,
        'datanascimento': datanascimento,
        'tutorid': tutorid,
        'convenioid': convenioid
    }
    db.execute(query, params)
    db.close()

def inserir_usuario(nome, endereco=None, telefone=None, email=None, convenioid=None, senha=None):
    db = DBHandler()
    query = """
        INSERT INTO usuario (nome, endereco, telefone, email, convenioid, senha)
        VALUES (:nome, :endereco, :telefone, :email, :convenioid, :senha)
    """
    params = {
        'nome': nome,
        'endereco': endereco,
        'telefone': telefone,
        'email': email,
        'convenioid': convenioid,
        'senha': senha
    }
    db.execute(query, params)
    db.close()

def inserir_convenio(nome, tipoplano=None, datavalidade=None):
    db = DBHandler()
    query = """
        INSERT INTO convenio (nome, tipoplano, datavalidade)
        VALUES (:nome, :tipoplano, :datavalidade)
    """
    params = {
        'nome': nome,
        'tipoplano': tipoplano,
        'datavalidade': datavalidade
    }
    db.execute(query, params)
    db.close()

def inserir_clinica(nome, endereco=None, telefone=None, email=None, senha=None):
    db = DBHandler()
    query = """
        INSERT INTO clinica (nome, endereco, telefone, email, senha)
        VALUES (:nome, :endereco, :telefone, :email, :senha)
    """
    params = {
        'nome': nome,
        'endereco': endereco,
        'telefone': telefone,
        'email': email,
        'senha': senha
    }
    db.execute(query, params)
    db.close()

def inserir_veterinario(nome, telefone=None, email=None, registroprofissional=None, clinicaid=None, senha=None):
    db = DBHandler()
    query = """
        INSERT INTO veterinario (nome, telefone, email, registroprofissional, clinicaid, senha)
        VALUES (:nome, :telefone, :email, :registroprofissional, :clinicaid, :senha)
    """
    params = {
        'nome': nome,
        'telefone': telefone,
        'email': email,
        'registroprofissional': registroprofissional,
        'clinicaid': clinicaid,
        'senha': senha
    }
    db.execute(query, params)
    db.close()

def inserir_historicomedico(dataconsulta, animalid, veterinarioid, diagnostico=None, tratamento=None, observacoes=None, exameclinico=None):
    db = DBHandler()
    query = """
        INSERT INTO historicomedico (dataconsulta, animalid, veterinarioid, diagnostico, tratamento, observacoes, exameclinico)
        VALUES (:dataconsulta, :animalid, :veterinarioid, :diagnostico, :tratamento, :observacoes, :exameclinico)
    """
    params = {
        'dataconsulta': dataconsulta,
        'animalid': animalid,
        'veterinarioid': veterinarioid,
        'diagnostico': diagnostico,
        'tratamento': tratamento,
        'observacoes': observacoes,
        'exameclinico': exameclinico
    }
    db.execute(query, params)
    db.close()

