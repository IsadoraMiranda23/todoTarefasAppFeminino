import 'package:flutter/material.dart';

class AppTheme {
  static const Color pastel = Color(0xFFFFECEE);
  static const Color blush = Color(0xFFFFB7C5);
  static const Color rosaFundo = Color(0xFFFFD9DF);
  static const Color rosaBlushMedio = Color(0xFFFBB3C1);
  static const Color rosaBlushIntenso = Color(0xFFBF7F8C);
  static const Color textoSueve = Color(0xFF8B6B6B);
  static const Color bordo =Color(0xFF360C19);

  static const Color lavandaClaro = Color(0xFFEDDCFF);
  static const Color lavandaMedio = Color(0xFFD2BFEA);
  static const Color lavandaa = Color(0xFF9A89B2);
  static const Color lilac = Color(0xFF807097);
  static const Color roxo = Color(0xFF372A4C);

  static const Color verdeAgua = Color(0xFFD9F9D8);
  static const Color verdePistache = Color(0xFFAFCFAF);
  static const Color verdeMusgo = Color(0xFF617E63);
  static const Color verdeMilitar = Color(0xFF1B3620);





  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: blush,
      scaffoldBackgroundColor: rosaFundo,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textoSueve,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: blush,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}