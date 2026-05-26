import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:pet_guardian/models/models.dart';
import 'package:pet_guardian/screens/clinica/clinica_cadastro_tutor_screen.dart';
import 'package:pet_guardian/screens/clinica/clinica_home_screen.dart';
import 'package:pet_guardian/screens/clinica/clinica_pacientes_screen.dart';
import 'package:pet_guardian/screens/clinica/clinica_tutores_screen.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR', null);
  });

  testWidgets('Ações rápidas mostram apenas agenda, pacientes e tutores', (WidgetTester tester) async {
    final usuario = Usuario(
      id: 1,
      nome: 'Clínica Teste',
      email: 'teste@clinica.com',
      senha: '123456',
      tipo: 'clinica',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ClinicaHomeScreen(usuario: usuario),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Agenda'), findsOneWidget);
    expect(find.text('Pacientes'), findsWidgets);
    expect(find.text('Tutores'), findsWidgets);
    expect(find.text('Nova Dieta'), findsNothing);
    expect(find.text('Novo Pet'), findsNothing);
    expect(find.text('Novo Tutor'), findsNothing);
  });

  testWidgets('Botão de tutores abre a tela de tutores', (WidgetTester tester) async {
    final usuario = Usuario(
      id: 1,
      nome: 'Clínica Teste',
      email: 'teste@clinica.com',
      senha: '123456',
      tipo: 'clinica',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ClinicaHomeScreen(usuario: usuario),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(GestureDetector, 'Tutores'));
    await tester.pumpAndSettle();

    expect(find.byType(ClinicaTutoresScreen), findsOneWidget);
  });

  testWidgets('Botão de pacientes abre a tela de pacientes', (WidgetTester tester) async {
    final usuario = Usuario(
      id: 1,
      nome: 'Clínica Teste',
      email: 'teste@clinica.com',
      senha: '123456',
      tipo: 'clinica',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ClinicaHomeScreen(usuario: usuario),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(GestureDetector, 'Pacientes'));
    await tester.pumpAndSettle();

    expect(find.byType(ClinicaPacientesScreen), findsOneWidget);
  });

  testWidgets('Tela de tutor permite cadastrar pet junto ao tutor', (WidgetTester tester) async {
    final clinica = Usuario(
      id: 1,
      nome: 'Clínica Teste',
      email: 'teste@clinica.com',
      senha: '123456',
      tipo: 'clinica',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ClinicaCadastroTutorScreen(clinica: clinica),
      ),
    );

    await tester.pumpAndSettle();

    for (var i = 0; i < 4; i++) {
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();
    }

    expect(find.byKey(const Key('pet_section_card')), findsOneWidget);
  });
}
