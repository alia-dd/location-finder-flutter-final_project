import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatelessWidget {
  final String MylableText;
  final double FontSize;
  final Color? color;
  const MyText({
    super.key,
    required this.MylableText,
    required this.FontSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      MylableText,
      style: GoogleFonts.lato(
          fontSize: FontSize, fontWeight: FontWeight.bold, color: color),
    );
  }
}
