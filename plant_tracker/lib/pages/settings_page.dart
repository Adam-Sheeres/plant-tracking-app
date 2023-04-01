import 'package:flutter/material.dart';
import '../plantdb.dart';

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
      body:  Padding(padding: const EdgeInsets.all(10), 
      child: Column(
        children: [
          buildSettingsTile(icon: Icons.mood_bad_outlined, label: "Remove all plants", 
            onPressed: () {
            _plantDB.removeAllPlants();
            setState(() {});
            widget.refreshPlantList();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('All plants removed'),
                duration: Duration(seconds: 3),
              ),
            );},),
          buildSettingsTile(icon: Icons.import_export, label: "Import", onPressed: () {}),
          buildSettingsTile(icon: Icons.import_export, label: "Export", onPressed: () {}),
          ]),)
      // drawer: const NavDrawer(),
    );
  }
}

Widget buildSettingsTile({
  required String label,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.grey[200], minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}