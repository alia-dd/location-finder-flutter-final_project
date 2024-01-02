import 'package:flutter/material.dart';

class CustomScaffold2 extends StatelessWidget {
  const CustomScaffold2({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Color(0xffffffff),
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 180, 255, 244),
                    ])),
            child: SafeArea(
              child: child!,
            ),
          )
        ],
      ),
    );
  }
}
