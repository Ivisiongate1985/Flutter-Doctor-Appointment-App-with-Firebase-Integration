// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smithackathon/constants/colors.dart';
import 'package:smithackathon/constants/images.dart';
import 'package:smithackathon/controller/home_controller.dart';
import 'package:smithackathon/controller/sign_out_controller.dart';
import 'package:smithackathon/data.dart';
import 'package:smithackathon/function/custom_function.dart';
import 'package:smithackathon/languages.dart';
import 'package:smithackathon/screens/home/widgets/all_doctors.dart';
import 'package:smithackathon/screens/home/widgets/field_categories.dart';
import 'package:smithackathon/screens/navbar/bottomnavigation.dart';
import 'package:smithackathon/theme/theme_controller.dart';
import 'package:smithackathon/widgets/textwidget.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  String? userName;
  String? emailAdress;
  String? profilePicture;
  HomeScreen({
    Key? key,
    this.profilePicture,
    this.userName,
    this.emailAdress,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CustomFunction func = CustomFunction();
  File? profilePic;

  @override
  Widget build(BuildContext context) {
    Languages lang = Get.put(Languages());
    ThemeController themeController = Get.put(ThemeController());
    HomeController homeController = Get.put(HomeController());
    SignoutController signoutController = Get.put(SignoutController());

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: MyColors
                        .purpleColor, // Set the background color to purple
                  ),
                  accountName: Text(widget.userName ?? ""),
                  accountEmail: Text(widget.emailAdress ?? ""),
                  currentAccountPicture: widget.profilePicture != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors
                              .transparent, // Set the background color to transparent
                          child: ClipOval(
                            child: Image.network(
                              widget.profilePicture ??
                                  "https://www.freepnglogos.com/uploads/camera-logo-png/camera-icon-download-17.png",
                              width:
                                  80, // Adjust the width and height as needed
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            XFile? selectedImage = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            print("Image Selected");

                            if (selectedImage != null) {
                              File convertedFile = File(selectedImage.path);
                              UploadTask uploadimage = FirebaseStorage.instance
                                  .ref()
                                  .child("profilepictures")
                                  .child(currentloginedUid)
                                  .putFile(profilePic!);

                              TaskSnapshot taskSnapshot = await uploadimage;
                              String downloadurl =
                                  await taskSnapshot.ref.getDownloadURL();
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(currentloginedUid)
                                  .update({"picture": downloadurl});

                              //  await FirebaseStorage.instance.ref().child("profilepictures").child(const Uuid().v1()).putFile(profilePic!);
                              setState(() {
                                profilePic = convertedFile;
                              });
                              //                    UploadTask uploadimage = FirebaseStorage.instance
                              // .ref()
                              // .child("profilepictures")
                              // .child(currentloginedUid!)
                              // .putFile(profilePic!);
                              print("Image Selected!");
                            } else {
                              print("No Image Selected!");
                            }
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey,
                            backgroundImage: (profilePic != null)
                                ? FileImage(profilePic!)
                                : null,
                          ),
                        )),
              const ListTile(
                leading: Icon(Icons.phone),
                title: Text('Contact Number'),
                subtitle: Text('+92 333 2312948'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "title".tr,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Obx(
                      () => Switch(
                        value: homeController.currentLanguage.value == 'ur_PK',
                        onChanged: (value) => homeController.changeLanguage(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Theme".tr,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Obx(
                      () => Switch(
                          value: themeController.isSwitched.value,
                          onChanged: (value) {
                            themeController.setIsSwitched(value);
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sign Out",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          signoutController.signout();
                        },
                        icon: const Icon(Icons.logout))
                  ],
                ),
              )
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                color: MyColors.purpleColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              _scaffoldKey.currentState!.openDrawer();
                              // func.signout(context);
                            },
                            child: Image.asset(Myimages.drawerIcon)),
                      ],
                    ),
                    TextWidget(
                        textMessage: "welcome".tr + " ${widget.userName}",
                        textColor: MyColors.whiteColor,
                        textSize: 15),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextWidget(
                            textMessage: "message".tr,
                            textColor: MyColors.whiteColor,
                            textSize: 30)),
                    const SizedBox(
                      height: 20,
                    ),
                    TextWidget(
                        textMessage: "doctorinn".tr,
                        textColor: MyColors.whiteColor,
                        textSize: 36),
                  ],
                ),
              ),
            ),
            const FieldsCategories(),
            const AllDoctorData()
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(pageindex: 0),
      ),
    );
  }
}
