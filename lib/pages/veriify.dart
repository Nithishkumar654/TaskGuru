import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/pages/home.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool verified = false, resend = false;

  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyEmail();
  }

  void verifyEmail() async {
    verified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!verified) {
      await sendEmail();
      timer = Timer.periodic(Duration(seconds: 10), (_) async {
        await checkEmailVerfied();
      });
    } else {
      if (FirebaseAuth.instance.currentUser!.displayName == null) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName('user');
      }
    }
  }

  Future sendEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        resend = false;
      });
      await Future.delayed(Duration(seconds: 5));
      if (mounted) {
        setState(() {
          resend = true;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future checkEmailVerfied() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      verified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (verified) {
      if (FirebaseAuth.instance.currentUser!.displayName == null) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName('user');
      }
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return verified
        ? Home()
        : Scaffold(
            appBar: AppBar(
              elevation: 10,
              title: Center(child: Text('Verify Email')),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Verification Link has been sent to your email.'),
                  ElevatedButton(
                      onPressed: !resend
                          ? null
                          : () async {
                              await sendEmail();
                            },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              resend ? Colors.green : Colors.grey)),
                      child: Text(
                        'Resend Verification Link',
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.grey)),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          );
  }
}
