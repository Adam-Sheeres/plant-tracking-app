import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum LightLevel { dark, medium, bright }

File _localFile = File('plant_list.json');

extension LightLevelExtension on LightLevel {
  String get displayValue {
    switch (this) {
      case LightLevel.dark:
        return "Dark";
      case LightLevel.medium:
        return "Medium";
      case LightLevel.bright:
        return "Bright";
      default:
        return "Dark";
    }
  }
}

enum LightType { direct, indirect }

extension LightTypeExtension on LightType {
  String get displayValue {
    switch (this) {
      case LightType.direct:
        return "Direct";
      case LightType.indirect:
        return "Indirect";
      default:
        return "No Light";
    }
  }
}

// class Note {
//   String note;
//   DateTime timeAdded;
//   String plantName;

//   Note({required this.note, required this.timeAdded, required this.plantName});
// }

class Plant {
  String plant_name, description, imageUrl;
  var water_days, water_volume, plant_id;
  DateTime date_added, last_watered;
  bool isFavourite;
  List<Note>? note;

  LightLevel light_level;
  LightType light_type;

  String? room;

  Plant({
    required this.plant_id,
    required this.plant_name,
    required this.date_added,
    required this.water_days,
    required this.last_watered,
    required this.water_volume,
    required this.light_level,
    required this.light_type,
    required this.imageUrl,
    required this.description,
    required this.isFavourite,
    this.note,
    this.room,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    List<dynamic> noteJsonList = json['note'] ?? [];
    List<Note> noteList = noteJsonList.map((noteJson) {
      DateTime dateAdded = DateTime.parse(noteJson['dateAdded']);
      String note = noteJson['note'];
      return Note(dateAdded: dateAdded, note: note);
    }).toList();

    return Plant(
      plant_id: json['plant_id'],
      plant_name: json['plant_name'],
      date_added: DateTime.parse(json['date_added']),
      water_days: json['water_days'],
      last_watered: DateTime.parse(json['last_watered']),
      water_volume: json['water_volume'],
      light_level: _parseLightLevel(json['light_level']),
      light_type: _parseLightType(json['light_type']),
      imageUrl: json['imageUrl'],
      description: json['description'],
      isFavourite: json['isFavourite'],
      note: noteList,
      room: json['room'],
    );
  }

  static LightLevel _parseLightLevel(String displayValue) {
    switch (displayValue) {
      case 'Dark':
        return LightLevel.dark;
      case 'Medium':
        return LightLevel.medium;
      case 'Bright':
        return LightLevel.bright;
      default:
        return LightLevel.dark;
    }
  }

  static LightType _parseLightType(String displayValue) {
    switch (displayValue) {
      case 'Direct':
        return LightType.direct;
      case 'Indirect':
        return LightType.indirect;
      default:
        return LightType.direct;
    }
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> noteJsonList = [];
    if (note != null) {
      noteJsonList = note!
          .map((note) => {
                'dateAdded': note.dateAdded.toIso8601String(),
                'note': note.note,
              })
          .toList();
    }

    return {
      'plant_id': plant_id,
      'plant_name': plant_name,
      'date_added': date_added.toIso8601String(),
      'water_days': water_days,
      'last_watered': last_watered.toIso8601String(),
      'water_volume': water_volume,
      'light_level': light_level.displayValue,
      'light_type': light_type.displayValue,
      'imageUrl': imageUrl,
      'description': description,
      'isFavourite': isFavourite,
      'note': noteJsonList,
      'room': room!,
    };
  }
}

class Note {
  DateTime dateAdded;
  String note;

  Note({required this.dateAdded, required this.note});
}

class Room {
  String name;
  Room({required this.name});
}

class plantDB {
  List<Plant> plant_list = [];

  List<Plant> getList() {
    return plant_list;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/plant_list.json');
  }

  Future<void> addNote(String plantName) async {
    List<Plant> plants = await getPlants();
  }

  Future<void> addPlant(Plant newPlant) async {
    // Get the current list of plants
    List<Plant> plants = await getPlants();

    // Add the new plant to the plant_list
    plants.add(newPlant);
    plant_list = plants;

    // Write the updated plant_list to a file
    await writePlants(plants);
  }

  Future<void> removePlant(int plantIndex) async {
    // Get the current list of plants
    List<Plant> plants = await getPlants();

    // Remove the plant at the specified index from plant_list
    plants.removeAt(plantIndex);
    plant_list = plants;

    // Write the updated plant_list to a file
    await writePlants(plants);
  }

  Future<void> writePlants(List<Plant> plants) async {
    // Write the updated plant_list to the file
    final file = await _localFile;
    await file.writeAsString(jsonEncode(plants));
  }

  Future<List<Plant>> getPlants() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Plant.fromJson(json)).toList();
    } catch (e) {
      print('Error reading plant list file: $e');
      return [];
    }
  }
}
