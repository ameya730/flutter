import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/controllers/language_controller.dart';
import 'package:gshala/controllers/login_controller.dart';
import 'package:gshala/templates/custombutton.dart';
import 'package:gshala/templates/customdropdown.dart';
import 'package:gshala/templates/customtextfield.dart';

class HomePage extends StatelessWidget {
  final List dropList = ['Student'.tr, 'Teacher'.tr];
  final GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();
  final LogInController logInController = Get.put(LogInController());
  final LanguageController lControl = Get.put(LanguageController());
  final GetStorage box = new GetStorage();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  'assets/gshalaicon.png',
                  fit: BoxFit.scaleDown,
                  height: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    GestureDetector(
                      child: Text(
                        'English',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        lControl.selectedLanguage.value = 'English';
                        lControl.changeLangauge();
                      },
                    ),
                    SizedBox(width: 2),
                    Text(
                      '|',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 2),
                    GestureDetector(
                      child: Text(
                        'ગુજરાતી',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        lControl.selectedLanguage.value = 'ગુજરાતી';
                        lControl.changeLangauge();
                      },
                    ),
                    SizedBox(width: 2),
                    Text(
                      '|',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Welcome to G-Shala'.tr,
                                  textScaleFactor: 2,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                'Learning Management System of Gujarat'.tr,
                                textScaleFactor: 1,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Form(
                            key: loginFormKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  cLabelText: 'Enter ID/Mobile Number'.tr,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please input ID/Mobile number'.tr;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    logInController.userId.value = value;
                                  },
                                ),
                                CustomTextField(
                                  cLabelText: 'Enter Password'.tr,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please input password'.tr;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    logInController.password.value = value;
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: CustomDropDownField(
                                    hinttext: 'Select Role'.tr,
                                    dropList: dropList,
                                    onChanged: (value) {},
                                    validationtext: 'Please select role'.tr,
                                    onSaved: (value) {
                                      logInController.loginType.value = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, left: 16.0, right: 16.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: CElevatedButton(
                                  buttonLabel: 'Login'.tr,
                                  icon: Icons.arrow_forward,
                                  avatorColor: Colors.white,
                                  onPressed: () {
                                    if (validateAndSave()) {
                                      logInController.toJson();
                                      box.write('userName',
                                          logInController.userId.value);
                                      print(box.read('userName'));
                                      Get.offAndToNamed('/profilepage');
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password?'.tr,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Dont have an account yet ?'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              CElevatedButton(
                                buttonLabel: 'Sign Up'.tr,
                                buttonColor: 0xffFBAA00,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = loginFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
