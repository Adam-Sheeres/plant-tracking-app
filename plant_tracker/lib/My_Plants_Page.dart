// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:plant_tracker/pages/add_plant_page.dart';
import 'dart:developer';
import 'plantdb.dart';
import 'Navigation_Drawer.dart';
import 'Plant_Info_Page.dart';

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
              title: const Text("My Plants"),
              backgroundColor: const Color.fromARGB(255, 156, 232, 94),
              centerTitle: true,
              titleTextStyle: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 22,
              ),
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
            ), drawer: NavDrawer(refreshPlantList: refreshPlantList),
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: getPlantTiles(_plantList, context),
            ),
            floatingActionButton:
                getAddPlantButton(context, _plantList, db, refreshPlantList),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat,
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
    backgroundColor: const Color.fromARGB(255, 156, 232, 94),
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
  return GestureDetector(
    onTap: () {
      log("Moving to page ${plant.plant_name}");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlantInfoPage(displayPlant: plant),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          _buildImageContainer(plant),
          _buildInfoContainer(plant),
        ],
      ),
    ),
  );
}


Widget _buildImageContainer(Plant plant) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      image: DecorationImage(
        image: NetworkImage(plant.imageUrl),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _buildInfoContainer(Plant plant) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.6),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoRow(plant),
        _buildPlantDetails(plant),
      ],
    ),
  );
}

Widget _buildInfoRow(Plant plant) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            plant.room.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      Container(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.favorite,
            color: plant.isFavourite ? Colors.red : Colors.white,
          ),
        ),
      ),
    ],
  );
}

Widget _buildPlantDetails(Plant plant) {
  return Container(
    alignment: Alignment.bottomCenter,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              plant.plant_name,
              style: const TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding:  const EdgeInsets.all(5.0), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(padding: EdgeInsets.all(2.5), child: Icon(
                Icons.access_time,
                color: Colors.white,
              )),
              Padding(padding: const EdgeInsets.all(2.5), child: Text(
                plant.water_days.toString(),
                style: const TextStyle(color: Colors.white),
              ),),
              Expanded(
                child: LinearProgressIndicator(
                  value: getWateringBar(plant),
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 76, 222, 241),
                  ),
                ),
              ),
            ],
        ),),
        
      ],
    ),
  );
}

double getWateringBar(Plant plant) {
  DateTime lastWatered = plant.last_watered;
  DateTime now = DateTime.now();


  int daysSinceLastWatered = now.difference(lastWatered).inDays;
  int wateringInterval = plant.water_days;

  // If the plant has not been watered for longer than its watering interval, return 0
  if (daysSinceLastWatered >= wateringInterval) {
    return 0.0;
  }

  // Calculate the watering level as a fraction between 0 and 1
  double wateringLevel = 1.0 - (daysSinceLastWatered / wateringInterval);
  wateringLevel.clamp(0, 1);
  return wateringLevel;
}
