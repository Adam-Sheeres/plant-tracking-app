import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/favourites_page.dart';
import 'pages/settings_page.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 44, 71, 22),
            ),
            child: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 40),
                  child: Text(
                    "Plant Tracker",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Recipes'),
            leading: const Icon(
              Icons.list_alt_rounded,
            ),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);

              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Favourite Recipes'),
            leading: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavouritesPage(),
                ),
              );
              // Update the state of the app
              // ...
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(
              Icons.settings,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
              // Update the state of the app
              // ...
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// Widget NavigationDrawer(BuildContext context) {
//   return Drawer(
//     child: SingleChildScrollView(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: <Widget>[
//         BuildHeader(context),
//         BuildMenuItems(context),
//       ],
//     )),
//   );
// }

// //Header for the side menu
// // ignore: non_constant_identifier_names
// Widget BuildHeader(BuildContext context) => Container(
//       color: const Color.fromARGB(255, 44, 71, 22),
//       padding: EdgeInsets.only(top: 5),
//       child: Column(children: const [
//         Padding(
//           padding: EdgeInsets.only(top: 40, bottom: 40),
//           child: Text(
//             "Plant Tracker",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
//           ),
//         )
//       ]),
//     );

// //Builds the items inside the side menu
// // ignore: non_constant_identifier_names
// Widget BuildMenuItems(BuildContext context) => Column(
//       children: [
//         //add more kids here if need be
//         ListTile(
//           leading: const Icon(Icons.list_alt),
//           title: const Text("Plants"),
//           onTap: () {
//             Navigator.pop(context);
//           },
//         ),
//         //
//         ListTile(
//           leading: const Icon(
//             Icons.favorite,
//             color: Colors.red,
//           ),
//           title: const Text("Favourites"),
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const SettingsPage()));
//           },
//         ),
//         //SETTINGS PAGE
//         ListTile(
//           leading: const Icon(Icons.settings),
//           title: const Text("Settings"),
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const SettingsPage()));
//           },
//         ),
//       ],
//     );
