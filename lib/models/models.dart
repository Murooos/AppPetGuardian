class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String tipo; // 'tutor' ou 'clinica'
  final String? cnpj;
  final String? telefone;
  final String? endereco;
  final String? cidade;
  final String? estado;
  final String? cep;
  final String? especialidades; // Para clínicas
  final String? horarioAbertura; // Para clínicas
  final String? horarioFechamento; // Para clínicas

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.tipo,
    this.cnpj,
    this.telefone,
    this.endereco,
    this.cidade,
    this.estado,
    this.cep,
    this.especialidades,
    this.horarioAbertura,
    this.horarioFechamento,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'email': email,
        'senha': senha,
        'tipo': tipo,
        'cnpj': cnpj,
        'telefone': telefone,
        'endereco': endereco,
        'cidade': cidade,
        'estado': estado,
        'cep': cep,
        'especialidades': especialidades,
        'horarioAbertura': horarioAbertura,
        'horarioFechamento': horarioFechamento,
      };

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
        id: map['id'],
        nome: map['nome'],
        email: map['email'],
        senha: map['senha'],
        tipo: map['tipo'],
        cnpj: map['cnpj'],
        telefone: map['telefone'],
        endereco: map['endereco'],
        cidade: map['cidade'],
        estado: map['estado'],
        cep: map['cep'],
        especialidades: map['especialidades'],
        horarioAbertura: map['horarioAbertura'],
        horarioFechamento: map['horarioFechamento'],
      );
}

class Pet {
  final int? id;
  final int? tutorId;
  final int? clinicaId;
  final String criadoPor; // 'tutor' ou 'clinica'
  final String nome;
  final String especie;
  final String raca;
  final String sexo;
  final int idade;
  final String? fotoPath;
  final String? codigo;

  Pet({
    this.id,
    this.tutorId,
    this.clinicaId,
    required this.criadoPor,
    required this.nome,
    required this.especie,
    required this.raca,
    required this.sexo,
    required this.idade,
    this.fotoPath,
    this.codigo,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'tutorId': tutorId,
        'clinicaId': clinicaId,
        'criadoPor': criadoPor,
        'nome': nome,
        'especie': especie,
        'raca': raca,
        'sexo': sexo,
        'idade': idade,
        'fotoPath': fotoPath,
        'codigo': codigo,
      };

  factory Pet.fromMap(Map<String, dynamic> map) => Pet(
        id: map['id'],
        tutorId: map['tutorId'],
        clinicaId: map['clinicaId'],
        criadoPor: map['criadoPor'] ?? 'tutor',
        nome: map['nome'],
        especie: map['especie'],
        raca: map['raca'],
        sexo: map['sexo'],
        idade: map['idade'],
        fotoPath: map['fotoPath'],
        codigo: map['codigo'],
      );
}

class Exame {
  final int? id;
  final int petId;
  final String titulo;
  final String data;
  final String? descricao;
  final String? arquivoPath;
  final String? clinicaNome;

  Exame({
    this.id,
    required this.petId,
    required this.titulo,
    required this.data,
    this.descricao,
    this.arquivoPath,
    this.clinicaNome,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'petId': petId,
        'titulo': titulo,
        'data': data,
        'descricao': descricao,
        'arquivoPath': arquivoPath,
        'clinicaNome': clinicaNome,
      };

  factory Exame.fromMap(Map<String, dynamic> map) => Exame(
        id: map['id'],
        petId: map['petId'],
        titulo: map['titulo'],
        data: map['data'],
        descricao: map['descricao'],
        arquivoPath: map['arquivoPath'],
        clinicaNome: map['clinicaNome'],
      );
}

class Alarme {
  final int? id;
  final int petId;
  final String titulo;
  final String descricao;
  final String data;
  final String? clinicaNome;
  final String? clinicaLogo;

