import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const PetGuardianApp());
}

class PetGuardianApp extends StatelessWidget {
  const PetGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Guardian',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tutorTheme,
      home: const WelcomeScreen(),
    );
  }
}
