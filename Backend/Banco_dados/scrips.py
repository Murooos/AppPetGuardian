from gerenciador_conexão import DBHandler
from pathlib import Path
import sys

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.append(str(BASE_DIR))

# Funções de leitura
def ver_animais():
    db = DBHandler()
    try:
        query = "SELECT * FROM animal WHERE ativo = 1"
        lista = db.execute(query)
        return lista
    finally:
        db.close()

def ver_usuario():
    db = DBHandler()
    try:
        query = "SELECT * FROM usuario WHERE ativo = 1"
        lista = db.execute(query)
        return lista
    finally:
        db.close()

def ver_convenio():
    db = DBHandler()
    try:
        query = "SELECT * FROM convenio WHERE ativo = 1"
        lista = db.execute(query)
        return lista if lista is not None else []
    except Exception as e:
        # Log do erro para debug
        import sys
        print(f"Erro em ver_convenio: {str(e)}", file=sys.stderr)
        raise
    finally:
        db.close()

def ver_clinica():
    db = DBHandler()
    try:
        query = "SELECT * FROM clinica WHERE ativo = 1"
        lista = db.execute(query)
        return lista
    finally:
        db.close()

def ver_veterinario():
    db = DBHandler()
    try:
        query = "SELECT * FROM veterinario WHERE ativo = 1"
        lista = db.execute(query)
        return lista
    finally:
        db.close()

def ver_historicomedico():
    db = DBHandler()
    try:
        query = "SELECT * FROM historicomedico WHERE ativo = 1"
        lista = db.execute(query)
        return lista
    finally:
        db.close()

# Funções de inserção
def inserir_animal(nome, especie, raca=None, datanascimento=None, tutorid=None, convenioid=None):
    db = DBHandler()
    try:
        # Construir query dinamicamente para evitar problemas com None
        campos = ['nome', 'especie']
        valores = [':nome', ':especie']
        params = {'nome': nome, 'especie': especie}
        
        if raca is not None:
            campos.append('raca')
            valores.append(':raca')
            params['raca'] = raca
        if datanascimento is not None:
            campos.append('datanascimento')
            valores.append(':datanascimento')
            params['datanascimento'] = datanascimento
        if tutorid is not None:
            campos.append('tutorid')
            valores.append(':tutorid')
            params['tutorid'] = tutorid
        if convenioid is not None:
            campos.append('convenioid')
            valores.append(':convenioid')
            params['convenioid'] = convenioid
        
        query = f"INSERT INTO animal ({', '.join(campos)}) VALUES ({', '.join(valores)})"
        db.execute(query, params)
    finally:
        db.close()

def inserir_usuario(nome, endereco=None, telefone=None, email=None, convenioid=None, senha=None):
    db = DBHandler()
    try:
        campos = ['nome']
        valores = [':nome']
        params = {'nome': nome}
        
        if endereco is not None:
            campos.append('endereco')
            valores.append(':endereco')
            params['endereco'] = endereco
        if telefone is not None:
            campos.append('telefone')
            valores.append(':telefone')
            params['telefone'] = telefone
        if email is not None:
            campos.append('email')
            valores.append(':email')
            params['email'] = email
        if convenioid is not None:
            campos.append('convenioid')
            valores.append(':convenioid')
            params['convenioid'] = convenioid
        if senha is not None:
            campos.append('senha')
            valores.append(':senha')
            params['senha'] = senha
        
        query = f"INSERT INTO usuario ({', '.join(campos)}) VALUES ({', '.join(valores)})"
        db.execute(query, params)
    finally:
        db.close()

def inserir_convenio(nome, tipoplano=None, datavalidade=None):
    db = DBHandler()
    try:
        campos = ['nome']
        valores = [':nome']
        params = {'nome': nome}
        
        if tipoplano is not None:
            campos.append('tipoplano')
            valores.append(':tipoplano')
            params['tipoplano'] = tipoplano
        if datavalidade is not None:
            campos.append('datavalidade')
            valores.append(':datavalidade')
            params['datavalidade'] = datavalidade
        
        query = f"INSERT INTO convenio ({', '.join(campos)}) VALUES ({', '.join(valores)})"
        db.execute(query, params)
    finally:
        db.close()

def inserir_clinica(nome, endereco=None, telefone=None, email=None, senha=None):
    db = DBHandler()
    try:
        campos = ['nome']
        valores = [':nome']
        params = {'nome': nome}
        
        if endereco is not None:
            campos.append('endereco')
            valores.append(':endereco')
            params['endereco'] = endereco
        if telefone is not None:
            campos.append('telefone')
            valores.append(':telefone')
            params['telefone'] = telefone
        if email is not None:
            campos.append('email')
            valores.append(':email')
            params['email'] = email
        if senha is not None:
            campos.append('senha')
            valores.append(':senha')
            params['senha'] = senha
        
        query = f"INSERT INTO clinica ({', '.join(campos)}) VALUES ({', '.join(valores)})"
        db.execute(query, params)
    finally:
        db.close()

def inserir_veterinario(nome, telefone=None, email=None, registroprofissional=None, clinicaid=None, senha=None):
    db = DBHandler()
    try:
        campos = ['nome']
        valores = [':nome']
        params = {'nome': nome}
        
        if telefone is not None:
            campos.append('telefone')
            valores.append(':telefone')
            params['telefone'] = telefone
        if email is not None:
            campos.append('email')
            valores.append(':email')
            params['email'] = email
        if registroprofissional is not None:
            campos.append('registroprofissional')
            valores.append(':registroprofissional')
            params['registroprofissional'] = registroprofissional
        if clinicaid is not None:
            campos.append('clinicaid')
            valores.append(':clinicaid')
            params['clinicaid'] = clinicaid
        if senha is not None:
            campos.append('senha')
            valores.append(':senha')
            params['senha'] = senha
        
        query = f"INSERT INTO veterinario ({', '.join(campos)}) VALUES ({', '.join(valores)})"
        db.execute(query, params)
    finally:
        db.close()

def inserir_historicomedico(dataconsulta, animalid, veterinarioid, diagnostico=None, tratamento=None, observacoes=None, exameclinico=None):
    db = DBHandler()
    try:
        campos = ['dataconsulta', 'animalid', 'veterinarioid']
        valores = [':dataconsulta', ':animalid', ':veterinarioid']
        params = {
            'dataconsulta': dataconsulta,
            'animalid': animalid,
            'veterinarioid': veterinarioid
        }
        
        if diagnostico is not None:
            campos.append('diagnostico')
            valores.append(':diagnostico')
            params['diagnostico'] = diagnostico
        if tratamento is not None:
            campos.append('tratamento')
            valores.append(':tratamento')
            params['tratamento'] = tratamento
        if observacoes is not None:
            campos.append('observacoes')
            valores.append(':observacoes')
            params['observacoes'] = observacoes
        if exameclinico is not None:
            campos.append('exameclinico')
            valores.append(':exameclinico')
            params['exameclinico'] = exameclinico
        
        query = f"INSERT INTO historicomedico ({', '.join(campos)}) VALUES ({', '.join(valores)})"
        db.execute(query, params)
    finally:
        db.close()

