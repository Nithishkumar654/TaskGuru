import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/service/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = AuthService();
  bool isLoading = false, passVisible = false, verified = false, resend = false;

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController repeatPassword = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<String> handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return "Please enter all the fields.";
    }

    if (password.text != repeatPassword.text) {
      return "Both Password and Repeat Password must match.";
    }

    // if (password.text.length < 8) {
    //   return "Password must be atleast 8 characters long.";
    // }

    final response =
        await _auth.createUserWithEmailAndPassword(email.text, password.text);

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
                "Sign Up",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: repeatPassword,
                  obscureText: !passVisible,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Re-Enter Password",
                      suffixIcon: IconButton(
                          onPressed: () => setState(() {
                                passVisible = !passVisible;
                              }),
                          icon: passVisible
                              ? Icon(Icons.remove_red_eye_rounded)
                              : Icon(Icons.password_outlined))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please re-enter password';
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
                  String done = await handleSignUp();
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
                        content: Text('Account Created Successfully.'),
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
                  if (done == "Success") {
                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.app_registration_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "SignUp",
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
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
                  Text("Already Have an Account?"),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child:
                          Text("Sign In", style: TextStyle(color: Colors.red)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
