import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../database/database_helper.dart';
import 'clinica_cadastro_dieta_screen.dart';
import 'exames_clinica_screen.dart';

class ClinicaPacientesScreen extends StatefulWidget {
  final Usuario usuario;
  final Pet? pet;
  const ClinicaPacientesScreen({super.key, required this.usuario, this.pet});

  @override
  State<ClinicaPacientesScreen> createState() => _ClinicaPacientesScreenState();
}

class _ClinicaPacientesScreenState extends State<ClinicaPacientesScreen> {
  List<Pet> _pets = [];
  List<Pet> _petsFiltrados = [];
  bool _carregando = true;
  String _filtro = 'todos';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPets();
    _searchController.addListener(_filtrarPets);
  }

  Future<void> _loadPets() async {
    setState(() => _carregando = true);
    try {
      final pets = await DatabaseHelper.instance.getPetsByClinica(widget.usuario.id!);
      setState(() {
        _pets = pets;
        _petsFiltrados = pets;
        _carregando = false;
      });
      if (widget.pet != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _abrirDetalhesPet(widget.pet!);
        });
      }
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar pacientes: $e')),
        );
      }
    }
  }

  void _filtrarPets() {
    final termo = _searchController.text.toLowerCase();
    List<Pet> resultado = _pets;

    // Filtro por tipo
    if (_filtro != 'todos') {
      resultado = resultado.where((p) => p.especie.toLowerCase() == _filtro).toList();
    }

    // Filtro por busca
    if (termo.isNotEmpty) {
      resultado = resultado.where((p) =>
          p.nome.toLowerCase().contains(termo) ||
          p.raca.toLowerCase().contains(termo)).toList();
    }

    setState(() => _petsFiltrados = resultado);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filtrarPets);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        title: const Text('Pacientes'),
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
                      hintText: 'Buscar paciente ou raça...',
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

                // Filtros
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildFilterChip('Todos', 'todos'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Cão', 'cão'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Gato', 'gato'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Outros', 'outros'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Lista de pacientes
                Expanded(
                  child: _petsFiltrados.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.pets,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum paciente encontrado',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _petsFiltrados.length,
                          itemBuilder: (context, index) {
                            final pet = _petsFiltrados[index];
                            return _buildPetCard(pet);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _filtro == value,
      onSelected: (selected) {
        setState(() => _filtro = value);
        _filtrarPets();
      },
      selectedColor: AppColors.orange,
      labelStyle: TextStyle(
        color: _filtro == value ? Colors.white : Colors.black,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: _filtro == value ? AppColors.orange : Colors.grey[300]!,
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    String icone = _getIconePet(pet.especie);
    
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
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              icone,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        title: Text(
          pet.nome,
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
              '${pet.raca} • ${pet.sexo}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${pet.idade} ano${pet.idade > 1 ? 's' : ''}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.orange),
          onPressed: () => _abrirDetalhesPet(pet),
        ),
        onTap: () => _abrirDetalhesPet(pet),
      ),
    );
  }

  void _abrirDetalhesPet(Pet pet) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildDetalhesBottomSheet(pet),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildDetalhesBottomSheet(Pet pet) {
    return FractionallySizedBox(
      heightFactor: 0.6,
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
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              _getIconePet(pet.especie),
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pet.nome,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pet.raca,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Informações
                    _buildInfoSection('Informações Gerais', [
                      ('Espécie', pet.especie),
                      ('Sexo', pet.sexo),
                      ('Idade', '${pet.idade} ano${pet.idade > 1 ? 's' : ''}'),
                      ('Código', pet.codigo ?? 'N/A'),
                    ]),
                    const SizedBox(height: 16),

                    // Botões de ação
                        Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                                onPressed: () => _abrirTelaVisualizarDieta(pet),
                            icon: const Icon(Icons.restaurant),
                            label: const Text('Ver Dieta'),
                            style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.orange,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                            const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                                onPressed: () => _abrirTelaCadastrarDieta(pet),
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Cadastrar Dieta'),
                            style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                            const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                                onPressed: () => _abrirTelaExames(pet),
                            icon: const Icon(Icons.monitor_heart),
                            label: const Text('Exames'),
                            style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildInfoSection(String titulo, List<(String, String)> items) {
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
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          items[index].$2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
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

  void _abrirTelaVisualizarDieta(Pet pet) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildDietaSheet(pet),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void _abrirTelaCadastrarDieta(Pet pet) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClinicaCadastroDietaScreen(
          usuario: widget.usuario,
          pet: pet,
        ),
      ),
    );
  }

  void _abrirTelaExames(Pet pet) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamesClinicaScreen(
          pet: pet,
          clinica: widget.usuario,
        ),
      ),
    );
  }

  Widget _buildDietaSheet(Pet pet) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dieta de ${pet.nome}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Dieta>>(
                future: DatabaseHelper.instance.getDietasByPet(pet.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma dieta cadastrada',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final dietas = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: dietas.length,
                    itemBuilder: (context, index) {
                      final dieta = dietas[index];
                      return _buildDietaCard(dieta);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietaCard(Dieta dieta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.restaurant, color: AppColors.orange),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dieta.nome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dieta.marca,
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
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDietaInfo('Tipo', dieta.tipo),
                  if (dieta.composicao != null) ...[
                    const SizedBox(height: 8),
                    _buildDietaInfo('Composição', dieta.composicao!),
                  ],
                  if (dieta.beneficios != null) ...[
                    const SizedBox(height: 8),
                    _buildDietaInfo('Benefícios', dieta.beneficios!),
                  ],
                  if (dieta.recomendacoes != null) ...[
                    const SizedBox(height: 8),
                    _buildDietaInfo('Recomendações', dieta.recomendacoes!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (dieta.clinicaNome != null)
                  Expanded(
                    child: Text(
                      'Por: ${dieta.clinicaNome}',
                      style: TextStyle(
                        color: AppColors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.parse(dieta.dataCriacao)),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietaInfo(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.orange,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
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
}
