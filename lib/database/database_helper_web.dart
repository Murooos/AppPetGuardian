import 'dart:convert';
import 'dart:html' as html;
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  final html.Storage _storage = html.window.sessionStorage;

  DatabaseHelper._init();

  static const _prefix = 'pet_guardian_';

  List<Map<String, dynamic>> _loadTable(String table) {
    final raw = _storage['$_prefix$table'];
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded.map<Map<String, dynamic>>((item) {
        return Map<String, dynamic>.from(item);
      }).toList();
    }
    return [];
  }

  void _saveTable(String table, List<Map<String, dynamic>> items) {
    _storage['$_prefix$table'] = jsonEncode(items);
  }

  int _nextId(String table) {
    final items = _loadTable(table);
    if (items.isEmpty) return 1;
    return items.map((item) => item['id'] as int? ?? 0).fold<int>(0, (prev, id) => id > prev ? id : prev) + 1;
  }

  Future<Usuario?> login(String emailOuCnpj, String senha) async {
    final usuarios = _loadTable('usuarios');
    final lowerQuery = emailOuCnpj.trim().toLowerCase();
    final found = usuarios.firstWhere(
      (map) => (map['email']?.toString().toLowerCase() == lowerQuery || map['cnpj']?.toString() == emailOuCnpj.trim()) && map['senha'] == senha,
      orElse: () => {},
    );
    if (found.isEmpty) return null;
    return Usuario.fromMap(found);
  }

  Future<int> insertUsuario(Usuario u) async {
    final usuarios = _loadTable('usuarios');
    final newId = _nextId('usuarios');
    final novoMapa = {...u.toMap(), 'id': newId};
    usuarios.add(novoMapa);
    _saveTable('usuarios', usuarios);
    return newId;
  }

  Future<Usuario?> getUsuarioById(int id) async {
    final usuarios = _loadTable('usuarios');
    final found = usuarios.firstWhere((map) => map['id'] == id, orElse: () => {});
    if (found.isEmpty) return null;
    return Usuario.fromMap(found);
  }

  Future<Usuario?> getUsuarioByEmail(String email) async {
    final usuarios = _loadTable('usuarios');
    final lowerEmail = email.trim().toLowerCase();
    final found = usuarios.firstWhere(
      (map) => map['email']?.toString().toLowerCase() == lowerEmail,
      orElse: () => {},
    );
    if (found.isEmpty) return null;
    return Usuario.fromMap(found);
  }

  Future<List<Pet>> getPetsByTutor(int tutorId) async {
    final pets = _loadTable('pets');
    return pets.where((map) => map['tutorId'] == tutorId).map(Pet.fromMap).toList();
  }

  Future<List<Pet>> getPetsByClinica(int clinicaId) async {
    final pets = _loadTable('pets');
    return pets
        .where((map) => map['clinicaId'] == clinicaId && map['criadoPor'] == 'clinica')
        .map(Pet.fromMap)
        .toList();
  }

  Future<List<Pet>> getPetsNaoVinculados(int clinicaId) async {
    final pets = _loadTable('pets');
    return pets
        .where((map) => map['clinicaId'] == clinicaId && map['criadoPor'] == 'clinica' && map['tutorId'] == null)
        .map(Pet.fromMap)
        .toList();
  }

  Future<List<Usuario>> getAllTutores() async {
    final usuarios = _loadTable('usuarios');
    return usuarios.where((map) => map['tipo'] == 'tutor').map(Usuario.fromMap).toList();
  }

  Future<int> vincularPetAoTutor(int petId, int tutorId) async {
    final pets = _loadTable('pets');
    final index = pets.indexWhere((map) => map['id'] == petId);
    if (index == -1) return 0;
    pets[index] = {...pets[index], 'tutorId': tutorId};
    _saveTable('pets', pets);
    return 1;
  }

  Future<int> desvincularPetDoTutor(int petId) async {
    final pets = _loadTable('pets');
    final index = pets.indexWhere((map) => map['id'] == petId);
    if (index == -1) return 0;
    pets[index] = {...pets[index], 'tutorId': null};
    _saveTable('pets', pets);
    return 1;
  }

  Future<int> insertPet(Pet pet) async {
    final pets = _loadTable('pets');
    final newId = _nextId('pets');
    final novoMapa = {...pet.toMap(), 'id': newId};
    pets.add(novoMapa);
    _saveTable('pets', pets);
    return newId;
  }

  Future<int> updatePet(Pet pet) async {
    final pets = _loadTable('pets');
    final index = pets.indexWhere((map) => map['id'] == pet.id);
    if (index == -1) return 0;
    pets[index] = pet.toMap();
    _saveTable('pets', pets);
    return 1;
  }

  Future<int> deletePet(int id) async {
    final pets = _loadTable('pets');
    pets.removeWhere((map) => map['id'] == id);
    _saveTable('pets', pets);
    return 1;
  }

  Future<List<Exame>> getExamesByPet(int petId) async {
    final exames = _loadTable('exames');
    return exames.where((map) => map['petId'] == petId).map(Exame.fromMap).toList();
  }

  Future<int> insertExame(Exame e) async {
    final exames = _loadTable('exames');
    final newId = _nextId('exames');
    exames.add({...e.toMap(), 'id': newId});
    _saveTable('exames', exames);
    return newId;
  }

  Future<int> deleteExame(int id) async {
    final exames = _loadTable('exames');
    exames.removeWhere((map) => map['id'] == id);
    _saveTable('exames', exames);
    return 1;
  }

  Future<List<Alarme>> getAlarmesByPet(int petId) async {
    final alarmes = _loadTable('alarmes');
    return alarmes.where((map) => map['petId'] == petId).map(Alarme.fromMap).toList();
  }

  Future<int> insertAlarme(Alarme a) async {
    final alarmes = _loadTable('alarmes');
    final newId = _nextId('alarmes');
    alarmes.add({...a.toMap(), 'id': newId});
    _saveTable('alarmes', alarmes);
    return newId;
  }

  Future<int> deleteAlarme(int id) async {
    final alarmes = _loadTable('alarmes');
    alarmes.removeWhere((map) => map['id'] == id);
    _saveTable('alarmes', alarmes);
    return 1;
  }

  Future<List<Dieta>> getDietasByPet(int petId) async {
    final dietas = _loadTable('dietas');
    final filtered = dietas.where((map) => map['petId'] == petId).toList();
    filtered.sort((a, b) => b['dataCriacao'].toString().compareTo(a['dataCriacao'].toString()));
    return filtered.map(Dieta.fromMap).toList();
  }

  Future<Dieta?> getUltimaDietaByPet(int petId) async {
    final dietas = await getDietasByPet(petId);
    return dietas.isEmpty ? null : dietas.first;
  }

  Future<int> insertDieta(Dieta d) async {
    final dietas = _loadTable('dietas');
    final newId = _nextId('dietas');
    dietas.add({...d.toMap(), 'id': newId});
    _saveTable('dietas', dietas);
    return newId;
  }

  Future<int> updateDieta(Dieta d) async {
    final dietas = _loadTable('dietas');
    final index = dietas.indexWhere((map) => map['id'] == d.id);
    if (index == -1) return 0;
    dietas[index] = d.toMap();
    _saveTable('dietas', dietas);
    return 1;
  }

  Future<int> deleteDieta(int id) async {
    final dietas = _loadTable('dietas');
    dietas.removeWhere((map) => map['id'] == id);
    _saveTable('dietas', dietas);
    return 1;
  }

  Future<List<Agendamento>> getAgendamentosByPet(int petId) async {
    final agendamentos = _loadTable('agendamentos');
    return agendamentos.where((map) => map['petId'] == petId).map(Agendamento.fromMap).toList();
  }

  Future<List<Agendamento>> getAgendamentosByClinica(int clinicaId) async {
    final agendamentos = _loadTable('agendamentos');
    return agendamentos.where((map) => map['clinicaId'] == clinicaId).map(Agendamento.fromMap).toList();
  }

  Future<int> insertAgendamento(Agendamento a) async {
    final agendamentos = _loadTable('agendamentos');
    final newId = _nextId('agendamentos');
    agendamentos.add({...a.toMap(), 'id': newId});
    _saveTable('agendamentos', agendamentos);
    return newId;
  }

  Future<int> deleteAgendamento(int id) async {
    final agendamentos = _loadTable('agendamentos');
    agendamentos.removeWhere((map) => map['id'] == id);
    _saveTable('agendamentos', agendamentos);
    return 1;
  }

  Future<List<Vacinacao>> getVacinacoesByPet(int petId) async {
    final vacinacoes = _loadTable('vacinacoes');
    return vacinacoes.where((map) => map['petId'] == petId).map(Vacinacao.fromMap).toList();
  }

  Future<int> insertVacinacao(Vacinacao v) async {
    final vacinacoes = _loadTable('vacinacoes');
    final newId = _nextId('vacinacoes');
    vacinacoes.add({...v.toMap(), 'id': newId});
    _saveTable('vacinacoes', vacinacoes);
    return newId;
  }

  Future<int> updateVacinacao(Vacinacao v) async {
    final vacinacoes = _loadTable('vacinacoes');
    final index = vacinacoes.indexWhere((map) => map['id'] == v.id);
    if (index == -1) return 0;
    vacinacoes[index] = v.toMap();
    _saveTable('vacinacoes', vacinacoes);
    return 1;
  }

  Future<int> deleteVacinacao(int id) async {
    final vacinacoes = _loadTable('vacinacoes');
    vacinacoes.removeWhere((map) => map['id'] == id);
    _saveTable('vacinacoes', vacinacoes);
    return 1;
  }

  Future<List<Pet>> getAllPets() async {
    final pets = _loadTable('pets');
    return pets.map(Pet.fromMap).toList();
  }
}
