import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_tracker/plant_db.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback refreshPlantList;

  const SettingsPage({Key? key, required this.refreshPlantList})
      : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  // ignore: non_constant_identifier_names
  final _plant_db = plant_db();
   bool _isDarkMode = false; 

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Wrap Scaffold with MaterialApp
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(), // Add this line
      debugShowCheckedModeBanner: false, // Add this line
      home: Scaffold(
      appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: const Color.fromARGB(255, 156, 232, 94),
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0), fontSize: 22)),
      body: settingsBody(),
      ),
    );
  }

  Widget settingsBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          removePlant(),
          buildSettingsTile(
            icon: Icons.import_export,
            label: "Import",
            onPressed: () {importDatabase();},
          ),
          buildSettingsTile(
            icon: Icons.import_export,
            label: "Export",
            onPressed: () {exportDatabase();},
          ),
        ],
      ),
    );
  }


  Widget removePlant() {
    return buildSettingsTile(
      icon: Icons.mood_bad_outlined,
      label: "Remove all plants",
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Remove all plants?"),
              content: const Text("Are you sure you want to remove all plants?"),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Remove"),
                  onPressed: () {
                    _plant_db.removeAllPlants();
                    Navigator.of(context).pop();
                    widget.refreshPlantList();
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All plants removed'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
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
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[200],
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

    Future<void> exportDatabase() async {
    // Get the directory where the file will be saved
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      String path = directory.path;
      String fileName = "plant_db.json";
      File file = File("$path/$fileName");
      log(file.toString());

      // Get the JSON string from the database
      List<Plant> plants = await _plant_db.getPlants();
      String jsonString = jsonEncode(plants);

      // Write the JSON string to the file
      file.writeAsString(jsonString);

      // Show a snackbar to confirm the export
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Database exported as $path/$fileName"),
      ));
    }
  }

    Future<void> importDatabase() async {
    // Get the directory where the file can be found
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      // Show a file picker to allow the user to select the JSON file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        String filePath = file.path!;
        File dbFile = File(filePath);

        // Read the JSON string from the file
        String jsonString = await dbFile.readAsString();

        // Write the JSON string to the database
        List<dynamic> jsonList = jsonDecode(jsonString);
        List<Plant> plants = jsonList.map((json) => Plant.fromJson(json)).toList();
        await _plant_db.writePlants(plants);

        // Show a snackbar to confirm the import
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Database imported from ${file.name}"),
        ));
      }
    }
  }
}
