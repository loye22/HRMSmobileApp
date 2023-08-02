import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobilehrmss/models/Dialog.dart';
import '../models/AppColors.dart';
import '../widgets/background.dart';

class loginPage extends StatefulWidget {
  static const routeName = '/loginPage';

  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/login_BG.jpg'),
                  fit: BoxFit
                      .cover, // You can adjust the BoxFit as per your requirement
                ),
              )),
          Positioned(
            top: 250,
            left: 40,
            child: Text(
              'Login',
              style: GoogleFonts.montserratAlternates(
                  fontSize: 40,
                  color: Color.fromRGBO(0, 81, 45, 100),
                  fontWeight: FontWeight.w500),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 300,
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'email'),
                            validator: (value) {
                              final bool isValid =
                                  EmailValidator.validate(value!);
                              if (value == null || value.isEmpty || !isValid) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!.trim();
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                isLoading
                    ? CircularProgressIndicator(
                        color: Colors.orangeAccent,
                      )
                    : GestureDetector(
                        onTap: () async {
                          await _submitForm();
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            width: size.width * 0.5,
                            decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(80.0),
                                color: Color.fromRGBO(106, 133, 104, 100)),
                            //   padding: const EdgeInsets.all(0),
                            child: Text(
                              "LOGIN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        isLoading = true;
        setState(() {});
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // User is logged in
        print('User ID: ${userCredential.user!.uid}');
      } catch (e) {
        // Login failed
        isLoading = false;
        setState(() {});
        print('Login error: $e');
        MyDialog.showAlert(context, e.toString());
      }
    }
  }
}
