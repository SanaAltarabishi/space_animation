import 'package:flutter/material.dart';

class TextStyles {
  static const _font1 = TextStyle(fontFamily: 'Exo', color: Colors.white);
//The h1 style is derived from _font1 using the copyWith method
//يعني بشتق منها خواصها+ بضيف الخواص يلي بدي
  static TextStyle get h1 => _font1.copyWith(
      fontSize: 75, letterSpacing: 35, fontWeight: FontWeight.w700);
  static TextStyle get h2 => h1.copyWith(fontSize: 40, letterSpacing: 0);
  static TextStyle get h3 =>
      h1.copyWith(fontSize: 24, letterSpacing: 20, fontWeight: FontWeight.w400);
  static TextStyle get body => _font1.copyWith(fontSize: 16);
  static TextStyle get btn => _font1.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 10,
      );
}

abstract class AppColors {
  static const orbColors = [
    Color.fromARGB(255, 65, 67, 171),
    Color.fromARGB(255, 146, 34, 202),

    Color.fromARGB(255, 31, 98, 150),
   
  ];

  static const emitColors = [
    Color(0xFF96FF33),
    Color(0xFF00FFFF),
      // Color.fromARGB(255, 171, 145, 189)
   Color(0xFFFF993E),
  ];
}
