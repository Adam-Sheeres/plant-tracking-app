// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:plant_tracker/pages/add_plant_page.dart';
import 'dart:developer';
import '../services/notification.dart';
import '../services/plantdb.dart';
import 'Plant_Info_Page.dart';
import 'package:plant_tracker/pages/settings_page.dart';


const greenColour = Color.fromARGB(255, 140, 182, 131);

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.refreshPlantList}) : super(key: key);

  final VoidCallback refreshPlantList;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  plantDB db = plantDB();
  List<Plant> _plantList = [];

  void refreshPlantList() async {
    _plantList = await db.getPlants();
    setState(() {
      if (_sortOption == SortOption.nextToWater) {
        _sortOption = SortOption.name;
      } else if (_sortOption == SortOption.name) {
        _sortOption = SortOption.dateAdded;
      } else if (_sortOption == SortOption.dateAdded) {
        _sortOption = SortOption.room;
      } else {
        _sortOption = SortOption.nextToWater;
      }
      _plantList.sort((a, b) {
        switch (_sortOption) {
          case SortOption.nextToWater:
            return getWateringBar(a).compareTo(getWateringBar(b));
          case SortOption.name:
            return a.plant_name.compareTo(b.plant_name);
          case SortOption.dateAdded:
            return a.date_added.compareTo(b.date_added);
          case SortOption.room:
            return a.room.compareTo(b.room);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Plant>>(
      future: db.getPlants(),
      builder: (BuildContext context, AsyncSnapshot<List<Plant>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _plantList = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Bloom Buddy"), 
              backgroundColor: Colors.green,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_sortOption == SortOption.nextToWater) {
                        _sortOption = SortOption.name;
                      } else if (_sortOption == SortOption.name) {
                        _sortOption = SortOption.dateAdded;
                      } else if (_sortOption == SortOption.dateAdded) {
                        _sortOption = SortOption.room;
                      } else {
                        _sortOption = SortOption.nextToWater;
                      }
                      _plantList.sort((a, b) {
                        switch (_sortOption) {
                          case SortOption.nextToWater:
                            return getWateringBar(a).compareTo(getWateringBar(b));
                          case SortOption.name:
                            return a.plant_name.compareTo(b.plant_name);
                          case SortOption.dateAdded:
                            return a.date_added.compareTo(b.date_added);
                          case SortOption.room:
                            return a.room.compareTo(b.room);
                        }
                      });
                    });
                  },
                  icon: Icon(_sortOption == SortOption.nextToWater ? Icons.water_drop_outlined
                      : _sortOption == SortOption.name ? Icons.sort_by_alpha_outlined
                          : _sortOption == SortOption.dateAdded ? Icons.date_range_outlined
                              : Icons.house_outlined),
                ),
              ],
            ),
            backgroundColor: const Color.fromARGB(255, 240, 240, 240),
            body: ListView(
              children: getPlantTiles(_plantList, context),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.eco),
                  label: 'Plants',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage(refreshPlantList: refreshPlantList)),
                  );
                }
              },
            ),


            floatingActionButton:
                getAddPlantButton(context, _plantList, db, refreshPlantList),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

enum SortOption {
  nextToWater,
  name,
  dateAdded,
  room,
}

SortOption _sortOption = SortOption.nextToWater;


FloatingActionButton getAddPlantButton(BuildContext context, List<Plant> plantList,
    plantDB db, VoidCallback callback) {
  return FloatingActionButton(
    onPressed: () async {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddPlantPage(db: plantDB(), key: UniqueKey())));
      plantList = await db.getPlants();
      callback();
    },
    backgroundColor: greenColour,
    child: const Icon(Icons.add),
  );
}

List<Widget> getPlantTiles(List<Plant> plantList, BuildContext context) {
  switch (_sortOption) {
    case SortOption.nextToWater:
      plantList.sort((a, b) => getWateringBar(a).compareTo(getWateringBar(b)));
      break;
    case SortOption.name:
      plantList.sort((a, b) => a.plant_name.compareTo(b.plant_name));
      break;
    case SortOption.dateAdded:
      plantList.sort((a, b) => a.date_added.compareTo(b.date_added));
      break;
    case SortOption.room:
      plantList.sort((a, b) => a.room.compareTo(b.room));
      break;
  }

  return plantList.map((plant) => _buildPlantTile(context, plant)).toList();
}

Widget _buildPlantTile(BuildContext context, Plant plant) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: GestureDetector(
      onTap: () {
        log("Moving to page ${plant.plant_name}");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlantInfoPage(displayPlant: plant),
          ),
        );
      },
      child: Card(
        shadowColor: Colors.black,
        color: greenColour,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              height: 100,
              child: _buildImageContainer(plant),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildInfoContainer(plant),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildImageContainer(Plant plant) {
  return 
  Padding(padding: const EdgeInsets.all(8.0), 
  child: Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      image: DecorationImage(
        image: NetworkImage(plant.imageUrl),
        fit: BoxFit.scaleDown,
      ),
    ),
    alignment: Alignment.center,
  ));
}

Widget _buildInfoContainer(Plant plant) {
  return Container(
    decoration: BoxDecoration(

      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPlantDetails(plant),
      ],
    ),
  );
}


Widget _buildPlantDetails(Plant plant) {
  return Container(
    alignment: Alignment.bottomCenter,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                  Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  plant.plant_name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(onPressed: () {
                //TODO add method to set last_watered days to today 
              }, icon: const Icon(Icons.water_drop_outlined))

            ],
          )
        ),
        Padding(
          padding:  const EdgeInsets.all(5.0), 
          child: Container(
          margin: const EdgeInsets.only(top: 15.0),
          width: 300,
          height: 10,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: getWateringBar(plant),
              valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 0, 174, 255)),
              backgroundColor: const Color(0xffD6D6D6),
            ),
          ),
        ))
        
      ],
    ),
  );
}

double getWateringBar(Plant plant) {
  DateTime lastWatered = plant.last_watered;
  DateTime now = DateTime.now();

  int hoursSinceLastWatered = now.difference(lastWatered).inHours;
  int wateringIntervalInHours = plant.water_days * 24;

  // If the plant has not been watered for longer than its watering interval, return 0
  NotificationService x = NotificationService();

  if (hoursSinceLastWatered >= wateringIntervalInHours) {
    //send a notification
    x.showNotification(body: "Your ${plant.plant_name} needs some love!", title: "BloomBuddy", payLoad: "payload");
    return 0.0;
  }

  // Calculate the watering level as a fraction between 0 and 1
  double wateringLevel = 1.0 - (hoursSinceLastWatered / wateringIntervalInHours);
  wateringLevel.clamp(0, 1);
  return wateringLevel;
}
