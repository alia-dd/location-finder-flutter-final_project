import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class loadingDialiog extends StatelessWidget {
  final String messageText;
  loadingDialiog({
    super.key,
    required this.messageText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
      ),
      backgroundColor: Color.fromARGB(3, 10, 203, 100),
      child: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(3, 10, 203, 100),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            SizedBox(
              width: 5,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(messageText,
                style: GoogleFonts.lato(fontSize: 16, color: Colors.white)),
          ]),
        ),
      ),
    );
  }
}
