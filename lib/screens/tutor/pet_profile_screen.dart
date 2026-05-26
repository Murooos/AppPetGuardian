import '../../widgets/platform_image.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../database/database_helper.dart';
import '../welcome_screen.dart';
import 'exames_screen.dart';
import 'alarmes_screen.dart';
import 'carteirinha_vacinacao_screen.dart';
import '../configuracoes_screen.dart';

class PetProfileScreen extends StatefulWidget {
  final Usuario usuario;
  final Pet pet;

  const PetProfileScreen({super.key, required this.usuario, required this.pet});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  Dieta? _dieta;
  List<Agendamento> _agendamentos = [];
  bool _mostrarCodigo = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dieta = await DatabaseHelper.instance.getDietasByPet(widget.pet.id!);
    final ag = await DatabaseHelper.instance.getAgendamentosByPet(widget.pet.id!);
    setState(() {
      _dieta = dieta as Dieta?;
      _agendamentos = ag;
    });
  }

  String _getProximosEventos() {
    final proximos = _agendamentos
        .where((a) => a.status == 'agendado')
        .map((a) => a.tipo[0].toUpperCase() + a.tipo.substring(1))
        .take(3)
        .toList();
    return proximos.join('\n');
  }

  String _getProximasDatas() {
    final proximos = _agendamentos
        .where((a) => a.status == 'agendado')
        .take(3)
        .toList();
    if (proximos.isEmpty) return '';
    final mes = _getMesAbrev(proximos.first.data);
    final dias = proximos.map((a) => a.data.split('-').last).join(', ');
    return '$mes\n$dias';
  }

  String _getMesAbrev(String data) {
    final meses = ['Jan','Fev','Mar','Abr','Maio','Jun','Jul','Ago','Set','Out','Nov','Dez'];
    final partes = data.split('-');
    if (partes.length < 2) return '';
    final mesNum = int.tryParse(partes[1]) ?? 1;
    return meses[mesNum - 1];
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    return Scaffold(
      backgroundColor: AppColors.teal,
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho pet
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  // Foto
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      color: Colors.grey[300],
                    ),
                    child: ClipOval(
                      child: PlatformImage(path: pet.fotoPath, width: 90, height: 90, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.nome.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '${pet.raca} – ${pet.sexo} – ${pet.idade} Anos',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              _mostrarCodigo
                                  ? (pet.codigo ?? 'PG-2024-001')
                                  : '●●●●●●●●●●',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() => _mostrarCodigo = !_mostrarCodigo),
                              child: Icon(
                                _mostrarCodigo ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Conteúdo scrollável
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Agenda Pet
                      _sectionCard(
                        icon: Icons.calendar_today,
                        title: 'Agenda Pet',
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Próximos eventos:',
                                      style: TextStyle(fontSize: 12, color: AppColors.textMedium)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getProximosEventos().isEmpty
                                        ? 'Nenhum evento'
                                        : _getProximosEventos(),
                                    style: const TextStyle(fontSize: 13, height: 1.6),
                                  ),
                                ],
                              ),
                            ),
                            if (_agendamentos.isNotEmpty)
                              Container(
                                width: 1,
                                height: 60,
                                color: Colors.grey[300],
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            if (_agendamentos.isNotEmpty)
                              Text(
                                _getProximasDatas(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Dieta
                      _sectionCard(
                        icon: Icons.restaurant,
                        title: 'Dieta',
                        child: _dieta == null
                            ? const Text('Nenhuma dieta cadastrada',
                                style: TextStyle(color: Colors.grey))
                            : Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.inventory_2,
                                        color: Colors.grey, size: 28),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _dieta!.nome,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600, fontSize: 13),
                                        ),
                                        if (_dieta!.marca.isNotEmpty)
                                          Text(
                                            _dieta!.marca,
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        if (_dieta!.beneficios != null)
                                          ...(_dieta!.beneficios!.split('\n').map(
                                                (b) => Text('- $b',
                                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                              )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 12),

                      // Histórico
                      _sectionCard(
                        icon: Icons.history,
                        title: 'Histórico',
                        child: Column(
                          children: List.generate(
                            3,
                            (_) => Container(
                              height: 10,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botões de ação
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _actionBtn('Exames', () => _goExames()),
                          _actionBtn('Carteirinha', () => _goCarteirinha()),
                          _actionBtn('Alarme Vet', () => _goAlarmes()),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom nav
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.teal),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: AppColors.teal),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfiguracoesScreen(
                          primaryColor: AppColors.teal,
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
    );
  }

  Widget _sectionCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.teal,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  void _goExames() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamesScreen(pet: widget.pet, usuario: widget.usuario),
      ),
    );
  }

  void _goAlarmes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlarmesScreen(pet: widget.pet, usuario: widget.usuario),
      ),
    );
  }

  void _goCarteirinha() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CarteirinhaVacinacaoScreen(pet: widget.pet),
      ),
    );
  }
}
