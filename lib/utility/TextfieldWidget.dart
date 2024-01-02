import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final String HintText;
  final Icon PrefixIcon;
  final bool obscutreText;
  final TextEditingController? textEdintincontroller;
  final TextInputType keyboardType;
  const MyTextField({
    super.key,
    required this.HintText,
    required this.PrefixIcon,
    required this.textEdintincontroller,
    required this.keyboardType,
    required this.obscutreText,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return TextField(
      controller: textEdintincontroller,
      obscureText: obscutreText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: HintText,
        prefixIcon: PrefixIcon,
        hintStyle: GoogleFonts.lato(
          fontSize: 16,
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(0, 226, 193, 1))),
      ),
    );
  }
}
