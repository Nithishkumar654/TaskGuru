import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/app_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
                    Center(
                      child: Row(
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
