import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget NavigationDrawer(BuildContext context) {
  return Drawer(
    child: SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        BuildHeader(context),
        BuildMenuItems(context),
      ],
    )),
  );
}

//Header for the side menu
// ignore: non_constant_identifier_names
Widget BuildHeader(BuildContext context) => Container(
      color: Colors.blue.shade700,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(children: const [
        Padding(
          padding: EdgeInsets.only(top: 40, bottom: 40),
          child: Text(
            "Plant Tracker",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
          ),
        )
      ]),
    );

//Builds the items inside the side menu
// ignore: non_constant_identifier_names
Widget BuildMenuItems(BuildContext context) => Column(
      children: [
        //add more kids here if need be
        ListTile(
          leading: const Icon(Icons.list_alt),
          title: const Text("Plants"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        //
        ListTile(
          leading: const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          title: const Text("Favourites"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return MaterialApp(
                  home: Scaffold(
                    appBar: AppBar(
                        title: const Text("Favourites"),
                        backgroundColor:
                            const Color.fromARGB(255, 156, 232, 94),
                        centerTitle: true,
                        titleTextStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 22)),
                    body: const Align(
                        alignment: Alignment.center,
                        child: Text("Favourite Plants")),
                    drawer: NavigationDrawer(context),
                  ),
                );
              },
            ));
          },
        ),
        //SETTINGS PAGE
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Settings"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return MaterialApp(
                  home: Scaffold(
                    appBar: AppBar(
                        title: const Text("Settings"),
                        backgroundColor:
                            const Color.fromARGB(255, 156, 232, 94),
                        centerTitle: true,
                        titleTextStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 22)),
                    body: const Align(
                        alignment: Alignment.center, child: Text("Settings")),
                    drawer: NavigationDrawer(context),
                  ),
                );
              },
            ));
            // handle Recipes button press
          },
        ),
      ],
    );
