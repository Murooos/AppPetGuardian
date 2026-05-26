import '../../widgets/platform_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../widgets/centered_container.dart';
import '../../database/database_helper.dart';
import '../welcome_screen.dart';
import '../configuracoes_screen.dart';
import 'agenda_screen.dart';
import 'clinica_cadastro_pet_screen.dart';
import 'clinica_cadastro_tutor_screen.dart';
import 'clinica_pacientes_screen.dart';
import 'clinica_cadastro_dieta_screen.dart';
import 'clinica_tutores_screen.dart';

class ClinicaHomeScreen extends StatefulWidget {
  final Usuario usuario;
  const ClinicaHomeScreen({super.key, required this.usuario});

  @override
  State<ClinicaHomeScreen> createState() => _ClinicaHomeScreenState();
}

class _ClinicaHomeScreenState extends State<ClinicaHomeScreen> {
  List<Pet> _pets = [];
  List<Agendamento> _agendamentosDoMes = [];
  int _totalTutores = 0;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _loadClinicaData();
  }

  // Retorna o nome do mês atual formatado em pt_BR (ex: "Maio")
  String _getNomeMesAtual() {
    return DateFormat('MMMM', 'pt_BR').format(DateTime.now());
  }

  Future<void> _loadClinicaData() async {
    setState(() => _carregando = true);
    try {
      final pets = await DatabaseHelper.instance.getPetsByClinica(widget.usuario.id!);
      final agendamentos = await DatabaseHelper.instance.getAgendamentosByClinica(widget.usuario.id!);

      agendamentos.sort((a, b) => a.data.compareTo(b.data));
      final agora = DateTime.now();
      final agendamentosFiltrados = agendamentos.where((a) {
        final dataAg = DateTime.tryParse(a.data);
        if (dataAg == null) return false;
        return dataAg.year == agora.year && dataAg.month == agora.month;
      }).toList();

      final tutores = <int>{};
      for (final pet in pets) {
        if (pet.tutorId != null) tutores.add(pet.tutorId!);
      }

      setState(() {
        _pets = pets;
        _agendamentosDoMes = agendamentosFiltrados;
        _totalTutores = tutores.length;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: SafeArea(
        child: CenteredContainer(
            child: Column(
            children: [
            // Cabeçalho
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo, ${widget.usuario.nome}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Clínica Veterinária',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Conteúdo Principal
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: _carregando
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.orange),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cartões Estatísticos
                            _buildStatisticsRow(),
                            const SizedBox(height: 24),

                            // Botões de Ações Rápidas
                            _buildQuickActionsRow(),
                            const SizedBox(height: 24),

                            // Nova Seção: Agenda Mensal Completa
                            _buildMonthlyAppointmentsSection(),
                            const SizedBox(height: 24),

                              // Nova Seção: Todos os Pacientes Cadastrados
                              _buildPatientsListSection(),
                          ],
                        ),
                      ),
              ),
            ),

            // Barra de Navegação Inferior
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.orange),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.orange),
                    onPressed: () => _showAddMenu(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: AppColors.orange),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfiguracoesScreen(
                          primaryColor: AppColors.orange,
                          usuario: widget.usuario,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.pets,
            label: 'Pacientes',
            value: _pets.length.toString(),
            color: AppColors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.people,
            label: 'Tutores',
            value: _totalTutores.toString(),
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.calendar_today,
            label: 'No Mês',
            value: _agendamentosDoMes.length.toString(),
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ações Rápidas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                icon: Icons.calendar_month,
                label: 'Agenda',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AgendaScreen(clinica: widget.usuario)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                icon: Icons.pets,
                label: 'Pacientes',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClinicaPacientesScreen(usuario: widget.usuario),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                icon: Icons.person,
                label: 'Tutores',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClinicaTutoresScreen(usuario: widget.usuario),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.orange, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.orange, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.orange,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyAppointmentsSection() {
    // Captura e capitaliza o nome do mês atual para o título da seção
    final nomeMes = _getNomeMesAtual();
    final mesCapitalizado = nomeMes.isNotEmpty 
        ? '${nomeMes[0].toUpperCase()}${nomeMes.substring(1)}' 
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agenda de $mesCapitalizado',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        if (_agendamentosDoMes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Nenhuma consulta marcada para este mês.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          )
        else
          Column(
            children: _agendamentosDoMes.map((agendamento) {
              return _appointmentCard(agendamento);
            }).toList(),
          ),
      ],
    );
  }

  Widget _appointmentCard(Agendamento agendamento) {
    // Tratamento seguro de parsing de data para evitar quebras de runtime
    final dataParseada = DateTime.tryParse(agendamento.data);
    final dia = dataParseada != null ? dataParseada.day.toString().padLeft(2, '0') : '00';
    
    final mesesAbreviados = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Maio', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    final mesStr = dataParseada != null ? mesesAbreviados[dataParseada.month - 1] : '---';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dia,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                  ),
                  Text(
                    mesStr,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agendamento.tipo.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Status: ${agendamento.status}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título dinâmico informando a quantidade total de pacientes visíveis
        Text(
          'Pacientes (${_pets.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        if (_pets.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Nenhum paciente cadastrado',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          )
        else
          // Modificado: mapeia a lista inteira de pets ao invés de limitar com .take(5)
          Column(
            children: _pets.map((pet) {
              return _petCard(pet);
            }).toList(),
          ),
      ],
    );
  }

  Widget _petCard(Pet pet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(color: AppColors.orange, width: 2),
            ),
            child: ClipOval(
              child: PlatformImage(path: pet.fotoPath, width: 44, height: 44, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.nome.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${pet.raca} • ${pet.sexo}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ClinicaPacientesScreen(
                    usuario: widget.usuario,
                    pet: pet,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ações do Tutor',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.restaurant, color: AppColors.orange),
              title: const Text('Nova Dieta'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClinicaCadastroDietaScreen(usuario: widget.usuario),
                  ),
                );
                if (mounted) {
                  await _loadClinicaData();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.pets, color: AppColors.orange),
              title: const Text('Novo Pet'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClinicaCadastroPetScreen(
                      clinica: widget.usuario,
                    ),
                  ),
                );
                if (mounted) {
                  await _loadClinicaData();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: AppColors.orange),
              title: const Text('Novo Tutor'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClinicaCadastroTutorScreen(
                      clinica: widget.usuario,
                    ),
                  ),
                );
                if (mounted) {
                  await _loadClinicaData();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}