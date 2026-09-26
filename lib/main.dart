import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ExploraEcApp());
}

// Colores del sistema de diseño de Stitch "Andean Canopy & Coastal Mist".
class ExploraColors {
  static const primario = Color(0xFF0D5C52); // primary-container
  static const primarioClaro = Color(0xFFABF0E2); // primary-fixed
  static const fondoSuperior = Color(0xFFF3FBF8); // surface-bright
  static const fondoMedio = Color(0xFFFFFFFF); // surface-container-lowest
  static const texto = Color(0xFF151D1B); // on-surface
  static const textoSecundario = Color(0xFF3F4946); // on-surface-variant
  static const borde = Color(0xFFBEC9C5); // outline-variant
}

class ExploraEcApp extends StatelessWidget {
  const ExploraEcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExploraEC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ExploraColors.primario),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const BienvenidaScreen(),
    );
  }
}

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ExploraColors.fondoSuperior,
              ExploraColors.fondoMedio,
              ExploraColors.fondoSuperior,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _IconoMarca(),
                      const SizedBox(height: 32),
                      Text(
                        'ExploraEC',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 34,
                          height: 42 / 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.85,
                          color: ExploraColors.texto,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Descubre lugares increíbles cerca de ti',
                          maxLines: 1,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            height: 1.6,
                            color: ExploraColors.textoSecundario,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ExploraColors.primario,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: ExploraColors.primario.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Empezar'),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Círculo blanco con borde suave y, dentro, el pin/brújula sobre verde esmeralda.
class _IconoMarca extends StatelessWidget {
  const _IconoMarca();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: ExploraColors.borde.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: ExploraColors.primario.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ExploraColors.primario, Color(0xFF198777)],
          ),
        ),
        child: Center(
          child: Icon(Icons.explore, color: ExploraColors.primarioClaro, size: 36),
        ),
      ),
    );
  }
}
