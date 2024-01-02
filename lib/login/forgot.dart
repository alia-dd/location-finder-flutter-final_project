import 'package:final_project/login/signin.dart';
import 'package:final_project/methods/common_methods.dart';
import 'package:final_project/utility/TextfieldWidget.dart';
import 'package:final_project/utility/buttonWidget.dart';
import 'package:final_project/utility/custom_scaffold2.dart';
import 'package:final_project/utility/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgotPass extends StatefulWidget {
  final String? email;
  const forgotPass({
    super.key,
    required this.email,
  });

  @override
  State<forgotPass> createState() => _forgotPassState();
}

class _forgotPassState extends State<forgotPass> {
  TextEditingController emailIdTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  late BuildContext loadingDialogContext;
  bool isLoading = true;

  checkIfNetworkIsAvailabele() {
    cMethods.checkConnectivity(context);
    emailValidation();
  }

  emailValidation() {
    if (!emailIdTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Your Email ID Must Be a Valid Email", context);
    } else {
      _resetPassword();
    }
  }

  Future _resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        loadingDialogContext = context;
        return loadingDialiog(messageText: "Sending Reset Email...");
      },
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailIdTextEditingController.text.trim());
      Navigator.pop(loadingDialogContext);
      cMethods.displaySnackBar("Password Resent Email Sent", context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => signin()),
      );
    } on FirebaseException catch (e) {
      Navigator.pop(loadingDialogContext);
      cMethods.displaySnackBar(e.toString(), context);
    }
  }

  void initState() {
    super.initState();
    emailIdTextEditingController.text = widget.email ?? "";
    emailIdTextEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
        child: ListView(
          children: [
            SizedBox(height: 60),
            Image(
                image: AssetImage('lib/images/vec4.png'),
                height: 400,
                width: double.infinity),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  MyTextField(
                    HintText: "Email ID",
                    PrefixIcon: Icon(
                      Icons.email_outlined,
                      color: Color.fromRGBO(0, 226, 193, 1),
                    ),
                    obscutreText: false,
                    textEdintincontroller: emailIdTextEditingController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 28),
                  // SizedBox(height: 200),
                  GestureDetector(
                    onTap: () {
                      checkIfNetworkIsAvailabele();
                    },
                    child: MyButton(
                        btnText: "Reset Password",
                        backcolor: Colors.black,
                        color: Colors.white),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
