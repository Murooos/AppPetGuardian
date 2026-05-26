import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../configuracoes_screen.dart';
import '../welcome_screen.dart';
import '../../widgets/centered_container.dart';

class TutorHomeScreen extends StatelessWidget {
  final Usuario usuario;
  final List<Pet> pets;

  const TutorHomeScreen({super.key, required this.usuario, required this.pets});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.teal;
    
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: CenteredContainer(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: primaryColor, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá, ${usuario.nome}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Bem-vindo(a) ao Pet Guardian',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ], // Corrigido: Fechamento correto da lista children do Column
                      ),
                    ),
                  ], // Corrigido: Fechamento correto da lista children do Row
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nenhum pet cadastrado',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Você já pode acessar sua conta. Assim que quiser, cadastre um pet para começar a usar todas as funcionalidades.',
                          style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration( // Adicionado 'const' aqui por boa prática
                                    color: AppColors.greyBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.pets, size: 64, color: AppColors.teal),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Você ainda não possui ${pets.length == 1 ? 'um pet cadastrado' : 'pets cadastrados'}.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text('Voltar para o início', style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConfiguracoesScreen(
                                  primaryColor: primaryColor,
                                  usuario: usuario,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primaryColor),
                            foregroundColor: primaryColor,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text('Configurações'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ), // Corrigido: Fechamentos faltantes do SafeArea e Scaffold
    );
  }
}