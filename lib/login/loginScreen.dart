import 'package:final_project/login/signin.dart';
import 'package:final_project/login/signup.dart';
import 'package:final_project/utility/buttonWidget.dart';
import 'package:final_project/utility/custom_scaffold2.dart';
import 'package:final_project/utility/mytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class sign extends StatefulWidget {
  const sign({super.key});

  @override
  State<sign> createState() => _signState();
}

class _signState extends State<sign> {
  Route _screenTrasition() {
    return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return signin();
        });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Color.fromRGBO(0, 226, 193, 1)),
        child: ListView(
          children: [
            SizedBox(height: 30),
            Image(
                image: AssetImage('lib/images/vec3.png'),
                height: 400,
                width: double.infinity),
            SizedBox(height: 90),
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  MyText(
                      MylableText: "Find Me",
                      FontSize: 30,
                      color: Colors.white),
                  SizedBox(height: 30),
                  // SizedBox(height: 200),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(_screenTrasition());
                    },
                    child: const MyButton(
                      btnText: "Sign In",
                      backcolor: Color.fromRGBO(255, 255, 255, 1),
                      color: Color.fromRGBO(0, 226, 193, 1),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                          MylableText: " Don't have an Account? ",
                          FontSize: 15,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => signup()));
                        },
                        child: const MyText(
                            MylableText: " SignUp ",
                            FontSize: 15,
                            color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
