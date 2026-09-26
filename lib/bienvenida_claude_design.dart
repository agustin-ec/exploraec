import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colores del diseño "ExploraEC Bienvenida" hecho en el canvas de Claude Design.
class _DesignColors {
  static const acento = Color(0xFF0E5A50);
  static const iconoClaro = Color(0xFFBFF0E3);
  static const fondo = Color(0xFFF4F8F6);
  static const texto = Color(0xFF10201C);
  static const textoSecundario = Color(0xFF45544F);
}

class BienvenidaScreenClaudeDesign extends StatelessWidget {
  const BienvenidaScreenClaudeDesign({
    super.key,
    this.acento = _DesignColors.acento,
    this.onEmpezar,
  });

  // Color de acento del ícono y el botón (el "tweak" del diseño).
  final Color acento;
  final VoidCallback? onEmpezar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _DesignColors.fondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _IconoBrujula(acento: acento),
                    const SizedBox(height: 28),
                    Text(
                      'ExploraEC',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 44,
                        height: 1.05,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                        color: _DesignColors.texto,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: Text(
                        'Descubre lugares increíbles cerca de ti',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: _DesignColors.textoSecundario,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _BotonEmpezar(acento: acento, onPressed: onEmpezar ?? () {}),
            ],
          ),
        ),
      ),
    );
  }
}

// Anillo blanco con sombra suave y, dentro, la brújula sobre el color de acento.
class _IconoBrujula extends StatelessWidget {
  const _IconoBrujula({required this.acento});

  final Color acento;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: acento.withValues(alpha: 0.14),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: acento, shape: BoxShape.circle),
        child: const Center(
          child: Icon(
            Icons.explore_outlined,
            color: _DesignColors.iconoClaro,
            size: 40,
          ),
        ),
      ),
    );
  }
}

class _BotonEmpezar extends StatelessWidget {
  const _BotonEmpezar({required this.acento, required this.onPressed});

  final Color acento;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: acento.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: acento,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 18,
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
    );
  }
}
