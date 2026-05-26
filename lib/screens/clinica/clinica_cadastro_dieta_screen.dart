import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../database/database_helper.dart';

class ClinicaCadastroDietaScreen extends StatefulWidget {
  final Usuario usuario;
  final Pet? pet;
  const ClinicaCadastroDietaScreen({
    super.key,
    required this.usuario,
    this.pet,
  });

  @override
  State<ClinicaCadastroDietaScreen> createState() => _ClinicaCadastroDietaScreenState();
}

class _ClinicaCadastroDietaScreenState extends State<ClinicaCadastroDietaScreen> {
  final _formKey = GlobalKey<FormState>();
  Pet? _petSelecionado;
  List<Pet> _pets = [];
  bool _carregando = true;
  bool _salvando = false;

  // Controladores
  final _nomeController = TextEditingController();
  final _marcaController = TextEditingController();
  final _composicaoController = TextEditingController();
  final _beneficiosController = TextEditingController();
  final _recomendacoesController = TextEditingController();

  String _tipoSelecionado = 'Ração';
  final List<String> _tipos = [
    'Ração',
    'Alimento Natural',
    'Complemento',
    'Suplemento',
    'Petisco',
  ];

  @override
  void initState() {
    super.initState();
    _loadPets();
    if (widget.pet != null) {
      _petSelecionado = widget.pet;
    }
  }

  Future<void> _loadPets() async {
    try {
      final pets = await DatabaseHelper.instance.getPetsByClinica(widget.usuario.id!);
      Pet? selectedPet;
      if (widget.pet != null) {
        for (final pet in pets) {
          if (pet.id == widget.pet!.id) {
            selectedPet = pet;
            break;
          }
        }
      }
      setState(() {
        _pets = pets;
        if (selectedPet != null) {
          _petSelecionado = selectedPet;
        }
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar pacientes: $e')),
        );
      }
    }
  }

  Future<void> _salvarDieta() async {
    if (_formKey.currentState!.validate()) {
      if (_petSelecionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione um paciente')),
        );
        return;
      }

      setState(() => _salvando = true);
      try {
        final dieta = Dieta(
          petId: _petSelecionado!.id!,
          clinicaId: widget.usuario.id,
          nome: _nomeController.text,
          marca: _marcaController.text,
          tipo: _tipoSelecionado,
          composicao: _composicaoController.text.isEmpty ? null : _composicaoController.text,
          beneficios: _beneficiosController.text.isEmpty ? null : _beneficiosController.text,
          recomendacoes: _recomendacoesController.text.isEmpty ? null : _recomendacoesController.text,
          dataCriacao: DateTime.now().toIso8601String().split('T')[0],
          clinicaNome: widget.usuario.nome,
        );

        await DatabaseHelper.instance.insertDieta(dieta);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dieta cadastrada com sucesso!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dieta: $e')),
        );
      } finally {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        title: const Text('Nova Dieta'),
        elevation: 0,
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seleção de Paciente
                    _buildSecao('Paciente', [
                      DropdownButtonFormField<Pet>(
                        value: _petSelecionado,
                        items: _pets.map((pet) {
                          return DropdownMenuItem<Pet>(
                            value: pet,
                            child: Text('${pet.nome} (${pet.raca})'),
                          );
                        }).toList(),
                        onChanged: (pet) {
                          setState(() => _petSelecionado = pet);
                        },
                        validator: (value) {
                          if (value == null) return 'Selecione um paciente';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Selecione um paciente',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.orange,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Informações Básicas
                    _buildSecao('Informações Básicas', [
                      TextFormField(
                        controller: _nomeController,
                        decoration: _buildInputDecoration('Nome do Alimento'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Campo obrigatório';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _marcaController,
                        decoration: _buildInputDecoration('Marca/Fabricante'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Campo obrigatório';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _tipoSelecionado,
                        items: _tipos.map((tipo) {
                          return DropdownMenuItem<String>(
                            value: tipo,
                            child: Text(tipo),
                          );
                        }).toList(),
                        onChanged: (tipo) {
                          setState(() => _tipoSelecionado = tipo!);
                        },
                        decoration: _buildInputDecoration('Tipo'),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Detalhes Nutricionais
                    _buildSecao('Detalhes Nutricionais', [
                      TextFormField(
                        controller: _composicaoController,
                        decoration: _buildInputDecoration(
                          'Composição Nutricional',
                          'Ex: Proteínas 25%, Gorduras 14%...',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _beneficiosController,
                        decoration: _buildInputDecoration(
                          'Benefícios',
                          'Liste um benefício por linha',
                        ),
                        maxLines: 4,
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Recomendações
                    _buildSecao('Recomendações de Uso', [
                      TextFormField(
                        controller: _recomendacoesController,
                        decoration: _buildInputDecoration(
                          'Recomendações',
                          'Porções, frequência, observações...',
                        ),
                        maxLines: 3,
                      ),
                    ]),
                    const SizedBox(height: 32),

                    // Botão de Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _salvando ? null : _salvarDieta,
                        icon: _salvando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.check),
                        label: Text(
                          _salvando ? 'Salvando...' : 'Cadastrar Dieta',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSecao(String titulo, List<Widget> children) {
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label, [String? hint]) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.orange,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _marcaController.dispose();
    _composicaoController.dispose();
    _beneficiosController.dispose();
    _recomendacoesController.dispose();
    super.dispose();
  }
}
