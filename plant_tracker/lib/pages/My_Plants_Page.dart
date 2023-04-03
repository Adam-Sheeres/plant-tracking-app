// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:plant_tracker/pages/add_plant_page.dart';
import '../services/Navigation_Drawer.dart';
import '../services/notification.dart';
import 'package:plant_tracker/plant_db.dart';
import 'Plant_Info_Page.dart';

const greenColour = Color.fromARGB(255, 140, 182, 131);

enum SortOption {
  nextToWater,
  name,
  dateAdded,
  room,
}

SortOption _sortOption = SortOption.nextToWater;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.refreshPlantList}) : super(key: key);
  final VoidCallback refreshPlantList;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  plant_db db = plant_db();
  List<Plant> _plantList = [];


  void refreshPlantList() async {
    _plantList = await db.getPlants();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Plant>>(
      future: db.getPlants(),
      builder: (BuildContext context, AsyncSnapshot<List<Plant>> snapshot) {
        _plantList = snapshot.data!;
        if (snapshot.connectionState == ConnectionState.done) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBar(
              title: const Text("Bloom Buddy"),
              backgroundColor: Colors.green,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      switch (_sortOption) {
                        case SortOption.nextToWater:
                          _sortOption = SortOption.name;
                          break;
                        case SortOption.name:
                          _sortOption = SortOption.dateAdded;
                          break;
                        case SortOption.dateAdded:
                          _sortOption = SortOption.room;
                          break;
                        case SortOption.room:
                          _sortOption = SortOption.nextToWater;
                          break;
                      }
                    });
                  },
                  icon: Icon(_sortOption == SortOption.nextToWater
                      ? Icons.water_drop_outlined
                      : _sortOption == SortOption.name
                          ? Icons.sort_by_alpha_outlined
                          : _sortOption == SortOption.dateAdded
                              ? Icons.date_range_outlined
                              : Icons.house_outlined),
                ),
              ],
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          body: getPlantTiles(_plantList, context),
          drawer: NavDrawer(
            refreshPlantList: refreshPlantList,
          ),
          floatingActionButton:
              getAddPlantButton(context, _plantList, db, refreshPlantList),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
        } else {
                  return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBar(
              title: const Text("Bloom Buddy"),
              backgroundColor: Colors.green,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      switch (_sortOption) {
                        case SortOption.nextToWater:
                          _sortOption = SortOption.name;
                          break;
                        case SortOption.name:
                          _sortOption = SortOption.dateAdded;
                          break;
                        case SortOption.dateAdded:
                          _sortOption = SortOption.room;
                          break;
                        case SortOption.room:
                          _sortOption = SortOption.nextToWater;
                          break;
                      }
                    });
                  },
                  icon: Icon(_sortOption == SortOption.nextToWater
                      ? Icons.water_drop_outlined
                      : _sortOption == SortOption.name
                          ? Icons.sort_by_alpha_outlined
                          : _sortOption == SortOption.dateAdded
                              ? Icons.date_range_outlined
                              : Icons.house_outlined),
                ),
              ],
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          body: getPlantTiles(_plantList, context),
          drawer: NavDrawer(
            refreshPlantList: refreshPlantList,
          ),
          floatingActionButton:
              getAddPlantButton(context, _plantList, db, refreshPlantList),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
        }
      },
    );
  }

  FloatingActionButton getAddPlantButton(BuildContext context,
      List<Plant> plantList, plant_db db, VoidCallback callback) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddPlantPage(db: plant_db(), key: UniqueKey())));
        plantList = await db.getPlants();
        callback();
      },
      backgroundColor: greenColour,
      child: const Icon(Icons.add),
    );
  }

  AnimatedList getPlantTiles(List<Plant> plantList, BuildContext context) {
    switch (_sortOption) {
      case SortOption.nextToWater:
        plantList
            .sort((a, b) => getWateringBar(a).compareTo(getWateringBar(b)));
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

    return AnimatedList(
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          opacity: animation,
          child: _buildPlantTile(context, plantList[index]),
        );
      },
      initialItemCount: plantList.length,
    );
  }

  Widget _buildPlantTile(BuildContext context, Plant plant) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: GestureDetector(
        onTap: () {
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
    return Padding(
        padding: const EdgeInsets.all(8.0),
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
                  IconButton(
                      onPressed: () {
                        db
                            .setWatering(plant)
                            .then((value) => refreshPlantList());
                      },
                      icon: const Icon(Icons.water_drop_outlined))
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                margin: const EdgeInsets.only(top: 15.0),
                width: 300,
                height: 10,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: getWateringBar(plant),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 0, 174, 255)),
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
      if (!plant.hasShownNotification) {
        x.showNotification(
            body: "Your ${plant.plant_name} needs some love!",
            title: "BloomBuddy",
            payLoad: "payload");
        plant.hasShownNotification = true;
      }
      return 0.0;
    }

    // Calculate the watering level as a fraction between 0 and 1
    double wateringLevel =
        1.0 - (hoursSinceLastWatered / wateringIntervalInHours);
    wateringLevel.clamp(0, 1);
    return wateringLevel;
  }
}
