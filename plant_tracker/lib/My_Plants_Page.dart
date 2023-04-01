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
    setState(() {});
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
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 22)),
            drawer: NavDrawer(refreshPlantList: refreshPlantList),
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
    alignment: Alignment.bottomLeft,
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
        SizedBox(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.white,
              ),
              Text(
                plant.water_days.toString(),
                style: const TextStyle(color: Colors.white),
              ),
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
          ),
        ),
      ],
    ),
  );
}

double getWateringBar(Plant plant) {
  return (DateTime.now().millisecondsSinceEpoch -
          plant.last_watered.millisecondsSinceEpoch) /
      (plant.water_days * 24 * 60 * 60 * 1000);
}
