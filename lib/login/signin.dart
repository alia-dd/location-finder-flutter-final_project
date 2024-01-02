import 'package:final_project/global/global_var.dart';
import 'package:final_project/login/forgot.dart';
import 'package:final_project/login/registerUser.dart';
import 'package:final_project/login/signup.dart';
import 'package:final_project/methods/common_methods.dart';
import 'package:final_project/pages/home.dart';
import 'package:final_project/utility/TextfieldWidget.dart';
import 'package:final_project/utility/buttonWidget.dart';
import 'package:final_project/utility/custom_scaffold2.dart';
import 'package:final_project/utility/loading_dialog.dart';
import 'package:final_project/utility/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  TextEditingController emailIdTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailabele() {
    cMethods.checkConnectivity(context);
    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailIdTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Your Email ID Must Be a Valid Email", context);
    } else if (passwordTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar("Please Enter a Valid Password", context);
    } else {
      signInUser();
    }
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          loadingDialiog(messageText: "Loggin In......"),
    );
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailIdTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );

      if (userCredential.user != null) {
        print('----------------------.....................------');
        DatabaseReference userRef = FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(userCredential.user!.uid);
        userRef.once().then((snap) {
          // Navigator.pop(context);
          print('---------------------->>>>>>>>>>>>>>>>>>>>>-----');
          if (snap.snapshot.value != null) {
            print('----------------------<<<<<<<<<<<<<<<<<<<<<<<-----');
            userName = (snap.snapshot.value as Map)["userName"];
            mapstyle = (snap.snapshot.value as Map)["mapTheme"];
            useId = (snap.snapshot.value as Map)["id"];
            String? locationString =
                (snap.snapshot.value as Map)["locationString"];
            mylocationkey =
                (locationString != null && locationString.isNotEmpty)
                    ? locationString
                    : "location key";
            print('----------------------------');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => home()));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => registerUser(
                        user: userCredential.user!,
                        email: emailIdTextEditingController.text.trim(),
                        password: passwordTextEditingController.text.trim(),
                      )),
            );
          }
        });
      }
    } catch (error) {
      // Handle the error here, you can display a proper error message
      Navigator.pop(context);
      cMethods.displaySnackBar(
          "This Email Doesn't Exist Go Sign Up to Continue", context);
    }
  }

  checkIfNetworkIsAvailabele2() {
    cMethods.checkConnectivity(context);
    forgetPage();
  }

  forgetPage() async {
    if (!emailIdTextEditingController.text.contains("@")) {
      // Pop the loading dialog here
      cMethods.displaySnackBar("Your Email ID Must Be a Valid Email", context);
    } else {
      try {
        String passemail = emailIdTextEditingController.text.trim();
        // No need to pop loadingDialogContext here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => forgotPass(email: passemail),
          ),
        );
      } catch (error) {
        // Handle the error here, you can display a proper error message
        cMethods.displaySnackBar(
          "This Email Doesn't Exist Go Sign Up to Continue",
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: Column(
        children: [
          SizedBox(height: 10),
          Image(
              image: AssetImage('lib/images/vec2.jpg'),
              height: 166,
              width: double.infinity),
          // SizedBox(height: 10),
          // SizedBox(height: 103),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 226, 193, 0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, -7), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: ListView(
                children: [
                  const MyText(
                      MylableText: "Sign In",
                      FontSize: 20,
                      color: Color.fromRGBO(0, 226, 193, 1)),
                  SizedBox(height: 30),
                  MyTextField(
                    HintText: "Email ID",
                    PrefixIcon: Icon(Icons.fingerprint_rounded,
                        color: Color.fromRGBO(0, 226, 193, 1)),
                    obscutreText: false,
                    textEdintincontroller: emailIdTextEditingController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 30),
                  MyTextField(
                    HintText: "Password",
                    PrefixIcon: Icon(Icons.lock_outline,
                        color: Color.fromRGBO(0, 226, 193, 1)),
                    obscutreText: true,
                    textEdintincontroller: passwordTextEditingController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          checkIfNetworkIsAvailabele2();
                        },
                        child: MyText(
                            MylableText: "Forgot Password?",
                            FontSize: 14,
                            color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      checkIfNetworkIsAvailabele();
                    },
                    child: MyButton(
                      btnText: "LOG IN",
                      backcolor: Colors.black,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[400])),
                      const MyText(
                          MylableText: " Or continue with google ",
                          FontSize: 15,
                          color: Colors.black),
                      Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[400])),
                    ],
                  ),
                  SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset('lib/images/google.png',
                        height: 64, width: 24),
                    label: Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the border radius
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const MyText(
                          MylableText: " Don't have an Account? ",
                          FontSize: 15,
                          color: Colors.black),
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
                            color: Color.fromRGBO(0, 226, 193, 1)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
