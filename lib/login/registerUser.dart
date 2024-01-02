import 'package:final_project/login/signin.dart';
import 'package:final_project/methods/common_methods.dart';
import 'package:final_project/utility/TextfieldWidget.dart';
import 'package:final_project/utility/buttonWidget.dart';
import 'package:final_project/utility/custom_scaffold2.dart';
import 'package:final_project/utility/loading_dialog.dart';
import 'package:final_project/utility/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class registerUser extends StatefulWidget {
  final User? user;
  final String? email;
  final String? password;
  const registerUser(
      {super.key,
      required this.user,
      required this.email,
      required this.password});

  @override
  State<registerUser> createState() => _registerUserState();
}

class _registerUserState extends State<registerUser> {
  TextEditingController fullNameTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailabele() {
    cMethods.checkConnectivity(context);
    registerationFormValidation();
  }

  registerationFormValidation() {
    if (fullNameTextEditingController.text.trim().length < 10) {
      cMethods.displaySnackBar(
          "Your Name Is Too Short Please Enter a Valid Name", context);
    } else if (userNameTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "Your User Name Must Be Atleast 5 Or More Characters", context);
    } else if (phoneNumberTextEditingController.text.trim().length < 10 ||
        phoneNumberTextEditingController.text.trim().length > 10) {
      cMethods.displaySnackBar("Please Enter a Valid Phone Number", context);
    } else {
      print(fullNameTextEditingController.text.trim());
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          loadingDialiog(messageText: "Registering your account......"),
    );
    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(widget.user!.uid);
    print("................................");
    print(fullNameTextEditingController.text.trim());
    Map userDataMap = {
      "email": widget.email,
      "password": widget.password,
      "fullName": fullNameTextEditingController.text.trim(),
      "userName": userNameTextEditingController.text.trim(),
      "phone": phoneNumberTextEditingController.text.trim(),
      "id": widget.user!.uid,
      "sharelocaiton": false,
      "mapTheme": selectedImageName,
      "locationString": "",
    };
    userRef.set(userDataMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => signin()));
  }

  int selected = 0;
  String selectedImageName = "standard_style";

  Widget customeRadio(String image, String imageName, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selected = index;
          selectedImageName = image;
        });
        print(selectedImageName);
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
        // padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        child: Column(
          children: [
            Image(
                image: AssetImage('lib/images/' + image + '.png'),
                height: 125,
                width: 107),
            MyText(MylableText: imageName, FontSize: 15, color: Colors.black)
          ],
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
        side: MaterialStateProperty.all(BorderSide(
          color: (selected == index) ? Colors.blue : Colors.grey,
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: ListView(
        children: [
          SizedBox(height: 30),

          // SizedBox(height: 10),
          // SizedBox(height: 103),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 25.0),
              padding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x7E00E2C1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, -7), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: [
                  MyText(
                      MylableText: "Registeration Form",
                      FontSize: 30,
                      color: Color.fromRGBO(0, 226, 193, 1)),
                  SizedBox(height: 60),
                  MyTextField(
                    HintText: "Full Name",
                    PrefixIcon: Icon(Icons.person_2_outlined,
                        color: Color.fromRGBO(0, 226, 193, 1)),
                    obscutreText: false,
                    textEdintincontroller: fullNameTextEditingController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 30),
                  MyTextField(
                    HintText: "User Name",
                    PrefixIcon: Icon(Icons.star_border_outlined,
                        color: Color.fromRGBO(0, 226, 193, 1)),
                    obscutreText: false,
                    textEdintincontroller: userNameTextEditingController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 30),
                  MyTextField(
                    HintText: "Phone Number",
                    PrefixIcon: Icon(
                      Icons.phone_outlined,
                      color: Color.fromRGBO(0, 226, 193, 1),
                    ),
                    obscutreText: false,
                    textEdintincontroller: phoneNumberTextEditingController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 60),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: customeRadio(
                                  "standard_style", "Standard", 1)),
                          SizedBox(width: 10),
                          Expanded(
                              child: customeRadio("retro_style", "Retro", 2)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: customeRadio("dark_style", "Dark", 3)),
                          SizedBox(width: 10),
                          Expanded(
                              child: customeRadio("night_style", "Night", 4)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      checkIfNetworkIsAvailabele();
                    },
                    child: MyButton(
                        btnText: "Save",
                        backcolor: Color.fromRGBO(0, 226, 193, 1),
                        color: Colors.white),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
