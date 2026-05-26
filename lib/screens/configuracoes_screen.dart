import 'package:flutter/material.dart';
import '../models/models.dart';

class ConfiguracoesScreen extends StatelessWidget {
  final Color primaryColor;
  final Usuario? usuario;

  const ConfiguracoesScreen({
    super.key,
    required this.primaryColor,
    this.usuario,
  });

  List<Map<String, dynamic>> _getItems(BuildContext context) {
    final baseItems = [
      {'icon': Icons.person_outline, 'label': 'Minha Conta', 'action': null as Function?},
      {'icon': Icons.notifications_outlined, 'label': 'Notificações', 'action': null as Function?},
      {'icon': Icons.security_outlined, 'label': 'Privacidade & Segurança', 'action': null as Function?},
      {'icon': Icons.headset_mic_outlined, 'label': 'Ajuda e Suporte', 'action': null as Function?},
      {'icon': Icons.info_outline, 'label': 'Sobre', 'action': null as Function?},
    ];

    return baseItems;
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItems(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor, Colors.white],
            stops: const [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                    ),
                    const Expanded(
                      child: Text(
                        'Configurações',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 22),
                  ],
                ),
              ),

              // Busca
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Buscar...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Lista
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => Divider(color: Colors.grey[200]),
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return ListTile(
                        leading: Icon(item['icon'] as IconData,
                            color: Colors.grey[700], size: 22),
                        title: Text(
                          item['label'] as String,
                          style: const TextStyle(fontSize: 15),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: (item['action'] as Function?) != null
                            ? () => (item['action'] as Function).call()
                            : () {},
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
