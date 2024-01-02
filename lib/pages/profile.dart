import 'dart:io';

import 'package:final_project/global/global_var.dart';
import 'package:final_project/login/forgot.dart';
import 'package:final_project/methods/common_methods.dart';
import 'package:final_project/utility/TextfieldWidget.dart';
import 'package:final_project/utility/buttonWidget.dart';
import 'package:final_project/utility/custom_scaffold.dart';
import 'package:final_project/utility/loading_dialog.dart';
import 'package:final_project/utility/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  TextEditingController fullNameTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailIdTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  CommonMethods cMethods = CommonMethods();

  late BuildContext loadingDialogContext;
  bool isLoading = true;
  XFile? imageFile;
  String urlOfUploadedImage = "";

  checkIfNetworkIsAvailabele() {
    cMethods.checkConnectivity(context);
    if (imageFile != null) {
      registerationFormValidation();
    } else {
      cMethods.displaySnackBar("Please Choose an Image First", context);
    }
  }

  uploadImage() async {
    String imageIDName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImage =
        FirebaseStorage.instance.ref().child("Images").child(imageIDName);
    UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    urlOfUploadedImage = await snapshot.ref.getDownloadURL();
    setState(() {
      urlOfUploadedImage;
    });
    print(",,,,,..........,,,,,,,,");
    updateUser();
  }

  registerationFormValidation() {
    if (fullNameTextEditingController.text.trim().length < 10 &&
        fullNameTextEditingController.text.trim() != "") {
      cMethods.displaySnackBar(
          "Your Name Is Too Short Please Enter a Valid Name", context);
    } else if (userNameTextEditingController.text.trim().length < 5 &&
        userNameTextEditingController.text.trim() != "") {
      cMethods.displaySnackBar(
          "Your User Name Must Be Atleast 5 Or More Characters", context);
    } else if (phoneNumberTextEditingController.text.trim().length != 10 &&
        phoneNumberTextEditingController.text.trim().isNotEmpty) {
      cMethods.displaySnackBar("Please Enter a Valid Phone Number", context);
    } else {
      saveValues();
      uploadImage();
      print("3333333333333333333333333333333333333333333333333333333333333333");
    }
  }

  void saveValues() {
    if (fullNameTextEditingController.text.isNotEmpty) {
      fullName = fullNameTextEditingController.text.trim();
    }
    if (userNameTextEditingController.text.isNotEmpty) {
      userName = userNameTextEditingController.text.trim();
    }
    if (phoneNumberTextEditingController.text.isNotEmpty) {
      phone = phoneNumberTextEditingController.text.trim();
    }
  }

  updateUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        loadingDialogContext = context;
        return loadingDialiog(messageText: "Loading your profile..");
      },
    );
    if (!context.mounted) return;
    User? currentUser = FirebaseAuth.instance.currentUser;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);
    print("................................");
    print(fullNameTextEditingController.text.trim());
    Map<String, Object?> userDataMap = {
      "fullName": fullName,
      "userName": userName,
      "photo": urlOfUploadedImage,
      "phone": phone,
    };
    userRef.update(userDataMap).then((_) {
      Navigator.pop(loadingDialogContext);
      cMethods.displaySnackBar("Update successful", context);
    }).catchError((error) {
      Navigator.pop(loadingDialogContext);
      cMethods.displaySnackBar("Error updating data: $error", context);
    });
  }

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          loadingDialogContext = context;
          return loadingDialiog(messageText: "Loading The Map...");
        },
      );
    });
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        print('----------------------.....................------');
        DatabaseReference userRef = FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(currentUser.uid);
        userRef.once().then((snap) {
          print('---------------------->>>>>>>>>>>>>>>>>>>>>-----');
          if (snap.snapshot.value != null) {
            setState(() {
              // Update global variables inside setState
              userName = (snap.snapshot.value as Map)["userName"];
              fullName = (snap.snapshot.value as Map)["fullName"];
              phone = (snap.snapshot.value as Map)["phone"];
              email = (snap.snapshot.value as Map)["email"];
              if ((snap.snapshot.value as Map).containsKey("photo") &&
                  (snap.snapshot.value as Map)["photo"] != null) {
                imageUrl = (snap.snapshot.value as Map)["photo"];
              }
            });
            print(
                '----------------$userName----$fullName------$phone-------------$imageUrl');
          }
          if (isLoading) {
            print(">>>>>>>>>>>>>>>>>>>>>>>//");
            Navigator.of(loadingDialogContext).pop();
            isLoading = false;
          }
        });
      }
    } catch (error) {
      Navigator.pop(loadingDialogContext);
      cMethods.displaySnackBar("Something Went Wrong Try Again ", context);
    }
  }

  checkIfNetworkIsAvailabele2() {
    cMethods.checkConnectivity(context);
    forgetPage();
  }

  forgetPage() async {
    try {
      // No need to pop loadingDialogContext here
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => forgotPass(email: email),
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

  chooseImageFromGallery() async {
    final PickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        imageFile = PickedFile;
      });
    }
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
              padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 20.0),
              child: Column(
                children: [
                  imageFile == null
                      ? Container(
                          child: imageUrl == ""
                              ? const CircleAvatar(
                                  radius: 86,
                                  backgroundImage:
                                      AssetImage('lib/images/user1.jpg'),
                                )
                              : Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      image: DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: NetworkImage(imageUrl),
                                      )),
                                ),
                        )
                      : Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: FileImage(
                                    File(
                                      imageFile!.path,
                                    ),
                                  ))),
                        ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      chooseImageFromGallery();
                    },
                    child: MyText(
                      MylableText: "Choose am Image",
                      FontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: emailIdTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: email,
                      enabled: false,
                      prefixIcon: Icon(Icons.fingerprint_outlined,
                          color: Color.fromRGBO(0, 226, 193, 1)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 226, 193, 1))),
                    ),
                  ),
                  SizedBox(height: 25),
                  MyTextField(
                    HintText: fullName,
                    PrefixIcon: Icon(Icons.person_2_outlined,
                        color: Color.fromRGBO(0, 226, 193, 1)),
                    obscutreText: false,
                    textEdintincontroller: fullNameTextEditingController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 25),
                  MyTextField(
                    HintText: userName,
                    PrefixIcon: Icon(Icons.star_border_outlined,
                        color: Color.fromRGBO(0, 226, 193, 1)),
                    obscutreText: false,
                    textEdintincontroller: userNameTextEditingController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 25),
                  MyTextField(
                    HintText: phone,
                    PrefixIcon: Icon(
                      Icons.phone_outlined,
                      color: Color.fromRGBO(0, 226, 193, 1),
                    ),
                    obscutreText: false,
                    textEdintincontroller: phoneNumberTextEditingController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          checkIfNetworkIsAvailabele2();
                        },
                        child: MyText(
                            MylableText: "Change Password",
                            FontSize: 14,
                            color: Color.fromRGBO(143, 16, 16, 0.8)),
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
