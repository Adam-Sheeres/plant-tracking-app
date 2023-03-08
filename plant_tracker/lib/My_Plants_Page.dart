import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'Plant_DB.dart';
import 'Navigation_Drawer.dart';

Widget getHomePage(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
        title: const Text("My Plants"),
        backgroundColor: Color.fromARGB(255, 44, 71, 22),
        centerTitle: true,
        titleTextStyle:
            const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 22)),
    drawer: NavigationDrawer(context),
    body: GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        for (int i = 0; i < plant_list.length; i++) genPlantTile(i, context),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add),
      backgroundColor: const Color.fromARGB(255, 156, 232, 94),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}

Widget genPlantTile(int number, context) {
  Plant curPlant = plant_list[number];
  return GestureDetector(
      onTap: () {
        log("Moving to page ${curPlant.plant_name}"); //HERE IS WHERE YOU ADD THE 'PLANT PAGE'
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
                                curPlant.room?.name ?? "",
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
                                    style:
                                        const TextStyle(color: Colors.white)),
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
          )));
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

  double diff = (diffBetweenNowAndNextWater / totalWaitingTimeInHours);

  log("${diff}out of $totalWaitingTimeInHours");

  return diff;
}