  Alarme({
    this.id,
    required this.petId,
    required this.titulo,
    required this.descricao,
    required this.data,
    this.clinicaNome,
    this.clinicaLogo,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'petId': petId,
        'titulo': titulo,
        'descricao': descricao,
        'data': data,
        'clinicaNome': clinicaNome,
        'clinicaLogo': clinicaLogo,
      };

  factory Alarme.fromMap(Map<String, dynamic> map) => Alarme(
        id: map['id'],
        petId: map['petId'],
        titulo: map['titulo'],
        descricao: map['descricao'],
        data: map['data'],
        clinicaNome: map['clinicaNome'],
        clinicaLogo: map['clinicaLogo'],
      );
}

class Dieta {
  final int? id;
  final int petId;
  final int? clinicaId;
  final String nome;
  final String marca;
  final String tipo; // 'Ração', 'Alimento Natural', 'Complemento', etc
  final String? composicao;
  final String? beneficios;
  final String? recomendacoes;
  final String? imagemPath;
  final String dataCriacao;
  final String? clinicaNome;

  Dieta({
    this.id,
    required this.petId,
    this.clinicaId,
    required this.nome,
    required this.marca,
    required this.tipo,
    this.composicao,
    this.beneficios,
    this.recomendacoes,
    this.imagemPath,
    required this.dataCriacao,
    this.clinicaNome,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'petId': petId,
        'clinicaId': clinicaId,
        'nome': nome,
        'marca': marca,
        'tipo': tipo,
        'composicao': composicao,
        'beneficios': beneficios,
        'recomendacoes': recomendacoes,
        'imagemPath': imagemPath,
        'dataCriacao': dataCriacao,
        'clinicaNome': clinicaNome,
      };

  factory Dieta.fromMap(Map<String, dynamic> map) => Dieta(
        id: map['id'],
        petId: map['petId'],
        clinicaId: map['clinicaId'],
        nome: map['nome'],
        marca: map['marca'],
        tipo: map['tipo'],
        composicao: map['composicao'],
        beneficios: map['beneficios'],
        recomendacoes: map['recomendacoes'],
        imagemPath: map['imagemPath'],
        dataCriacao: map['dataCriacao'],
        clinicaNome: map['clinicaNome'],
      );
}

class Agendamento {
  final int? id;
  final int petId;
  final int? clinicaId;
  final String tipo; // 'consulta', 'vacina', 'exame'
  final String data;
  final String? hora;
  final String? observacao;
  final String status; // 'agendado', 'realizado', 'cancelado'

  Agendamento({
    this.id,
    required this.petId,
    this.clinicaId,
    required this.tipo,
    required this.data,
    this.hora,
    this.observacao,
    this.status = 'agendado',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'petId': petId,
        'clinicaId': clinicaId,
        'tipo': tipo,
        'data': data,
        'hora': hora,
        'observacao': observacao,
        'status': status,
      };

  factory Agendamento.fromMap(Map<String, dynamic> map) => Agendamento(
        id: map['id'],
        petId: map['petId'],
        clinicaId: map['clinicaId'],
        tipo: map['tipo'],
        data: map['data'],
        hora: map['hora'],
        observacao: map['observacao'],
        status: map['status'] ?? 'agendado',
      );
}

class Vacinacao {
  final int? id;
  final int petId;
  final String nome;
  final String data;
  final String? proximaDose;
  final String? clinicaNome;
  final String? veterinario;

  Vacinacao({
    this.id,
    required this.petId,
    required this.nome,
    required this.data,
    this.proximaDose,
    this.clinicaNome,
    this.veterinario,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'petId': petId,
        'nome': nome,
        'data': data,
        'proximaDose': proximaDose,
        'clinicaNome': clinicaNome,
        'veterinario': veterinario,
      };

  factory Vacinacao.fromMap(Map<String, dynamic> map) => Vacinacao(
        id: map['id'],
        petId: map['petId'],
        nome: map['nome'],
        data: map['data'],
        proximaDose: map['proximaDose'],
        clinicaNome: map['clinicaNome'],
        veterinario: map['veterinario'],
      );
}

