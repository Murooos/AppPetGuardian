-- Schema PostgreSQL para AppPetGuardian
-- Convertido do schema Oracle

-- ===============================
-- Tabela: convenio
-- ===============================
CREATE TABLE IF NOT EXISTS convenio (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100),
  tipoplano VARCHAR(100),
  datavalidade DATE,
  datacriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataatualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataexclusao TIMESTAMP,
  ativo BOOLEAN DEFAULT TRUE
);

-- ===============================
-- Tabela: usuario
-- ===============================
CREATE TABLE IF NOT EXISTS usuario (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100),
  endereco VARCHAR(200),
  telefone VARCHAR(15),
  email VARCHAR(100),
  convenioid INTEGER,
  senha VARCHAR(100),
  datacriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataatualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataexclusao TIMESTAMP,
  ativo BOOLEAN DEFAULT TRUE,
  CONSTRAINT fk_usuario_convenio FOREIGN KEY (convenioid) REFERENCES convenio (id)
);

-- ===============================
-- Tabela: animal
-- ===============================
CREATE TABLE IF NOT EXISTS animal (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100),
  especie VARCHAR(50),
  raca VARCHAR(50),
  datanascimento DATE,
  tutorid INTEGER,
  convenioid INTEGER,
  datacriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataatualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataexclusao TIMESTAMP,
  ativo BOOLEAN DEFAULT TRUE,
  CONSTRAINT fk_animal_tutor FOREIGN KEY (tutorid) REFERENCES usuario (id),
  CONSTRAINT fk_animal_convenio FOREIGN KEY (convenioid) REFERENCES convenio (id)
);

-- ===============================
-- Tabela: clinica
-- ===============================
CREATE TABLE IF NOT EXISTS clinica (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100),
  endereco VARCHAR(200),
  telefone VARCHAR(15),
  email VARCHAR(100),
  senha VARCHAR(100),
  datacriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataatualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataexclusao TIMESTAMP,
  ativo BOOLEAN DEFAULT TRUE
);

-- ===============================
-- Tabela: veterinario
-- ===============================
CREATE TABLE IF NOT EXISTS veterinario (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100),
  telefone VARCHAR(15),
  email VARCHAR(100),
  registroprofissional VARCHAR(50),
  clinicaid INTEGER,
  senha VARCHAR(100),
  datacriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataatualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataexclusao TIMESTAMP,
  ativo BOOLEAN DEFAULT TRUE,
  CONSTRAINT fk_vet_clinica FOREIGN KEY (clinicaid) REFERENCES clinica (id)
);

-- ===============================
-- Tabela: historicomedico
-- ===============================
CREATE TABLE IF NOT EXISTS historicomedico (
  id SERIAL PRIMARY KEY,
  dataconsulta DATE,
  diagnostico VARCHAR(200),
  tratamento VARCHAR(200),
  observacoes VARCHAR(200),
  exameclinico TEXT, -- PostgreSQL usa TEXT em vez de CLOB
  animalid INTEGER,
  veterinarioid INTEGER,
  datacriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataatualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dataexclusao TIMESTAMP,
  ativo BOOLEAN DEFAULT TRUE,
  CONSTRAINT fk_hist_animal FOREIGN KEY (animalid) REFERENCES animal (id),
  CONSTRAINT fk_hist_vet FOREIGN KEY (veterinarioid) REFERENCES veterinario (id)
);

-- ===============================
-- Trigger: Atualizar data de atualização em ANIMAL
-- ===============================
CREATE OR REPLACE FUNCTION update_animal_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.dataatualizacao := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_animal_update
BEFORE UPDATE ON animal
FOR EACH ROW
EXECUTE FUNCTION update_animal_timestamp();

-- ===============================
-- Triggers para outras tabelas (opcional)
-- ===============================
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.dataatualizacao := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_usuario_update
BEFORE UPDATE ON usuario
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_convenio_update
BEFORE UPDATE ON convenio
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_clinica_update
BEFORE UPDATE ON clinica
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_veterinario_update
BEFORE UPDATE ON veterinario
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_historicomedico_update
BEFORE UPDATE ON historicomedico
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

