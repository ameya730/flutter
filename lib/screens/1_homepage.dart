import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/1.0_language_controller.dart';
import 'package:gshala/controllers/1.1_login_controller.dart';
import 'package:gshala/controllers/1.2_password_controller.dart';
import 'package:gshala/controllers/7.0_permissioncontroller.dart';
import 'package:gshala/secureservices.dart';
import 'package:gshala/templates/custombutton.dart';
import 'package:gshala/templates/customdropdown.dart';
import 'package:gshala/templates/custompasswordtextfield.dart';
import 'package:gshala/templates/customtextfield.dart';

class HomePage extends StatelessWidget {
  final List dropList = ['Student'.tr, 'Teacher'.tr];
  final GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();
  final LogInController logInController = Get.put(LogInController());
  final LanguageController lControl = Get.put(LanguageController());
  final GetStorage box = new GetStorage();
  final GlobalKey<ScaffoldState> _homePageKey = new GlobalKey<ScaffoldState>();
  final PasswordController passwordController = Get.put(PasswordController());
  final permissionHandler = Get.put(PermissionHandler());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          //FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: WillPopScope(
          onWillPop: () async {
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Exit App'.tr),
                    content: Text(
                      'Do you want to exit the app ?'.tr,
                      textAlign: TextAlign.justify,
                    ),
                    actions: [
                      CElevatedButton(
                          buttonLabel: 'Yes'.tr,
                          onPressed: () {
                            exit(0);
                          }),
                      CElevatedButton(
                          buttonLabel: 'No'.tr,
                          onPressed: () {
                            // Future.value(false);
                            Navigator.pop(context, false);
                          }),
                    ],
                  );
                });
            throw Exception('Issue');
          },
          child: Scaffold(
            key: _homePageKey,
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.asset(
                          'assets/gshalaicon.png',
                          fit: BoxFit.scaleDown,
                          height: 80,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            GestureDetector(
                              child: Text(
                                'English',
                                style: TextStyle(
                                  fontSize: lControl.selectedLanguage.value ==
                                          'English'
                                      ? 18
                                      : 14,
                                  fontWeight: lControl.selectedLanguage.value ==
                                          'English'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
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
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 2),
                            GestureDetector(
                              child: Text(
                                'ગુજરાતી',
                                style: TextStyle(
                                  fontSize: lControl.selectedLanguage.value ==
                                          'ગુજરાતી'
                                      ? 18
                                      : 14,
                                  fontWeight: lControl.selectedLanguage.value ==
                                          'ગુજરાતી'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                lControl.selectedLanguage.value = 'ગુજરાતી';
                                lControl.changeLangauge();
                              },
                            ),
                            SizedBox(width: 2),
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
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Welcome to G-Shala'.tr,
                                          textScaleFactor: 2,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        'Learning Management System of Gujarat'
                                            .tr,
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
                                          cLabelText:
                                              'Enter ID/Mobile Number'.tr,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please input ID/Mobile number'
                                                  .tr;
                                            }
                                            return null;
                                          },
                                          onChanged: (String value) {
                                            logInController
                                                .updateUserName(value);
                                            // logInController.userControl.value = value;
                                          },
                                          onSaved: (value) {
                                            logInController.userId.value =
                                                value;
                                          },
                                        ),
                                        CustomPasswordTextField(
                                          onTTap: () {
                                            FocusScope.of(context).unfocus();
                                          },
                                          cLabelText: 'Enter Password'.tr,
                                          icon: IconButton(
                                            onPressed: () {
                                              passwordController
                                                  .togglePassword();
                                            },
                                            icon: Obx(
                                              () {
                                                return passwordController
                                                        .showPassword.value
                                                    ? Icon(Icons.visibility_off)
                                                    : Icon(Icons.visibility);
                                              },
                                            ),
                                          ),
                                          obscureText: passwordController
                                              .showPassword.value,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please input password'.tr;
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            logInController.password.value =
                                                value;
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: CustomDropDownField(
                                            hinttext: 'Select Role'.tr,
                                            dropList: dropList,
                                            dropDownValue: logInController
                                                        .dropValue.value !=
                                                    ''
                                                ? logInController
                                                    .dropValue.value.tr
                                                : null,
                                            onChanged: (value) {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            },
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Please select role'.tr;
                                              }
                                              if (logInController.userControl
                                                          .value.length ==
                                                      18 &&
                                                  (value != 'Student' &&
                                                      value != 'વિદ્યાર્થી')) {
                                                return 'Please select Student role';
                                              }
                                              if (logInController.userControl
                                                          .value.length ==
                                                      8 &&
                                                  (value != 'Teacher' &&
                                                      value != 'શિક્ષક')) {
                                                return 'Please select Teacher role';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              if (value == 'વિદ્યાર્થી' ||
                                                  value == 'Student') {
                                                logInController.loginType
                                                    .value = 'student';
                                              } else if (value == 'શિક્ષક' ||
                                                  value == 'Teacher') {
                                                logInController.loginType
                                                    .value = 'teacher';
                                              }
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: CElevatedButton(
                                          buttonLabel: 'Login'.tr,
                                          icon: Icons.arrow_forward,
                                          avatorColor: Colors.white,
                                          onPressed: () {
                                            logInController.userLogginIn.value =
                                                true;
                                            if (validateAndSave()) {
                                              final SecureStorage
                                                  secureStorage =
                                                  new SecureStorage();
                                              secureStorage.writePassWord(
                                                  logInController
                                                      .password.value);
                                              box.write('userName',
                                                  logInController.userId.value);
                                              box.write(
                                                  'uType',
                                                  logInController
                                                      .loginType.value);
                                              box.write(
                                                  'password',
                                                  logInController
                                                      .password.value);
                                              logInController.login().then(
                                                (value) {
                                                  if (logInController
                                                          .isLoginSuccessful
                                                          .value ==
                                                      true) {
                                                    logInController.userLogginIn
                                                        .value = false;
                                                    Get.offAndToNamed(
                                                        '/webviewpage');
                                                  } else {
                                                    box.remove('userName');
                                                    box.remove('uType');
                                                    box.remove('password');
                                                    updateLoginSuccess();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Login failed. Incorrect Username / Password'),
                                                      ),
                                                    );
                                                  }
                                                },
                                              );
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
                                          onPressed: () {
                                            Get.offAndToNamed(
                                                '/forgotpassword');
                                          },
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
                                    bottom: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                        onPressed: () {
                                          Get.offAndToNamed('/signuppage');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextButton.icon(
                            onPressed: () {
                              Get.toNamed('/attributepage');
                            },
                            icon: Icon(
                              Icons.attribution_sharp,
                              color: normalWhiteText,
                            ),
                            label: Text(
                              'Attributions',
                              style: TextStyle(
                                color: normalWhiteText,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 100,
                            child: Image.asset(
                              'assets/getlogo.png',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    return logInController.userLogginIn.value
                        ? Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : Container();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateLoginSuccess() async {
    logInController.userLogginIn.value = false;
  }

  bool validateAndSave() {
    final form = loginFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    updateLoginSuccess();
    return false;
  }
}
