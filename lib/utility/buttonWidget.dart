import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final String btnText;
  final Color backcolor;
  final Color color;
  const MyButton(
      {super.key,
      required this.btnText,
      required this.backcolor,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Color(btnColor?),
        color: backcolor,
        borderRadius: BorderRadius.circular(15),
      ),
      width: double.infinity,
      height: 65,
      child: Center(
          child: Text(
        btnText,
        style: GoogleFonts.lato(
          fontSize: 25,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }
}
