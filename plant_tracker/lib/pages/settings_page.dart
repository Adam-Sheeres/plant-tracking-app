import 'package:flutter/material.dart';
import '../Navigation_Drawer.dart';
import '../plantdb.dart';
import 'add_plant_page.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback refreshPlantList;

  const SettingsPage({Key? key, required this.refreshPlantList})
      : super(key: key);
  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final _plantDB = plantDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: const Color.fromARGB(255, 156, 232, 94),
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0), fontSize: 22)),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _plantDB.removeAllPlants();
              setState(() {});
              widget.refreshPlantList();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All plants removed'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: Text('Remove all plants'),
          ),
        ],
      ),
      // drawer: const NavDrawer(),
    );
  }
}
