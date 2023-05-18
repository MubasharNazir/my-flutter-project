import 'package:api_practice/Models/user_model.dart';
import 'package:api_practice/Pages/login_screen.dart';
import 'package:api_practice/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 100, bottom: 0),
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(right: 0.65),
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                child: TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                      hintText: 'First Name',
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the second name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: TextFormField(
                  controller: secondNameController,
                  decoration: InputDecoration(
                      hintText: 'Second Name',
                      labelText: 'Second Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the second name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter the email';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Please enter the valid email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    RegExp regex = new RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                    if (value == null || value.isEmpty) {
                      return 'Enter the password';
                    }
                    if (!regex.hasMatch(value)) {
                      return 'Enter the Valid Password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: TextFormField(
                  obscureText: true,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      labelText: 'confirm password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (confirmPasswordController.text !=
                        passwordController.text) {
                      return 'passowrd and confirm password should be same';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  onPressed: () {
                    SignUp(emailController.text, passwordController.text);
                  },
                  text: 'SIGN UP',
                  //child:  text: 'SIGN UP',
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void SignUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => PostDetailsToFirebase())
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.msg);
      });
    }
  }

  void PostDetailsToFirebase() async {
    // calling our firestore
    //calling our usermodel
    // sendind these values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameController.text;
    userModel.secondName = secondNameController.text;

    await firebaseFirestore
        .collection('users')
        .doc('user.uid')
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: 'Account Created Successfully');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
