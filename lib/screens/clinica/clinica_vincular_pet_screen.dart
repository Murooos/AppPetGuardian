import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../database/database_helper.dart';

class ClinicaVincularPetScreen extends StatefulWidget {
  final Usuario clinica;
  const ClinicaVincularPetScreen({super.key, required this.clinica});

  @override
  State<ClinicaVincularPetScreen> createState() => _ClinicaVincularPetScreenState();
}

class _ClinicaVincularPetScreenState extends State<ClinicaVincularPetScreen> {
  late Future<List<Pet>> _petsFuture;
  late Future<List<Usuario>> _tutoresFuture;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _petsFuture = DatabaseHelper.instance.getPetsNaoVinculados(widget.clinica.id!);
    _tutoresFuture = DatabaseHelper.instance.getAllTutores();
  }

  void _showVincularDialog(Pet pet) {
    showDialog(
      context: context,
      builder: (_) => FutureBuilder<List<Usuario>>(
        future: _tutoresFuture,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const AlertDialog(content: CircularProgressIndicator());
          }
          
          final tutores = snapshot.data ?? [];
          if (tutores.isEmpty) {
            return AlertDialog(
              title: const Text('Nenhum Tutor'),
              content: const Text('Não existem tutores cadastrados'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          }

          return AlertDialog(
            title: Text('Vincular ${pet.nome} a Tutor'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: tutores.map((tutor) {
                  return ListTile(
                    title: Text(tutor.nome),
                    subtitle: Text(tutor.email),
                    onTap: () => _vincularPet(pet.id!, tutor.id!),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _vincularPet(int petId, int tutorId) async {
    Navigator.pop(context);
    
    setState(() => _loading = true);
    try {
      await DatabaseHelper.instance.vincularPetAoTutor(petId, tutorId);
      
      if (mounted) {
        setState(() {
          _petsFuture = DatabaseHelper.instance.getPetsNaoVinculados(widget.clinica.id!);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet vinculado com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const Expanded(
                    child: Text(
                      'Vincular Pets',
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
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: FutureBuilder<List<Pet>>(
                  future: _petsFuture,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            const Text(
                              'Nenhum pet para vincular',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }

                    final pets = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: pets.length,
                      itemBuilder: (_, i) {
                        final pet = pets[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.orange,
                              child: const Icon(Icons.pets, color: Colors.white),
                            ),
                            title: Text(pet.nome),
                            subtitle: Text('${pet.especie} • ${pet.raca}'),
                            trailing: ElevatedButton.icon(
                              onPressed: _loading ? null : () => _showVincularDialog(pet),
                              icon: const Icon(Icons.link, size: 18),
                              label: const Text('Vincular'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
