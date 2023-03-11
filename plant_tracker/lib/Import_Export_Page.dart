import 'package:flutter/material.dart';
import 'Navigation_Drawer.dart';

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({super.key});

  @override
  State<ImportExportPage> createState() => _ImportExportPage();
}

class _ImportExportPage extends State<ImportExportPage> {
// ignore: non_constant_identifier_names
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import/Export'),
        centerTitle: true,
      ),
      // drawer: const NavDrawer(),
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
}
