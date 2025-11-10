from fastapi import APIRouter, HTTPException
from pathlib import Path
import sys
import os

# Ajustar o path para encontrar o módulo Banco_dados
BASE_DIR = Path(__file__).resolve().parent
# Banco_dados está em Backend/Banco_dados, então vamos um nível acima
PARENT_DIR = BASE_DIR.parent
BANCO_DADOS_PATH = PARENT_DIR / "Banco_dados"

# Adicionar ao path se não estiver
if str(BANCO_DADOS_PATH) not in sys.path:
    sys.path.insert(0, str(BANCO_DADOS_PATH))
if str(PARENT_DIR) not in sys.path:
    sys.path.insert(0, str(PARENT_DIR))

from models import Animal, Usuario, Convenio, Clinica, Veterinario, HistoricoMedico

# Função auxiliar para garantir que o módulo scrips está acessível
def _import_scrips():
    """Importa o módulo scrips garantindo que o path está correto"""
    banco_dados_path = Path(__file__).resolve().parent.parent / "Banco_dados"
    if str(banco_dados_path) not in sys.path:
        sys.path.insert(0, str(banco_dados_path))
    from scrips import (
        ver_animais, inserir_animal,
        ver_usuario, inserir_usuario,
        ver_convenio, inserir_convenio,
        ver_clinica, inserir_clinica,
        ver_veterinario, inserir_veterinario,
        ver_historicomedico, inserir_historicomedico
    )
    return {
        'ver_animais': ver_animais, 'inserir_animal': inserir_animal,
        'ver_usuario': ver_usuario, 'inserir_usuario': inserir_usuario,
        'ver_convenio': ver_convenio, 'inserir_convenio': inserir_convenio,
        'ver_clinica': ver_clinica, 'inserir_clinica': inserir_clinica,
        'ver_veterinario': ver_veterinario, 'inserir_veterinario': inserir_veterinario,
        'ver_historicomedico': ver_historicomedico, 'inserir_historicomedico': inserir_historicomedico
    }

# Router para Animais
router_animais = APIRouter(prefix="/animais", tags=["Animais"])

@router_animais.get("/")
def listar_animais():
    import traceback
    import os
    try:
        scrips = _import_scrips()
        animais = scrips['ver_animais']()
        return animais
    except Exception as e:
        error_detail = f"Erro ao listar animais: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_animais.post("/")
def adicionar_animal(animal: Animal):
    import traceback
    import os
    try:
        scrips = _import_scrips()
        scrips['inserir_animal'](
            nome=animal.nome,
            especie=animal.especie,
            raca=animal.raca,
            datanascimento=animal.datanascimento,
            tutorid=animal.tutorid,
            convenioid=animal.convenioid
        )
        return {"mensagem": "Animal adicionado com sucesso!", "animal": animal}
    except Exception as e:
        error_detail = f"Erro ao adicionar animal: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

# Router para Usuários
router_usuarios = APIRouter(prefix="/usuarios", tags=["Usuários"])

@router_usuarios.get("/")
def listar_usuarios():
    import traceback
    import os
    try:
        scrips = _import_scrips()
        usuarios = scrips['ver_usuario']()
        return usuarios
    except Exception as e:
        error_detail = f"Erro ao listar usuários: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_usuarios.post("/")
def adicionar_usuario(usuario: Usuario):
    import traceback
    import os
    try:
        scrips = _import_scrips()
        scrips['inserir_usuario'](
            nome=usuario.nome,
            endereco=usuario.endereco,
            telefone=usuario.telefone,
            email=usuario.email,
            convenioid=usuario.convenioid,
            senha=usuario.senha
        )
        return {"mensagem": "Usuário adicionado com sucesso!", "usuario": usuario}
    except Exception as e:
        error_detail = f"Erro ao adicionar usuário: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

# Router para Convênios
router_convenios = APIRouter(prefix="/convenios", tags=["Convênios"])

@router_convenios.get("/")
def listar_convenios():
    import traceback
    import os
    try:
        scrips = _import_scrips()
        convenios = scrips['ver_convenio']()
        return convenios
    except Exception as e:
        error_detail = f"Erro ao listar convênios: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_convenios.post("/")
def adicionar_convenio(convenio: Convenio):
    import traceback
    import os
    try:
        scrips = _import_scrips()
        scrips['inserir_convenio'](
            nome=convenio.nome,
            tipoplano=convenio.tipoplano,
            datavalidade=convenio.datavalidade
        )
        return {"mensagem": "Convênio adicionado com sucesso!", "convenio": convenio}
    except Exception as e:
        error_detail = f"Erro ao adicionar convênio: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

# Router para Clínicas
router_clinicas = APIRouter(prefix="/clinicas", tags=["Clínicas"])

@router_clinicas.get("/")
def listar_clinicas():
    import traceback
    import os
    try:
        scrips = _import_scrips()
        clinicas = scrips['ver_clinica']()
        return clinicas
    except Exception as e:
        error_detail = f"Erro ao listar clínicas: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_clinicas.post("/")
def adicionar_clinica(clinica: Clinica):
    import traceback
    import os
    try:
        scrips = _import_scrips()
        scrips['inserir_clinica'](
            nome=clinica.nome,
            endereco=clinica.endereco,
            telefone=clinica.telefone,
            email=clinica.email,
            senha=clinica.senha
        )
        return {"mensagem": "Clínica adicionada com sucesso!", "clinica": clinica}
    except Exception as e:
        error_detail = f"Erro ao adicionar clínica: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

# Router para Veterinários
router_veterinarios = APIRouter(prefix="/veterinarios", tags=["Veterinários"])

@router_veterinarios.get("/")
def listar_veterinarios():
    import traceback
    import os
    try:
        scrips = _import_scrips()
        veterinarios = scrips['ver_veterinario']()
        return veterinarios
    except Exception as e:
        error_detail = f"Erro ao listar veterinários: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_veterinarios.post("/")
def adicionar_veterinario(veterinario: Veterinario):
    import traceback
    import os
    try:
        scrips = _import_scrips()
        scrips['inserir_veterinario'](
            nome=veterinario.nome,
            telefone=veterinario.telefone,
            email=veterinario.email,
            registroprofissional=veterinario.registroprofissional,
            clinicaid=veterinario.clinicaid,
            senha=veterinario.senha
        )
        return {"mensagem": "Veterinário adicionado com sucesso!", "veterinario": veterinario}
    except Exception as e:
        error_detail = f"Erro ao adicionar veterinário: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

# Router para Histórico Médico
router_historico = APIRouter(prefix="/historicomedico", tags=["Histórico Médico"])

@router_historico.get("/")
def listar_historico():
    import traceback
    import os
    try:
        scrips = _import_scrips()
        historicos = scrips['ver_historicomedico']()
        return historicos
    except Exception as e:
        error_detail = f"Erro ao listar histórico médico: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_historico.post("/")
def adicionar_historico(historico: HistoricoMedico):
    import traceback
    import os
    try:
        scrips = _import_scrips()
        scrips['inserir_historicomedico'](
            dataconsulta=historico.dataconsulta,
            animalid=historico.animalid,
            veterinarioid=historico.veterinarioid,
            diagnostico=historico.diagnostico,
            tratamento=historico.tratamento,
            observacoes=historico.observacoes,
            exameclinico=historico.exameclinico
        )
        return {"mensagem": "Registro médico adicionado com sucesso!", "historico": historico}
    except Exception as e:
        error_detail = f"Erro ao adicionar registro médico: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)
