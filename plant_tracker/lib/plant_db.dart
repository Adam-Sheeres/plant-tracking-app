enum LightLevel { dark, medium, bright }
extension LightLevelExtension on LightLevel {
  String get displayValue{
    switch(this){
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
  String get displayValue{
    switch(this){
      case LightType.direct:
        return "Direct";
      case LightType.indirect:
        return "Indirect";
      default:
        return "No Light";
    }
  }
}

class Plant {
  String plant_name, description, imageUrl;
  var water_days, water_volume, plant_id;
  DateTime date_added, last_watered;
  bool isFavourite;
  Note note;

  LightLevel light_level;
  LightType light_type;

  Room? room;

  Plant(
      {required this.plant_id,
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
      required this.note,
      this.room});
}

List<Plant> plant_list = [
  Plant(
    plant_id: 1,
    plant_name: 'Monstera',
    date_added: DateTime(2023, 9, 7, 17, 30),
    water_days: 14,
    last_watered: DateTime(2023, 3, 22, 17, 30),
    water_volume: 12,
    light_level: LightLevel.bright,
    light_type: LightType.direct,
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/2/2e/Monstera_deliciosa2.jpg',
    description: 'This is a plant.',
    isFavourite: true,
    note: Note(
      dateAdded: DateTime.now(),
      note: 'This is a note.',
    ),
    room: room_list[1], // provide a default value for room
  ),
  Plant(
    plant_id: 0,
    plant_name: 'Regal Shield',
    date_added: DateTime(2022, 9, 7, 17, 30),
    water_days: 6,
    last_watered: DateTime(2023, 3, 4, 17, 30),
    water_volume: 12,
    light_level: LightLevel.bright,
    light_type: LightType.direct,
    imageUrl:
        'https://www.thespruce.com/thmb/y1QmifWk4IPGXsLjj6OaSynrBmY=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/alocasia-regal-shield-care-guide-5521625-hero-2d34646102c64123bb905480964d47fc.jpg',
    description: 'This is a plant.',
    isFavourite: false,
    note: Note(
      dateAdded: DateTime.now(),
      note: 'Regal shield',
    ),
    room: room_list[0], // provide a default value for room
  )
];

List<Room> room_list = [Room(name: "Living Room"), Room(name: "Kitchen")];

class Note {
  DateTime dateAdded;
  String note;

  Note({required this.dateAdded, required this.note});
}

class Room {
  String name;
  Room({required this.name});
}
