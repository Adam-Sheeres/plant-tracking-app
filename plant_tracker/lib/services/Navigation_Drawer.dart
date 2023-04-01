// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../pages/settings_page.dart';

class NavDrawer extends StatelessWidget {
  final VoidCallback refreshPlantList;

  const NavDrawer({Key? key, required this.refreshPlantList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 156, 232, 94),
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
            title: const Text('My Plants'),
            leading: const Icon(
              Icons.list_alt_rounded,
            ),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);

              Navigator.pop(context);
            },
          ),
          // ListTile(
          //   title: const Text('Favourite Plants'),
          //   leading: const Icon(
          //     Icons.favorite,
          //     color: Colors.red,
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const FavouritesPage(),
          //       ),
          //     );
          //     // Update the state of the app
          //     // ...
          //     // Then close the drawer
          //     // Navigator.pop(context);
          //   },
          // ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(
              Icons.settings,
            ),
                    onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsPage(
                      refreshPlantList: refreshPlantList)));
          // ...
        },

          ),
        ],
      ),
    );
  }
}