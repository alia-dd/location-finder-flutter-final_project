import 'package:final_project/global/global_var.dart';
import 'package:final_project/methods/common_methods.dart';
import 'package:final_project/utility/buttonWidget.dart';
import 'package:final_project/utility/custom_scaffold.dart';
import 'package:final_project/utility/loading_dialog.dart';
import 'package:final_project/utility/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class setting extends StatefulWidget {
  const setting({super.key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  CommonMethods cMethods = CommonMethods();
  late BuildContext loadingDialogContext;
  int selected = 0;
  String selectedImageName = mapstyle;

  checkIfNetworkIsAvailabele() {
    cMethods.checkConnectivity(context);
    updateTheme();
  }

  updateTheme() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        loadingDialogContext = context;
        return loadingDialiog(messageText: "Updating App Setting.....");
      },
    );
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (!context.mounted) return;

    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);
    print("................................");
    Map<String, Object?> userDataMap = {
      "mapTheme": selectedImageName,
    };
    userRef.update(userDataMap).then((_) {
      setState(() {
        mapstyle = selectedImageName;
      });
      Navigator.pop(loadingDialogContext);
      cMethods.displaySnackBar("Update successful", context);
    }).catchError((error) {
      Navigator.pop(loadingDialogContext);
      cMethods.displaySnackBar("Error updating data: $error", context);
    });
    // userRef.set(userDataMap);
  }

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
        child: Expanded(
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
    return CustomScaffold(
      child: ListView(
        children: [
          // SizedBox(height: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 25.0),
              padding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20.0),
              child: Column(
                children: [
                  MyText(
                      MylableText: "Setting",
                      FontSize: 30,
                      color: Color.fromRGBO(0, 0, 0, 1)),
                  SizedBox(height: 60),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:
                                customeRadio("standard_style", "Standard", 1),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: customeRadio("retro_style", "Retro", 2),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: customeRadio("dark_style", "Dark", 3),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: customeRadio("night_style", "Night", 4),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      checkIfNetworkIsAvailabele();
                    },
                    child: MyButton(
                        btnText: "Save",
                        backcolor: Colors.black,
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
