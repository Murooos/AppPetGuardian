import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../database/database_helper.dart';
import '../../theme/app_theme.dart';

class ClinicaCadastroCarteirinhaScreen extends StatefulWidget {
  final Usuario clinica;

  const ClinicaCadastroCarteirinhaScreen({super.key, required this.clinica});

  @override
  State<ClinicaCadastroCarteirinhaScreen> createState() =>
      _ClinicaCadastroCarteirinhaScreenState();
}

class _ClinicaCadastroCarteirinhaScreenState
    extends State<ClinicaCadastroCarteirinhaScreen> {
  Pet? _petSelecionado;
  List<Pet> _pets = [];
  final _nomeVacinaCtrl = TextEditingController();
  final _dataVacinacaoCtrl = TextEditingController();
  final _proximaDoseCtrl = TextEditingController();
  final _veterinarioCtrl = TextEditingController();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    final pets =
        await DatabaseHelper.instance.getPetsByClinica(widget.clinica.id!);
    setState(() => _pets = pets);
  }

  @override
  void dispose() {
    _nomeVacinaCtrl.dispose();
    _dataVacinacaoCtrl.dispose();
    _proximaDoseCtrl.dispose();
    _veterinarioCtrl.dispose();
    super.dispose();
  }

  Future<void> _selecionarData(TextEditingController controller) async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (data != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(data);
    }
  }

  Future<void> _salvar() async {
    if (_petSelecionado == null ||
        _nomeVacinaCtrl.text.isEmpty ||
        _dataVacinacaoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      final vacinacao = Vacinacao(
        petId: _petSelecionado!.id!,
        nome: _nomeVacinaCtrl.text.trim(),
        data: _dataVacinacaoCtrl.text.trim(),
        proximaDose: _proximaDoseCtrl.text.isEmpty
            ? null
            : _proximaDoseCtrl.text.trim(),
        clinicaNome: widget.clinica.nome,
        veterinario: _veterinarioCtrl.text.isEmpty
            ? null
            : _veterinarioCtrl.text.trim(),
      );

      await DatabaseHelper.instance.insertVacinacao(vacinacao);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Vacinação cadastrada com sucesso!')),
        );
        _nomeVacinaCtrl.clear();
        _dataVacinacaoCtrl.clear();
        _proximaDoseCtrl.clear();
        _veterinarioCtrl.clear();
        setState(() => _petSelecionado = null);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cadastrar Vacinação',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Card de header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.vaccines, color: AppColors.orange, size: 32),
                  const SizedBox(height: 12),
                  const Text(
                    'Registrar Vacinação',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Adicione um novo registro de vacinação ao pet',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Seleção do Pet
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecione o Pet *',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Pet>(
                      isExpanded: true,
                      value: _petSelecionado,
                      hint: const Text(
                        'Escolha um pet',
                        style: TextStyle(color: Colors.white70),
                      ),
                      items: _pets
                          .map((pet) => DropdownMenuItem(
                                value: pet,
                                child: Text(
                                  '${pet.nome} (${pet.raca})',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ))
                          .toList(),
                      onChanged: (pet) =>
                          setState(() => _petSelecionado = pet),
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nome da Vacina
            TextField(
              controller: _nomeVacinaCtrl,
              decoration: InputDecoration(
                labelText: 'Nome da Vacina *',
                labelStyle: const TextStyle(color: Colors.white),
                hintText: 'Ex: V10, Raiva, Leptospirose',
                hintStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
                prefixIcon: const Icon(Icons.vaccines, color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Data da Vacinação
            TextField(
              controller: _dataVacinacaoCtrl,
              readOnly: true,
              onTap: () => _selecionarData(_dataVacinacaoCtrl),
              decoration: InputDecoration(
                labelText: 'Data da Vacinação *',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
                prefixIcon:
                    const Icon(Icons.calendar_today, color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Próxima Dose
            TextField(
              controller: _proximaDoseCtrl,
              readOnly: true,
              onTap: () => _selecionarData(_proximaDoseCtrl),
              decoration: InputDecoration(
                labelText: 'Data da Próxima Dose (opcional)',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
                prefixIcon: const Icon(Icons.schedule, color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Veterinário
            TextField(
              controller: _veterinarioCtrl,
              decoration: InputDecoration(
                labelText: 'Veterinário (opcional)',
                labelStyle: const TextStyle(color: Colors.white),
                hintText: 'Nome do veterinário responsável',
                hintStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
                prefixIcon:
                    const Icon(Icons.person_outline, color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 32),

            // Botão Salvar
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _carregando ? null : _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _carregando
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Salvar Vacinação',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
