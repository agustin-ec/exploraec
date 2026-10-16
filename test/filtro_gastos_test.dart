import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:exploraec/controllers/auth_controller.dart';
import 'package:exploraec/controllers/gastos_controller.dart';
import 'package:exploraec/screens/gastos_screen.dart';
import 'package:exploraec/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// Backend de gastos falso con gastos de varias categorías ya registrados.
class _Backend implements HttpClientAdapter {
  /// Cada prueba usa un usuario distinto para abrir su propia caja de Hive.
  static var _usuarios = 100;
  final idUsuario = ++_usuarios;

  final gastos = <Map<String, dynamic>>[
    {'id': 1, 'descripcion': 'Almuerzo', 'monto': 6.5, 'categoria': 'comida', 'fecha': '2026-10-08'},
    {'id': 2, 'descripcion': 'Taxi', 'monto': 3.0, 'categoria': 'transporte', 'fecha': '2026-10-08'},
    {'id': 3, 'descripcion': 'Cena', 'monto': 9.0, 'categoria': 'comida', 'fecha': '2026-10-09'},
    {'id': 4, 'descripcion': 'Regalo', 'monto': 12.0, 'categoria': 'otros', 'fecha': '2026-10-09'},
  ];

  ResponseBody _json(Object? cuerpo, int codigo, [Map<String, List<String>> h = const {}]) =>
      ResponseBody.fromString(jsonEncode(cuerpo), codigo,
          headers: {Headers.contentTypeHeader: ['application/json'], ...h});

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? cuerpo, Future<void>? cancelar) async {
    final ruta = o.path;
    if (ruta == '/usuarios/token') return _json({'access_token': 'tok-a@b.com', 'token_type': 'bearer'}, 200);
    if (ruta == '/usuarios/me') return _json({'id': idUsuario, 'email': 'a@b.com'}, 200);
    if (ruta == '/gastos/categorias') {
      return _json({'categorias': ['comida', 'transporte', 'entretenimiento', 'otros'], 'limite_por_categoria': 500.0}, 200);
    }
    if (ruta == '/gastos/' && o.method == 'GET') return _json(gastos, 200, {'x-total-count': ['${gastos.length}']});
    return _json({'detail': 'ruta no prevista en la prueba: $ruta'}, 404);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(() => Hive.init(Directory.systemTemp.createTempSync('hive_filtro').path));

  /// Monta la app con el servidor falso y la sesión ya iniciada.
  Future<void> montar() async {
    Get.reset();
    Get.testMode = true;
    FlutterSecureStorage.setMockInitialValues({});
    Get.put(ApiClient(dio: Dio(BaseOptions(baseUrl: 'http://backend'))..httpClientAdapter = _Backend()));
    final auth = Get.put(AuthController());
    await auth.iniciarSesion('a@b.com', 'clave-1234');
    final gastos = Get.put(GastosController());
    for (var i = 0; i < 200 && gastos.gastos.isEmpty; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<void> esperarRed(WidgetTester tester) async {
    // Alterna tiempo real (peticiones falsas y disco) con avance del reloj de la prueba.
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 40)));
      await tester.pump(const Duration(milliseconds: 40));
    }
  }

  Future<void> abrirGastos(WidgetTester tester) async {
    await tester.runAsync(montar);
    await tester.pumpWidget(const GetMaterialApp(home: GastosScreen()));
    await esperarRed(tester);
  }

  testWidgets('Muestra «Todas» y una opción por cada categoría presente, con todos los gastos', (tester) async {
    await abrirGastos(tester);
    expect(find.widgetWithText(ChoiceChip, 'Todas'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'comida'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'transporte'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'otros'), findsOneWidget);
    // Una categoría sin gastos no aparece como opción.
    expect(find.widgetWithText(ChoiceChip, 'entretenimiento'), findsNothing);
    for (final d in ['Almuerzo', 'Taxi', 'Cena', 'Regalo']) {
      expect(find.text(d), findsOneWidget);
    }
  });

  testWidgets('Al elegir «comida» solo se ven los gastos de comida', (tester) async {
    await abrirGastos(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, 'comida'));
    await tester.pump();
    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Cena'), findsOneWidget);
    expect(find.text('Taxi'), findsNothing);
    expect(find.text('Regalo'), findsNothing);
  });

  testWidgets('«Todas» vuelve a mostrar todos los gastos', (tester) async {
    await abrirGastos(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, 'comida'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Todas'));
    await tester.pump();
    for (final d in ['Almuerzo', 'Taxi', 'Cena', 'Regalo']) {
      expect(find.text(d), findsOneWidget);
    }
  });
}
