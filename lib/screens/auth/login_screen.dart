import 'dart:convert';
import 'dart:developer';

import 'package:camera_app/screens/auth/reg_screen.dart';
import 'package:camera_app/screens/camera/camera_screen.dart';
import 'package:camera_app/utils/constants.dart';
import 'package:camera_app/utils/custom_functions.dart';
import 'package:camera_app/widgets/custom_rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storage_path/storage_path.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String loginEmail;
  late String loginPassword;
  bool showSpinner = false;
  final GlobalKey<FormState> _formKey = GlobalKey();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 48.0,
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    loginEmail = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    loginPassword = value!;
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                showSpinner
                    ? Center(child: CircularProgressIndicator())
                    : CustomRoundedButton(
                        title: 'Log In',
                        color: Colors.lightBlueAccent,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            FocusManager.instance.primaryFocus!.unfocus();

                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              print(loginEmail);
                              final loginUser =
                                  await _auth.signInWithEmailAndPassword(
                                      email: loginEmail,
                                      password: loginPassword);

                              if (loginUser.user != null) {
                                log(loginUser.user.toString());
                                CustomFunctions.pushScreen(widget: CameraScreen(), context: context);
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } on FirebaseAuthException catch (e) {
                              print(' our error $e');
                              setState(() {
                                showSpinner = false;
                              });
                              if (e.code == "wrong-password") {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Wrong Password '),
                                ));
                              } else {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('User Not Found ${e.code} '),
                                ));
                              }
                            } catch (error) {
                              print(error);
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          }
                        },
                      ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  'IF You Don\'t Have Account!',
                  //'IF You Don\'t Have Account!',
                  style: TextStyle(color: Colors.grey, fontSize: 17.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                InkWell(
                  onTap: () {
                    CustomFunctions.pushScreen(
                        widget: RegistrationScreen(), context: context);
                  },
                  child: Text(
                    'SIGNUP NOW ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
