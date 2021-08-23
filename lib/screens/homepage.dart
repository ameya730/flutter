import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/templates/custombutton.dart';
import 'package:gshala/templates/customdropdown.dart';
import 'package:gshala/templates/customtextfield.dart';

class HomePage extends StatelessWidget {
  final List dropList = ['Student', 'Teacher'];
  final GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();
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
                    Text(
                      'English',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
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
                    Text(
                      'ગુજરાતી',
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
                                  'Welcome to G-Shala',
                                  textScaleFactor: 2,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                'Learning Management System of Gujarat',
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
                                  cLabelText: 'Enter ID/Mobile Number',
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please input ID/Mobile number';
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  cLabelText: 'Enter Password',
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please input password';
                                    }
                                    return null;
                                  },
                                ),
                                CustomDropDownField(
                                  hinttext: 'Select Role',
                                  dropList: dropList,
                                  onChanged: (value) {},
                                  onSaved: (value) {},
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
                                  buttonLabel: 'Login',
                                  icon: Icons.arrow_forward,
                                  avatorColor: Colors.white,
                                  onPressed: () {
                                    if (validateAndSave()) {
                                      Get.toNamed('/offlinevideoslist');
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
                                    'Forgot Password?',
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
                            left: 16.0,
                            bottom: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Dont have an account yet ?',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              CElevatedButton(
                                buttonLabel: 'Sign Up',
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
