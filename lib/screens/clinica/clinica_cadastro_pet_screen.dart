import '../../widgets/platform_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../database/database_helper.dart';

class ClinicaCadastroPetScreen extends StatefulWidget {
  final Usuario clinica;
  const ClinicaCadastroPetScreen({super.key, required this.clinica});

  @override
  State<ClinicaCadastroPetScreen> createState() => _ClinicaCadastroPetScreenState();
}

class _ClinicaCadastroPetScreenState extends State<ClinicaCadastroPetScreen> {
  final _nomeCtrl = TextEditingController();
  final _racaCtrl = TextEditingController();
  final _idadeCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String _selectedEspecie = 'Cão';
  String _selectedSexo = 'Macho';
  String? _fotoPath;
  bool _loading = false;
  bool _fotoCarregando = false;

  final _especies = ['Cão', 'Gato', 'Pássaro', 'Coelho', 'Roedor', 'Outro'];

  Future<void> _salvar() async {
    if (_nomeCtrl.text.isEmpty || _racaCtrl.text.isEmpty || _idadeCtrl.text.isEmpty) {
      _showSnack('Preencha todos os campos');
      return;
    }

    setState(() => _loading = true);
    try {
      final idade = int.tryParse(_idadeCtrl.text) ?? 0;
      
      final pet = Pet(
        tutorId: null,
        clinicaId: widget.clinica.id,
        criadoPor: 'clinica',
        nome: _nomeCtrl.text.trim(),
        especie: _selectedEspecie,
        raca: _racaCtrl.text.trim(),
        sexo: _selectedSexo,
        idade: idade,
        fotoPath: _fotoPath,
      );

      await DatabaseHelper.instance.insertPet(pet);
      
      if (mounted) {
        _showSnack('Pet cadastrado com sucesso!');
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnack('Erro ao cadastrar pet: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red[700]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const Expanded(
                    child: Text(
                      'Novo Pet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 40),

              // Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações do Pet',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: GestureDetector(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.orange, width: 2),
                          ),
                          child: _fotoCarregando
                                  ? const Center(
                                      child: CircularProgressIndicator(color: AppColors.orange),
                                    )
                                  : _fotoPath != null
                                      ? ClipOval(child: PlatformImage(path: _fotoPath, width: 120, height: 120, fit: BoxFit.cover))
                                      : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.add_a_photo, color: AppColors.orange, size: 28),
                                        SizedBox(height: 8),
                                        Text(
                                          'Adicionar foto',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12, color: AppColors.orange),
                                        ),
                                      ],
                                    ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nome
                    TextField(
                      controller: _nomeCtrl,
                      decoration: InputDecoration(
                        labelText: 'Nome do Pet',
                        prefixIcon: const Icon(Icons.pets, color: AppColors.orange),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Espécie
                    DropdownButtonFormField(
                      value: _selectedEspecie,
                      items: _especies.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (value) => setState(() => _selectedEspecie = value ?? 'Cão'),
                      decoration: InputDecoration(
                        labelText: 'Espécie',
                        prefixIcon: const Icon(Icons.category, color: AppColors.orange),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Raça
                    TextField(
                      controller: _racaCtrl,
                      decoration: InputDecoration(
                        labelText: 'Raça',
                        prefixIcon: const Icon(Icons.info, color: AppColors.orange),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sexo
                    DropdownButtonFormField(
                      value: _selectedSexo,
                      items: ['Macho', 'Fêmea'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (value) => setState(() => _selectedSexo = value ?? 'Macho'),
                      decoration: InputDecoration(
                        labelText: 'Sexo',
                        prefixIcon: const Icon(Icons.wc, color: AppColors.orange),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Idade
                    TextField(
                      controller: _idadeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Idade (anos)',
                        prefixIcon: const Icon(Icons.calendar_today, color: AppColors.orange),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Botões
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _loading ? null : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _loading ? null : _salvar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Salvar',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _racaCtrl.dispose();
    _idadeCtrl.dispose();
    super.dispose();
  }
}
