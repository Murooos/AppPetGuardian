import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../database/database_helper.dart';
import '../models/models.dart';
import '../widgets/centered_container.dart';

class CadastroScreen extends StatefulWidget {
  final String tipo;
  const CadastroScreen({super.key, required this.tipo});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _cnpjCtrl = TextEditingController();
  bool _loading = false;

  bool get isClinica => widget.tipo == 'clinica';
  Color get primaryColor => isClinica ? AppColors.orange : AppColors.teal;

  Future<void> _cadastrar() async {
    if (_nomeCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _senhaCtrl.text.isEmpty ||
        (isClinica && _cnpjCtrl.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final usuario = Usuario(
        nome: _nomeCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        senha: _senhaCtrl.text.trim(),
        tipo: widget.tipo,
        cnpj: isClinica ? _cnpjCtrl.text.trim() : null,
      );
      await DatabaseHelper.instance.insertUsuario(usuario);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado! Faça login.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastro ${isClinica ? "Clínica" : "Tutor"}'),
        elevation: 0,
      ),
      body: CenteredContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field('Nome ${isClinica ? "da Clínica" : "Completo"}', _nomeCtrl,
                  Icons.person),
              const SizedBox(height: 12),
              _field('Email', _emailCtrl, Icons.email,
                  type: TextInputType.emailAddress),
              if (isClinica) ...[
                const SizedBox(height: 12),
                _field('CNPJ', _cnpjCtrl, Icons.business,
                    type: TextInputType.number),
              ],
              const SizedBox(height: 12),
              _field('Senha', _senhaCtrl, Icons.lock, obscure: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _cadastrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Cadastrar',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _cnpjCtrl.dispose();
    super.dispose();
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      {bool obscure = false, TextInputType type = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
