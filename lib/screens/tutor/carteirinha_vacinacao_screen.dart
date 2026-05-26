import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../database/database_helper.dart';
import '../../theme/app_theme.dart';

class CarteirinhaVacinacaoScreen extends StatefulWidget {
  final Pet pet;

  const CarteirinhaVacinacaoScreen({super.key, required this.pet});

  @override
  State<CarteirinhaVacinacaoScreen> createState() =>
      _CarteirinhaVacinacaoScreenState();
}

class _CarteirinhaVacinacaoScreenState extends State<CarteirinhaVacinacaoScreen> {
  late Future<List<Vacinacao>> _vacinacoes;

  @override
  void initState() {
    super.initState();
    // Ajuste: Atribuição direta do Future para evitar flickers e re-renderizações redundantes
    _vacinacoes = DatabaseHelper.instance.getVacinacoesByPet(widget.pet.id!);
  }

  String _formatData(String data) {
    try {
      final dt = DateTime.parse(data);
      return DateFormat("dd 'de' MMMM 'de' yyyy", 'pt_BR').format(dt);
    } catch (_) {
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.teal,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Carteirinha de Vacinação',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header do pet
            Container(
              color: AppColors.teal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.pets,
                      color: Colors.white,
                      size: 46,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.pet.nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.pet.raca} • ${widget.pet.sexo}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                ),
              ),
            ],
          ),
        ),
            
            // Painel de Fundo Branco (Garante consistência com a tela de exames)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: FutureBuilder<List<Vacinacao>>(
                  future: _vacinacoes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        // Agora o indicador teal é perfeitamente visível sobre o fundo branco
                        child: CircularProgressIndicator(color: AppColors.teal),
                      );
                    }

                    final vacinacoes = snapshot.data ?? [];

                    if (vacinacoes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.vaccines_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Nenhuma vacinação registrada',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'A clínica adicionará as vacinações aqui',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: vacinacoes.length,
                      itemBuilder: (context, index) {
                        final vac = vacinacoes[index];
                        final dataProxima = vac.proximaDose != null
                            ? DateTime.tryParse(vac.proximaDose!)
                            : null;
                        final agora = DateTime.now();
                        final vencida =
                            dataProxima != null && dataProxima.isBefore(agora);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: vencida
                                ? Colors.red.withOpacity(0.08)
                                : AppColors.greyLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: vencida ? Colors.red : Colors.grey[200]!,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título da Vacina e Status Badge
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: vencida ? Colors.red : AppColors.teal,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      vencida ? 'VENCIDA' : 'ATIVA',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      vac.nome,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Data da aplicação
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Data: ${_formatData(vac.data)}',
                                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                                  ),
                                ],
                              ),

                              // Próxima dose
                              if (vac.proximaDose != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.schedule, color: Colors.grey, size: 16),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Próxima dose: ${_formatData(vac.proximaDose!)}',
                                        style: TextStyle(
                                          color: vencida ? Colors.red : Colors.black54,
                                          fontSize: 13,
                                          fontWeight: vencida ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Veterinário
                              if (vac.veterinario != null && vac.veterinario!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person_outline, color: Colors.grey, size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Veterinário: ${vac.veterinario!}',
                                          style: const TextStyle(color: Colors.black54, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Clínica responsável
                              if (vac.clinicaNome != null && vac.clinicaNome!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.local_hospital_outlined, color: Colors.grey, size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Clínica: ${vac.clinicaNome!}',
                                          style: const TextStyle(color: Colors.black54, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
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