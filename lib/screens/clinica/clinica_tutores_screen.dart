import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../database/database_helper.dart';

class ClinicaTutoresScreen extends StatefulWidget {
  final Usuario usuario;
  const ClinicaTutoresScreen({super.key, required this.usuario});

  @override
  State<ClinicaTutoresScreen> createState() => _ClinicaTutoresScreenState();
}

class _ClinicaTutoresScreenState extends State<ClinicaTutoresScreen> {
  List<Usuario> _tutores = [];
  List<Usuario> _tutoresFiltrados = [];
  Map<int, List<Pet>> _tutoresPets = {};
  bool _carregando = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTutores();
    _searchController.addListener(_filtrarTutores);
  }

  Future<void> _loadTutores() async {
    setState(() => _carregando = true);
    try {
      final tutores = await DatabaseHelper.instance.getAllTutores();
      
      // Carregar pets de cada tutor
      Map<int, List<Pet>> petsMap = {};
      for (final tutor in tutores) {
        if (tutor.id != null) {
          final pets = await DatabaseHelper.instance.getPetsByTutor(tutor.id!);
          petsMap[tutor.id!] = pets;
        }
      }

      setState(() {
        _tutores = tutores;
        _tutoresFiltrados = tutores;
        _tutoresPets = petsMap;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar tutores: $e')),
        );
      }
    }
  }

  void _filtrarTutores() {
    final termo = _searchController.text.toLowerCase();
    
    List<Usuario> resultado = _tutores.where((t) =>
        t.nome.toLowerCase().contains(termo) ||
        t.email.toLowerCase().contains(termo) ||
        (t.telefone?.contains(termo) ?? false)).toList();

    setState(() => _tutoresFiltrados = resultado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        title: const Text('Tutores'),
        elevation: 0,
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Barra de busca
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar tutor por nome, email ou telefone...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.orange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.orange, width: 2),
                      ),
                    ),
                  ),
                ),

                // Lista de tutores
                Expanded(
                  child: _tutoresFiltrados.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum tutor encontrado',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _tutoresFiltrados.length,
                          itemBuilder: (context, index) {
                            final tutor = _tutoresFiltrados[index];
                            final pets = _tutoresPets[tutor.id] ?? [];
                            return _buildTutorCard(tutor, pets);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildTutorCard(Usuario tutor, List<Pet> pets) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(
              Icons.person_outline,
              color: AppColors.blue,
              size: 28,
            ),
          ),
        ),
        title: Text(
          tutor.nome,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              tutor.email,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            if (tutor.telefone != null) ...[
              const SizedBox(height: 4),
              Text(
                tutor.telefone!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${pets.length} paciente${pets.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.blue),
          onPressed: () => _abrirDetalhesTutor(tutor, pets),
        ),
        onTap: () => _abrirDetalhesTutor(tutor, pets),
      ),
    );
  }

  void _abrirDetalhesTutor(Usuario tutor, List<Pet> pets) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildDetalhesBottomSheet(tutor, pets),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildDetalhesBottomSheet(Usuario tutor, List<Pet> pets) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: AppColors.blue,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tutor.nome,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tutor.email,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Informações de Contato
                    _buildSecao('Informações de Contato', [
                      ('Email', tutor.email),
                      if (tutor.telefone != null) ('Telefone', tutor.telefone!),
                      if (tutor.endereco != null) ('Endereço', tutor.endereco!),
                      if (tutor.cidade != null)
                        ('Localização', '${tutor.cidade}, ${tutor.estado}'),
                      if (tutor.cep != null) ('CEP', tutor.cep!),
                    ]),
                    const SizedBox(height: 20),

                    // Pacientes
                    Text(
                      'Pacientes (${pets.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (pets.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: Text(
                          'Nenhum paciente registrado',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: List.generate(
                          pets.length,
                          (index) => _buildPetItemCompacto(pets[index]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecao(String titulo, List<(String, String)> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: List.generate(
              items.length,
              (index) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          items[index].$1,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            items[index].$2,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < items.length - 1)
                    Divider(height: 1, color: Colors.grey[200]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPetItemCompacto(Pet pet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                _getIconePet(pet.especie),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.nome,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  pet.raca,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${pet.idade}a',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getIconePet(String especie) {
    switch (especie.toLowerCase()) {
      case 'cão':
        return '🐕';
      case 'gato':
        return '🐈';
      case 'coelho':
        return '🐰';
      case 'pássaro':
        return '🐦';
      default:
        return '🐾';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
