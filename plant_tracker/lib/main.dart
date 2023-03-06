import 'package:flutter/material.dart';
import 'My_Plants_Page.dart';

void main() => runApp(MyApp());

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
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

Widget BuildMenuItems(BuildContext context) => Column(
      children: [
        //add more kids here if need be
        ListTile(
          leading: const Icon(Icons.list_alt),
          title: const Text("Recipes"),
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
          title: const Text("Favourite Recipes"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return MaterialApp(
                  home: Scaffold(
                    appBar: AppBar(
                        title: const Text("Adam's Recipie Book"),
                        backgroundColor:
                            const Color.fromARGB(255, 156, 232, 94),
                        centerTitle: true,
                        titleTextStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 22)),
                    body: const Align(
                        alignment: Alignment.center,
                        child: Text("Favourite Recipies")),
                    drawer: const NavigationDrawer(),
                  ),
                );
              },
            ));
            // handle Recipes button press
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
                    drawer: const NavigationDrawer(),
                  ),
                );
              },
            ));
            // handle Recipes button press
          },
        ),
      ],
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHome());
  }
}

//this builds the material App
class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              title: const Text("My Plants"),
              backgroundColor: const Color.fromARGB(255, 156, 232, 94),
              centerTitle: true,
              titleTextStyle: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), fontSize: 22)),
          drawer: const NavigationDrawer(),
          body: getHomePage(context)),
    );
  }
}
