from fastapi import APIRouter, HTTPException
from pathlib import Path
import sys
import os

# Ajustar o path para encontrar o módulo Banco_dados
BASE_DIR = Path(__file__).resolve().parent
# Banco_dados está em Backend/Banco_dados, então vamos um nível acima
PARENT_DIR = BASE_DIR.parent
sys.path.insert(0, str(PARENT_DIR))
sys.path.insert(0, str(PARENT_DIR / "Banco_dados"))

from models import Animal, Usuario, Convenio, Clinica, Veterinario, HistoricoMedico

# Router para Animais
router_animais = APIRouter(prefix="/animais", tags=["Animais"])

@router_animais.get("/")
def listar_animais():
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import ver_animais
    import traceback
    import os
    try:
        animais = ver_animais()
        return animais
    except Exception as e:
        error_detail = f"Erro ao listar animais: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_animais.post("/")
def adicionar_animal(animal: Animal):
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import inserir_animal
    import traceback
    try:
        inserir_animal(
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
        # Em desenvolvimento, incluir traceback completo
        import os
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

# Router para Usuários
router_usuarios = APIRouter(prefix="/usuarios", tags=["Usuários"])

@router_usuarios.get("/")
def listar_usuarios():
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import ver_usuario
    import traceback
    import os
    try:
        usuarios = ver_usuario()
        return usuarios
    except Exception as e:
        error_detail = f"Erro ao listar usuários: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_usuarios.post("/")
def adicionar_usuario(usuario: Usuario):
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import inserir_usuario
    import traceback
    import os
    try:
        inserir_usuario(
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
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import ver_convenio
    import traceback
    import os
    try:
        convenios = ver_convenio()
        return convenios
    except Exception as e:
        error_detail = f"Erro ao listar convênios: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_convenios.post("/")
def adicionar_convenio(convenio: Convenio):
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import inserir_convenio
    import traceback
    import os
    try:
        inserir_convenio(
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
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import ver_clinica
    import traceback
    import os
    try:
        clinicas = ver_clinica()
        return clinicas
    except Exception as e:
        error_detail = f"Erro ao listar clínicas: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_clinicas.post("/")
def adicionar_clinica(clinica: Clinica):
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import inserir_clinica
    import traceback
    import os
    try:
        inserir_clinica(
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
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import ver_veterinario
    import traceback
    import os
    try:
        veterinarios = ver_veterinario()
        return veterinarios
    except Exception as e:
        error_detail = f"Erro ao listar veterinários: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_veterinarios.post("/")
def adicionar_veterinario(veterinario: Veterinario):
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import inserir_veterinario
    import traceback
    import os
    try:
        inserir_veterinario(
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
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import ver_historicomedico
    import traceback
    import os
    try:
        historicos = ver_historicomedico()
        return historicos
    except Exception as e:
        error_detail = f"Erro ao listar histórico médico: {str(e)}"
        if os.getenv("DEBUG", "false").lower() == "true":
            error_detail += f"\nTraceback: {traceback.format_exc()}"
        raise HTTPException(status_code=500, detail=error_detail)

@router_historico.post("/")
def adicionar_historico(historico: HistoricoMedico):
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "Banco_dados"))
    from scrips import inserir_historicomedico
    import traceback
    import os
    try:
        inserir_historicomedico(
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
