import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find Me',
          style: GoogleFonts.lato(
              fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        // backgroundColor: Colors.transparent,
        backgroundColor: Color.fromRGBO(0, 226, 193, 1),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            // decoration: const BoxDecoration(
            //     color: Color(0xffffffff),
            //     gradient: LinearGradient(
            //         begin: Alignment.center,
            //         end: Alignment.bottomCenter,
            //         colors: [
            //           Color.fromARGB(255, 255, 255, 255),
            //           Color.fromARGB(255, 180, 255, 244),
            //         ])),
            child: SafeArea(
              child: child!,
            ),
          )
        ],
      ),
    );
  }
}
