import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_tracker/pages/add_plant_page.dart';
import 'dart:developer';
import 'Plant_DB.dart';
import 'Navigation_Drawer.dart';
import 'Plant_Info_Page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  plantDB db = plantDB(); //init the db
  List<Plant> _plantList = [];

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
                backgroundColor: const Color.fromARGB(255, 44, 71, 22),
                centerTitle: true,
                titleTextStyle: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 22)),
            drawer: const NavDrawer(),
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: getPlantTiles(_plantList, context),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddPlantPage(db: plantDB(), key: UniqueKey())));
                _plantList = await db.getPlants();
                setState(() {});
              },
              backgroundColor: const Color.fromARGB(255, 156, 232, 94),
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

List<Widget> getPlantTiles(List<Plant> plant_list, BuildContext context) {
  print(plant_list);

  List<Widget> tiles = [];

  for (var i = 0; i < plant_list.length; i++) {
    Plant curPlant = plant_list[i];

    Widget newWidget = GestureDetector(
      onTap: () {
        log("Moving to page ${curPlant.plant_name}");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlantInfoPage(
              displayPlant: curPlant,
            ),
          ),
        );
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(curPlant.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              curPlant.room.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          )),
                      Container(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.favorite,
                              color: curPlant.isFavourite
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          )),
                    ],
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  curPlant.plant_name,
                                  style: const TextStyle(
                                      fontSize: 24.0, color: Colors.white),
                                ))),
                        SizedBox(
                          height: 40.0, // add a height to the container
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.access_time,
                                  color: Colors.white),
                              Text((curPlant.water_days).toString(),
                                  style: const TextStyle(color: Colors.white)),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: getWateringBar(
                                      curPlant), // This should be a value between 0.0 and 1.0
                                  backgroundColor: Colors.grey,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 76, 222, 241)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    tiles.add(newWidget);
  }

  return tiles;
}

double getWateringBar(Plant plant) {
  DateTime nextDateToWater = plant.last_watered
      .add(Duration(days: plant.water_days)); //last date watered + water_days
  DateTime now = DateTime.now();
  int diffBetweenNowAndNextWater = nextDateToWater
      .difference(now)
      .inHours; //difference between when to water next and now

  if (nextDateToWater.isBefore(now)) {
    return 0.0;
  }

  int totalWaitingTimeInHours =
      plant.water_days * 24; //calculate the max value of the bar, would be 1

  //if it is negative, the day to water has passed so just return 0
  if (diffBetweenNowAndNextWater <= 0) {
    return 0.0;
  }

  //find the ratio between when to next water and the total amount of time
  double diff = (diffBetweenNowAndNextWater / totalWaitingTimeInHours);

  log("${diff}out of $totalWaitingTimeInHours");
}
