import 'package:final_project/login/registerUser.dart';
import 'package:final_project/login/signin.dart';
import 'package:final_project/methods/common_methods.dart';
import 'package:final_project/utility/TextfieldWidget.dart';
import 'package:final_project/utility/buttonWidget.dart';
import 'package:final_project/utility/custom_scaffold2.dart';
import 'package:final_project/utility/loading_dialog.dart';
import 'package:final_project/utility/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController emailIdTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController conformationTextEditingController =
      TextEditingController();

  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailabele() {
    cMethods.checkConnectivity(context);
    signupFormValidation();
  }

  signupFormValidation() {
    if (!emailIdTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Your Email ID Must Be a Valid Email", context);
    } else if (passwordTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "Your Password Must Be Atleast 6 Or More Numbers", context);
    } else if (conformationTextEditingController.text !=
        passwordTextEditingController.text) {
      print(conformationTextEditingController.text);
      print(passwordTextEditingController.text);
      cMethods.displaySnackBar(
        "Your Password and Conformation Must Be The Same",
        context,
      );
    } else {
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          loadingDialiog(messageText: "Registering the account...."),
    );

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailIdTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );

      // User is successfully created
      Navigator.pop(context);

      if (userCredential.user != null) {
        // Navigate to registerUser with user details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => registerUser(
              user: userCredential.user!,
              email: emailIdTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim(),
            ),
          ),
        );
      } else {
        // Handle the case where user is null (unexpected scenario)
        cMethods.displaySnackBar('Unexpected error: User is null', context);
      }
    } catch (error) {
      // Handle the error
      Navigator.pop(context);

      if (error is FirebaseAuthException) {
        if (error.code == 'email-already-in-use') {
          User? currentUser = FirebaseAuth.instance.currentUser;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => registerUser(
                user: currentUser,
                email: emailIdTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim(),
              ),
            ),
          );
        } else {
          // Other Firebase Authentication errors
          cMethods.displaySnackBar(
              error.message ?? 'Error creating user', context);
        }
      } else {
        // Other unexpected errors
        cMethods.displaySnackBar('Unexpected error', context);
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
                  MyText(
                      MylableText: "Sign Up",
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
                  SizedBox(height: 30),
                  MyTextField(
                    HintText: "Confirmation",
                    PrefixIcon: Icon(Icons.lock_outline,
                        color: Color.fromRGBO(0, 226, 193, 1)),
                    obscutreText: true,
                    textEdintincontroller: conformationTextEditingController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      checkIfNetworkIsAvailabele();
                    },
                    child: MyButton(
                        btnText: "SIGN UP",
                        backcolor: Colors.black,
                        color: Colors.white),
                  ),
                  SizedBox(height: 40),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[400])),
                      MyText(
                          MylableText: " Or continue with google ",
                          FontSize: 15,
                          color: Colors.black),
                      Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[400])),
                    ],
                  ),
                  SizedBox(height: 10),
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
                                  builder: (context) => signin()));
                        },
                        child: const MyText(
                            MylableText: " SignIn ",
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
