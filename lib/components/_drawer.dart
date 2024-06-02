import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:todo/pages/profile.dart';
import 'package:todo/provider/app_provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final _auth = FirebaseAuth.instance.currentUser!;

  void showProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        content: SizedBox(
          height: 3 * MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.width,
          child: Profile(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) => Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2))
                ]),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Center(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "TASK ",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  "GURU ",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_auth.photoURL != null)
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: InstaImageViewer(
                                    child: PhotoView(
                                      imageProvider: NetworkImage(
                                        _auth.photoURL!,
                                      ),
                                      backgroundDecoration: BoxDecoration(
                                          color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              )
                            else
                              Icon(
                                Icons.person,
                                size: 50,
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'Welcome ${_auth.displayName}',
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showProfile();
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close_fullscreen)),
                    )
                  ],
                )),
            ListTile(
              tileColor: provider.currentIndex == 0
                  ? Colors.orangeAccent
                  : Colors.transparent,
              title: Center(
                  child: Text(
                "Home",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: provider.currentIndex == 0
                        ? Colors.white
                        : Colors.orange),
              )),
              onTap: () {
                provider.changeCurrentIndex(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              tileColor: provider.currentIndex == 1
                  ? Colors.blueAccent
                  : Colors.transparent,
              title: Center(
                  child: Text(
                "Add Todo",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: provider.currentIndex == 1
                        ? Colors.white
                        : Colors.blue),
              )),
              onTap: () {
                provider.changeCurrentIndex(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
                tileColor: provider.currentIndex == 2
                    ? Colors.orangeAccent
                    : Colors.transparent,
                title: Center(
                    child: Text(
                  "Completed Tasks",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: provider.currentIndex == 2
                          ? Colors.white
                          : Colors.orange),
                )),
                onTap: () {
                  provider.changeCurrentIndex(2);

                  Navigator.pop(context);
                }),
            ListTile(
                tileColor: provider.currentIndex == 3
                    ? Colors.blueAccent
                    : Colors.transparent,
                title: Center(
                    child: Text(
                  "Pending Tasks",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: provider.currentIndex == 3
                          ? Colors.white
                          : Colors.blue),
                )),
                onTap: () {
                  provider.changeCurrentIndex(3);

                  Navigator.pop(context);
                }),
            ListTile(
                tileColor: provider.currentIndex == 4
                    ? Colors.orangeAccent
                    : Colors.transparent,
                title: Center(
                    child: Text(
                  "Out of Deadline Tasks",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: provider.currentIndex == 4
                          ? Colors.white
                          : Colors.orange),
                )),
                onTap: () {
                  provider.changeCurrentIndex(4);

                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
