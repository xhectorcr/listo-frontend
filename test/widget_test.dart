import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:listo_app/main.dart'; // Asegúrate de que esta ruta apunte a tu main.dart

void main() {
  testWidgets('Prueba de carga de la App Cliente', (WidgetTester tester) async {
    // 1. Construye nuestra app.
    await tester.pumpWidget(const ClienteApp());

    // 2. Simplemente verifica que la aplicación principal se haya renderizado.
    // Buscamos que exista al menos un MaterialApp en la pantalla.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
