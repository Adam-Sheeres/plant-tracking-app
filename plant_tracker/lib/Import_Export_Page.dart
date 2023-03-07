import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget ImportExportPage(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Import/Export'),
      centerTitle: true,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              "You can backup and reload data from here. Simply use the Export button to export the local DataBase to a JSON file, and the Import button to import from a backup"),
          ElevatedButton(
            onPressed: () {
              // Implement file importing functionality here
            },
            child: const Text('Import File'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Implement file exporting functionality here
            },
            child: const Text('Export File'),
          ),
        ],
      ),
    ),
  );
}
