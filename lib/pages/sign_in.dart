import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo/pages/sign_up.dart';
import 'package:todo/service/auth_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = AuthService();
  bool isLoading = false, passVisible = false;

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<String> handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return "Please enter all the fields.";
    }

    final response =
        await _auth.loginUserWithEmailAndPassword(email.text, password.text);

    log(response.status);
    return response.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Center(
          child: Text(
            "TASK GURU",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white12,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Email",
                      suffixIcon: Icon(Icons.email_sharp)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: password,
                  obscureText: !passVisible,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Password",
                      suffixIcon: IconButton(
                          onPressed: () => setState(() {
                                passVisible = !passVisible;
                              }),
                          icon: passVisible
                              ? Icon(Icons.remove_red_eye_rounded)
                              : Icon(Icons.password_outlined))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String done = await handleSignIn();
                  setState(() {
                    isLoading = false;
                  });
                  if (done == "Success") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      snackBarAnimationStyle: AnimationStyle(
                        duration: Duration(seconds: 1),
                        curve: Curves.decelerate,
                      ),
                      SnackBar(
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        showCloseIcon: true,
                        closeIconColor: Colors.black,
                        backgroundColor: Colors.green,
                        content: Text('Login Successful.'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      snackBarAnimationStyle: AnimationStyle(
                        duration: Duration(seconds: 1),
                        curve: Curves.decelerate,
                      ),
                      SnackBar(
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        showCloseIcon: true,
                        closeIconColor: Colors.black,
                        backgroundColor: Colors.red,
                        content: Text('Error: $done'),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                    if (isLoading) ...[
                      SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    ]
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await _auth.loginWithGoogle();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Sign In With Google",
                        style: TextStyle(color: Colors.white),
                      ),
                      if (isLoading) ...[
                        SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      ]
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't Have an Account?"),
                  TextButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp())),
                      child:
                          Text("Sign Up", style: TextStyle(color: Colors.red)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
