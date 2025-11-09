from gerenciador_conexão import DBHandler
from pathlib import Path
import sys

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.append(str(BASE_DIR))

def ver_animais():
    db = DBHandler()  # não precisa passar argumentos

    query = "SELECT * FROM animal"
    lista = db.execute(query)
    
    print(lista)
    
    db.close()
    return lista

ver_animais()

def ver_veterinario():
    db = DBHandler()  # não precisa passar argumentos

    query = "SELECT * FROM veterinario"
    lista = db.execute(query)
    
    print(lista)
    
    db.close()

ver_veterinario()

def ver_clinica():
    db = DBHandler()  # não precisa passar argumentos

    query = "SELECT * FROM clinica"
    lista = db.execute(query)
    
    print(lista)
    
    db.close()

ver_clinica()

def ver_usuario():
    db = DBHandler()  # não precisa passar argumentos

    query = "SELECT * FROM usuario"
    lista = db.execute(query)
    
    print(lista)
    
    db.close()

ver_usuario()

def ver_convenio():
    db = DBHandler()  # não precisa passar argumentos

    query = "SELECT * FROM convenio"
    lista = db.execute(query)
    
    print(lista)
    
    db.close()

ver_convenio()


def ver_historicomedico():
    db = DBHandler()  # não precisa passar argumentos
   
    query = "SELECT * FROM historicomedico"
    lista = db.execute(query)
    
    print(lista)
    
    db.close()

ver_historicomedico()
