// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
//import '../services/plantdb.dart';
import 'package:plant_tracker/plant_db.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import '../services/Navigation_Drawer.dart';
import '../services/notification.dart';

class PlantInfoPage extends StatelessWidget {
  Plant displayPlant;
  plant_db db = plant_db();
  PlantInfoPage({super.key, required this.displayPlant});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Details"),
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: const Color.fromRGBO(255, 255, 255, 0),
              width: double.infinity,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Hero(
                      tag: displayPlant.plant_name,
                      child: Image.network(
                        displayPlant.imageUrl,
                        fit: BoxFit.fitWidth,
                        height: 400.0,
                        width: double.infinity,
                        alignment: Alignment.center,
                      ),
                    ),
                    Card(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      margin: EdgeInsets.all(0.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  displayPlant.plant_name,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 40,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      db.setWatering(displayPlant);
                                    },
                                    icon: const Icon(Icons.water_drop_outlined))
                              ],
                            ),
                            SizedBox(
                              height: 40.0, // add a height to the container
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: LinearProgressIndicator(
                                        value: getWateringBar(
                                            displayPlant), // This should be a value between 0.0 and 1.0
                                        backgroundColor: Colors.grey,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Color.fromARGB(
                                                    255, 76, 222, 241)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              displayPlant.description,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text.rich(
                              textAlign: TextAlign.left,
                              TextSpan(
                                text: "Last Watered: ",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                      text: DateFormat.yMMMd()
                                          .format(displayPlant.last_watered),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            Text.rich(
                              textAlign: TextAlign.left,
                              TextSpan(
                                text: "Room: ",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                      text: theRoom(displayPlant),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  shadowColor: Colors.black,
                                  color: Color.fromARGB(255, 76, 222, 241),
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                'https://cdn.shopify.com/s/files/1/1061/1924/products/Sweat_Water_Emoji_1024x1024.png?v=1571606064'),
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                      Text(
                                        displayPlant.water_volume.toString() +
                                            " ml",
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                                Card(
                                  shadowColor: Colors.black,
                                  color: Colors.yellow,
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                'https://em-content.zobj.net/thumbs/160/apple/81/electric-light-bulb_1f4a1.png'),
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                      Text(
                                        displayPlant.light_type.displayValue,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                                Card(
                                  shadowColor: Colors.black,
                                  color: Colors.grey,
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                'https://images.emojiterra.com/twitter/v13.1/512px/1f506.png'),
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                      Text(
                                        displayPlant.light_level.displayValue,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [],
                            ),
                            const Text(
                              "Note",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            /*Text(
                              displayPlant.note.note,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),*/
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /*Consumer<AttractionModel>(builder: (context, aModel, _) {
                      return ElevatedButton(
                        onPressed: () {
                          aModel.addAttraction(attraction);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Attraction added to schedule."),
                          ));
                        }, 
                        child: Text("Add"),
                      );
                    }),*/
                  ],
                ),
              ),
            ),
          ],
        ),
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

  String theRoom(Plant plant) {
    if (plant.room == "") {
      return "No room";
    } else {
      return plant.room;
    }
  }
}
