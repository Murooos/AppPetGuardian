import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../database/database_helper.dart';
import '../configuracoes_screen.dart';

class AgendaScreen extends StatefulWidget {
  final Usuario clinica;
  const AgendaScreen({super.key, required this.clinica});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _carregando = true;
  List<Pet> _pets = [];
  Pet? _selectedPet;
  List<Agendamento> _agendamentos = [];
  Map<DateTime, List<Agendamento>> _eventMap = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _load();
  }

  Future<void> _load() async {
    setState(() => _carregando = true);
    try {
      final pets = await DatabaseHelper.instance.getPetsByClinica(widget.clinica.id!);
      final agendamentos = await DatabaseHelper.instance.getAgendamentosByClinica(widget.clinica.id!);
      setState(() {
        _pets = pets;
        _selectedPet = pets.isNotEmpty ? pets.first : null;
        _agendamentos = agendamentos;
        _eventMap = _buildEventMap(_filteredAgendamentos(agendamentos, pets.isNotEmpty ? pets.first : null));
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
    }
  }

  Map<DateTime, List<Agendamento>> _buildEventMap(List<Agendamento> events) {
    final map = <DateTime, List<Agendamento>>{};
    for (final agendamento in events) {
      final data = DateTime.tryParse(agendamento.data);
      if (data == null) continue;
      final key = DateTime(data.year, data.month, data.day);
      map[key] = [...(map[key] ?? []), agendamento];
    }
    return map;
  }

  List<Agendamento> _filteredAgendamentos([List<Agendamento>? source, Pet? pet]) {
    final list = source ?? _agendamentos;
    if (_selectedPet != null) {
      return list.where((a) => a.petId == _selectedPet!.id).toList();
    }
    return list;
  }

  List<Agendamento> _getEventos(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _eventMap[key] ?? [];
  }

  IconData _getTipoIcon(String tipo) {
    switch (tipo) {
      case 'consulta':
        return Icons.star;
      case 'vacina':
        return Icons.pets;
      case 'exame':
        return Icons.shield;
      default:
        return Icons.event;
    }
  }

  Color _getTipoCor(String tipo) {
    switch (tipo) {
      case 'consulta':
        return Colors.blue;
      case 'vacina':
        return AppColors.teal;
      case 'exame':
        return AppColors.orange;
      default:
        return Colors.grey;
    }
  }

  Future<void> _adicionarAgendamento() async {
    if (_pets.isEmpty) return;

    Pet? currentPet = _selectedPet ?? _pets.first;
    String tipoSelecionado = 'consulta';
    DateTime selectedDate = _selectedDay ?? _focusedDay;
    TimeOfDay? selectedTime;
    final observacaoCtrl = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Novo Agendamento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('Paciente:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<Pet>(
                  value: currentPet,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: _pets
                      .map((pet) => DropdownMenuItem(
                            value: pet,
                            child: Text(pet.nome),
                          ))
                      .toList(),
                  onChanged: (pet) => setModalState(() => currentPet = pet),
                ),
                const SizedBox(height: 16),
                const Text('Tipo:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: ['consulta', 'vacina', 'exame'].map((tipo) {
                    final selected = tipoSelecionado == tipo;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setModalState(() => tipoSelecionado = tipo),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.orange : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tipo[0].toUpperCase() + tipo.substring(1),
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: ctx,
                            initialDate: selectedDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setModalState(() => selectedDate = date);
                          }
                        },
                        child: Text('Data: ${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: ctx,
                            initialTime: selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
                          );
                          if (time != null) {
                            setModalState(() => selectedTime = time);
                          }
                        },
                        child: Text(selectedTime != null
                            ? 'Hora: ${selectedTime!.format(context)}'
                            : 'Selecionar hora'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: observacaoCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Observações',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (currentPet == null) return;
                      final hora = selectedTime != null ? selectedTime!.format(context) : null;
                      final dataString = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                      await DatabaseHelper.instance.insertAgendamento(
                        Agendamento(
                          petId: currentPet!.id!,
                          clinicaId: widget.clinica.id,
                          tipo: tipoSelecionado,
                          data: dataString,
                          hora: hora,
                          observacao: observacaoCtrl.text.trim().isEmpty ? null : observacaoCtrl.text.trim(),
                        ),
                      );
                      if (ctx.mounted) Navigator.pop(ctx);
                      _load();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Salvar agendamento', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        widget.clinica.nome.isNotEmpty ? widget.clinica.nome[0] : '?',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Agenda da Clínica',
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text(
                          widget.clinica.nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _selectedPet != null ? 'Paciente: ${_selectedPet!.nome}' : 'Selecione um paciente para filtrar',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: _carregando
                    ? const Center(child: CircularProgressIndicator(color: AppColors.orange))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_pets.isNotEmpty) ...[
                              const Text(
                                'Filtrar por paciente',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<Pet>(
                                value: _selectedPet,
                                decoration: const InputDecoration(border: OutlineInputBorder()),
                                items: _pets
                                    .map((pet) => DropdownMenuItem(
                                          value: pet,
                                          child: Text(pet.nome),
                                        ))
                                    .toList(),
                                onChanged: (pet) {
                                  setState(() {
                                    _selectedPet = pet;
                                    _eventMap = _buildEventMap(_filteredAgendamentos());
                                  });
                                },
                              ),
                              const SizedBox(height: 18),
                            ],

                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: AppColors.greyBg,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: AppColors.orange),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Calendário mensal de agendamentos',
                                      style: TextStyle(
                                        color: AppColors.textDark.withOpacity(0.85),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
                                    style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            TableCalendar(
                              firstDay: DateTime.utc(2024, 1, 1),
                              lastDay: DateTime.utc(2026, 12, 31),
                              focusedDay: _focusedDay,
                              selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
                              eventLoader: _getEventos,
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                              },
                              onPageChanged: (focusedDay) {
                                setState(() => _focusedDay = focusedDay);
                              },
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.orange, width: 2),
                                ),
                                todayTextStyle: const TextStyle(color: AppColors.textDark),
                                selectedDecoration: const BoxDecoration(
                                  color: AppColors.orange,
                                  shape: BoxShape.circle,
                                ),
                                markerDecoration: const BoxDecoration(
                                  color: AppColors.teal,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              calendarBuilders: CalendarBuilders(
                                markerBuilder: (ctx, day, events) {
                                  if (events.isEmpty) return const SizedBox();
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: events.cast<Agendamento>().map((event) {
                                      return Icon(
                                        _getTipoIcon(event.tipo),
                                        size: 8,
                                        color: _getTipoCor(event.tipo),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Compromissos do dia',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            ..._buildEventList(),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _adicionarAgendamento,
                                icon: const Icon(Icons.add),
                                label: const Text('Novo agendamento', style: TextStyle(fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.orange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.orange),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Icon(Icons.pets, color: AppColors.orange, size: 26),
                  IconButton(
                    icon: const Icon(Icons.settings, color: AppColors.orange),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfiguracoesScreen(
                          primaryColor: AppColors.orange,
                          usuario: widget.clinica,
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

  List<Widget> _buildEventList() {
    final events = _getEventos(_selectedDay ?? _focusedDay);
    if (events.isEmpty) {
      return [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'Nenhum compromisso para este dia.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ];
    }
    return events.map((event) => _appointmentCard(event)).toList();
  }

  Widget _appointmentCard(Agendamento agendamento) {
    final dataParseada = DateTime.tryParse(agendamento.data);
    final dia = dataParseada != null ? dataParseada.day.toString().padLeft(2, '0') : '??';
    final mesesAbreviados = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    final mesStr = dataParseada != null ? mesesAbreviados[dataParseada.month - 1] : '---';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dia,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                  ),
                  Text(
                    mesStr,
                    style: const TextStyle(fontSize: 10, color: AppColors.orange),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_getTipoIcon(agendamento.tipo), size: 16, color: _getTipoCor(agendamento.tipo)),
                    const SizedBox(width: 6),
                    Text(
                      agendamento.tipo.toUpperCase(),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  agendamento.hora != null ? 'Hora: ${agendamento.hora}' : 'Horário não definido',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${agendamento.status}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (agendamento.observacao != null && agendamento.observacao!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    agendamento.observacao!,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }



  String _getMonthName(int month) {
    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return meses[month - 1];
  }
}
