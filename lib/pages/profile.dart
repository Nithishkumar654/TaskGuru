import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:photo_view/photo_view.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController name = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController photoURL = new TextEditingController();

  final _auth = FirebaseAuth.instance.currentUser!;

  bool selecting = false, saving = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      name.text = _auth.displayName ?? "";
      mobile.text = _auth.phoneNumber ?? "";
      email.text = _auth.email ?? "";
      photoURL.text = _auth.photoURL ?? "";
    });
  }

  Future<void> save() async {
    // print(mobile.text as PhoneAuthCredential);
    if (name.text.isNotEmpty) {
      await _auth.updateDisplayName(name.text);
    }
    if (photoURL.text.isNotEmpty) {
      await _auth.updatePhotoURL(photoURL.text);
    }
    // if (mobile.text.isNotEmpty)
    //   await _auth.updatePhoneNumber(mobile.text as PhoneAuthCredential);
  }

  Future<String?> selectPicture() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return null;

    setState(() {
      selecting = true;
    });

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceImages = referenceRoot.child('profiles');
    Reference image = referenceImages.child(fileName);
    try {
      await image.putFile(File(file.path));
      String url = await image.getDownloadURL();
      return url;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Profile',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        )),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Name',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  hintText: 'Enter name to display',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Mobile',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              TextFormField(
                controller: mobile,
                decoration: InputDecoration(
                  hintText: 'Currently unavailable',
                ),
                readOnly: true,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Email',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Email',
                ),
                initialValue: _auth.email,
                readOnly: true,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Profile Picture',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (photoURL.text != "")
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: selecting
                            ? CircularProgressIndicator()
                            : InstaImageViewer(
                                child: PhotoView(
                                  imageProvider: NetworkImage(
                                    photoURL.text,
                                  ),
                                  backgroundDecoration:
                                      BoxDecoration(color: Colors.transparent),
                                ),
                              ),
                      ),
                    )
                  else
                    selecting
                        ? CircularProgressIndicator()
                        : Icon(
                            Icons.person,
                            size: 50,
                          ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: selecting
                        ? null
                        : () async {
                            String? url = await selectPicture();
                            if (url != null) {
                              setState(() {
                                photoURL.text = url;
                                selecting = false;
                              });
                            }
                          },
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            selecting ? Colors.grey : Colors.green)),
                    child: Text(
                      'Change Picture',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: saving
                    ? null
                    : () async {
                        try {
                          setState(() {
                            saving = true;
                          });
                          await save();
                          setState(() {
                            saving = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              snackBarAnimationStyle: AnimationStyle(
                                curve: Curves.easeIn,
                              ),
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                closeIconColor: Colors.black,
                                backgroundColor: Colors.blue,
                                showCloseIcon: true,
                                elevation: 10,
                                content: Text(
                                  'Profile Updated Successfully',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              snackBarAnimationStyle: AnimationStyle(
                                curve: Curves.easeIn,
                              ),
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                closeIconColor: Colors.black,
                                backgroundColor: Colors.red,
                                showCloseIcon: true,
                                elevation: 10,
                                content: Text(
                                  'Error: $e',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));
                        }
                      },
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        saving ? Colors.grey : Colors.green)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    if (saving) ...[
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
