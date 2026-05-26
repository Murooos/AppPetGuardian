import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pet_guardian.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,
        tipo TEXT NOT NULL,
        cnpj TEXT,
        telefone TEXT,
        endereco TEXT,
        cidade TEXT,
        estado TEXT,
        cep TEXT,
        especialidades TEXT,
        horarioAbertura TEXT,
        horarioFechamento TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE pets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tutorId INTEGER,
        clinicaId INTEGER,
        criadoPor TEXT NOT NULL DEFAULT 'tutor',
        nome TEXT NOT NULL,
        especie TEXT NOT NULL,
        raca TEXT NOT NULL,
        sexo TEXT NOT NULL,
        idade INTEGER NOT NULL,
        peso REAL,
        fotoPath TEXT,
        codigo TEXT,
        FOREIGN KEY (tutorId) REFERENCES usuarios(id),
        FOREIGN KEY (clinicaId) REFERENCES usuarios(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE exames (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        petId INTEGER NOT NULL,
        titulo TEXT NOT NULL,
        data TEXT NOT NULL,
        descricao TEXT,
        arquivoPath TEXT,
        clinicaNome TEXT,
        FOREIGN KEY (petId) REFERENCES pets(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE alarmes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        petId INTEGER NOT NULL,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        data TEXT NOT NULL,
        clinicaNome TEXT,
        clinicaLogo TEXT,
        FOREIGN KEY (petId) REFERENCES pets(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE dietas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        petId INTEGER NOT NULL,
        clinicaId INTEGER,
        nome TEXT NOT NULL,
        marca TEXT NOT NULL,
        tipo TEXT NOT NULL,
        composicao TEXT,
        beneficios TEXT,
        recomendacoes TEXT,
        imagemPath TEXT,
        dataCriacao TEXT NOT NULL,
        clinicaNome TEXT,
        FOREIGN KEY (petId) REFERENCES pets(id),
        FOREIGN KEY (clinicaId) REFERENCES usuarios(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE agendamentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        petId INTEGER NOT NULL,
        clinicaId INTEGER,
        tipo TEXT NOT NULL,
        data TEXT NOT NULL,
        hora TEXT,
        observacao TEXT,
        status TEXT NOT NULL DEFAULT 'agendado',
        FOREIGN KEY (petId) REFERENCES pets(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE vacinacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        petId INTEGER NOT NULL,
        nome TEXT NOT NULL,
        data TEXT NOT NULL,
        proximaDose TEXT,
        clinicaNome TEXT,
        veterinario TEXT,
        FOREIGN KEY (petId) REFERENCES pets(id)
      )
    ''');
  }

  // ─── USUARIOS ──────────────────────────────────────────────────
  Future<Usuario?> login(String emailOuCnpj, String senha) async {
    final db = await database;
    final maps = await db.query(
      'usuarios',
      where: '(email = ? OR cnpj = ?) AND senha = ?',
      whereArgs: [emailOuCnpj, emailOuCnpj, senha],
    );
    if (maps.isEmpty) return null;
    return Usuario.fromMap(maps.first);
  }

  Future<int> insertUsuario(Usuario u) async {
    final db = await database;
    return db.insert('usuarios', u.toMap());
  }

  Future<Usuario?> getUsuarioById(int id) async {
    final db = await database;
    final maps = await db.query('usuarios', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Usuario.fromMap(maps.first);
  }

  Future<Usuario?> getUsuarioByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
    );
    if (maps.isEmpty) return null;
    return Usuario.fromMap(maps.first);
  }

  // ─── PETS ────────────────────────────────────────────────────
  Future<List<Pet>> getPetsByTutor(int tutorId) async {
    final db = await database;
    final maps = await db.query('pets', where: 'tutorId = ?', whereArgs: [tutorId]);
    return maps.map(Pet.fromMap).toList();
  }

  Future<List<Pet>> getPetsByClinica(int clinicaId) async {
    final db = await database;
    final maps = await db.query('pets', where: 'clinicaId = ? AND criadoPor = ?', whereArgs: [clinicaId, 'clinica']);
    return maps.map(Pet.fromMap).toList();
  }

  Future<List<Pet>> getPetsNaoVinculados(int clinicaId) async {
    final db = await database;
    final maps = await db.query('pets', where: 'clinicaId = ? AND criadoPor = ? AND tutorId IS NULL', whereArgs: [clinicaId, 'clinica']);
    return maps.map(Pet.fromMap).toList();
  }

  Future<List<Usuario>> getAllTutores() async {
    final db = await database;
    final maps = await db.query('usuarios', where: 'tipo = ?', whereArgs: ['tutor']);
    return maps.map(Usuario.fromMap).toList();
  }

  Future<int> vincularPetAoTutor(int petId, int tutorId) async {
    final db = await database;
    return db.update(
      'pets',
      {'tutorId': tutorId},
      where: 'id = ?',
      whereArgs: [petId],
    );
  }

  Future<int> desvincularPetDoTutor(int petId) async {
    final db = await database;
    return db.update(
      'pets',
      {'tutorId': null},
      where: 'id = ?',
      whereArgs: [petId],
    );
  }

  Future<int> insertPet(Pet pet) async {
    final db = await database;
    return db.insert('pets', pet.toMap());
  }

  Future<int> updatePet(Pet pet) async {
    final db = await database;
    return db.update('pets', pet.toMap(), where: 'id = ?', whereArgs: [pet.id]);
  }

  Future<int> deletePet(int id) async {
    final db = await database;
    return db.delete('pets', where: 'id = ?', whereArgs: [id]);
  }

  // ─── EXAMES ──────────────────────────────────────────────────
  Future<List<Exame>> getExamesByPet(int petId) async {
    final db = await database;
    final maps = await db.query('exames',
        where: 'petId = ?', whereArgs: [petId], orderBy: 'data ASC');
    return maps.map(Exame.fromMap).toList();
  }

  Future<int> insertExame(Exame e) async {
    final db = await database;
    return db.insert('exames', e.toMap());
  }

  Future<int> deleteExame(int id) async {
    final db = await database;
    return db.delete('exames', where: 'id = ?', whereArgs: [id]);
  }

  // ─── ALARMES ─────────────────────────────────────────────────
  Future<List<Alarme>> getAlarmesByPet(int petId) async {
    final db = await database;
    final maps = await db.query('alarmes',
        where: 'petId = ?', whereArgs: [petId], orderBy: 'data DESC');
    return maps.map(Alarme.fromMap).toList();
  }

  Future<int> insertAlarme(Alarme a) async {
    final db = await database;
    return db.insert('alarmes', a.toMap());
  }

  Future<int> deleteAlarme(int id) async {
    final db = await database;
    return db.delete('alarmes', where: 'id = ?', whereArgs: [id]);
  }

  // ─── DIETAS ──────────────────────────────────────────────────
  Future<List<Dieta>> getDietasByPet(int petId) async {
    final db = await database;
    final maps = await db.query('dietas', 
        where: 'petId = ?', 
        whereArgs: [petId],
        orderBy: 'dataCriacao DESC');
    return maps.map(Dieta.fromMap).toList();
  }

  Future<Dieta?> getUltimaDietaByPet(int petId) async {
    final db = await database;
    final maps = await db.query('dietas', 
        where: 'petId = ?', 
        whereArgs: [petId],
        orderBy: 'dataCriacao DESC',
        limit: 1);
    if (maps.isEmpty) return null;
    return Dieta.fromMap(maps.first);
  }

  Future<int> insertDieta(Dieta d) async {
    final db = await database;
    return db.insert('dietas', d.toMap());
  }

  Future<int> updateDieta(Dieta d) async {
    final db = await database;
    return db.update('dietas', d.toMap(), where: 'id = ?', whereArgs: [d.id]);
  }

  Future<int> deleteDieta(int id) async {
    final db = await database;
    return db.delete('dietas', where: 'id = ?', whereArgs: [id]);
  }

  // ─── AGENDAMENTOS ────────────────────────────────────────────
  Future<List<Agendamento>> getAgendamentosByPet(int petId) async {
    final db = await database;
    final maps = await db.query('agendamentos',
        where: 'petId = ?', whereArgs: [petId], orderBy: 'data ASC');
    return maps.map(Agendamento.fromMap).toList();
  }

  Future<List<Agendamento>> getAgendamentosByClinica(int clinicaId) async {
    final db = await database;
    final maps = await db.query('agendamentos',
        where: 'clinicaId = ?', whereArgs: [clinicaId], orderBy: 'data ASC');
    return maps.map(Agendamento.fromMap).toList();
  }

  Future<int> insertAgendamento(Agendamento a) async {
    final db = await database;
    return db.insert('agendamentos', a.toMap());
  }

  Future<int> deleteAgendamento(int id) async {
    final db = await database;
    return db.delete('agendamentos', where: 'id = ?', whereArgs: [id]);
  }

  // Vacinações
  Future<List<Vacinacao>> getVacinacoesByPet(int petId) async {
    final db = await database;
    final maps =
        await db.query('vacinacoes', where: 'petId = ?', whereArgs: [petId]);
    return maps.map(Vacinacao.fromMap).toList();
  }

  Future<int> insertVacinacao(Vacinacao v) async {
    final db = await database;
    return db.insert('vacinacoes', v.toMap());
  }

  Future<int> updateVacinacao(Vacinacao v) async {
    final db = await database;
    return db.update('vacinacoes', v.toMap(),
        where: 'id = ?', whereArgs: [v.id]);
  }

  Future<int> deleteVacinacao(int id) async {
    final db = await database;
    return db.delete('vacinacoes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Pet>> getAllPets() async {
    final db = await database;
    final maps = await db.query('pets');
    return maps.map(Pet.fromMap).toList();
  }
}
