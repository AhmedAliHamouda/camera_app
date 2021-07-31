import 'package:camera_app/screens/auth/login_screen.dart';
import 'package:camera_app/utils/custom_functions.dart';
import 'package:camera_app/widgets/custom_rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Builder(
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
                    email = value!;
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
                    password = value!;
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                showSpinner
                    ? Center(child: CircularProgressIndicator())
                    : CustomRoundedButton(
                        title: 'Register',
                        color: Colors.lightBlueAccent,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              if (newUser != null) {
                                CustomFunctions.pushScreen(
                                    widget: LoginScreen(), context: context);
                                print(email);
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                              setState(() {
                                showSpinner = false;
                              });
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Can\'n Register account '),));
                            }
                          }
                        },
                      ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  'You  Have Account!',
                  style: TextStyle(color: Colors.grey, fontSize: 17.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                InkWell(
                  onTap: () {
                    CustomFunctions.pushScreen(
                        widget: LoginScreen(), context: context);
                  },
                  child: Text(
                    'LOGIN NOW ',
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
