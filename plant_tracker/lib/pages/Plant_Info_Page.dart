// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import '../services/plantdb.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import '../services/Navigation_Drawer.dart';
import '../services/notification.dart';

class PlantInfoPage extends StatelessWidget {
  Plant displayPlant;
  plantDB db = plantDB();
  PlantInfoPage({super.key, required this.displayPlant});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Details"),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 44, 71, 22),
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
                                IconButton(onPressed: () {
                                  db.setWatering(displayPlant);
                                }, icon: const Icon(Icons.water_drop_outlined))
                              ],
                            ),
                            SizedBox(
                              height: 40.0, // add a height to the container
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(Icons.access_time, color: Colors.black),
                                  Text((displayPlant.water_days).toString(),
                                      style: const TextStyle(color: Colors.black)),
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: getWateringBar(displayPlant), // This should be a value between 0.0 and 1.0
                                      backgroundColor: Colors.grey,
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 76, 222, 241)),
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
                              style: const TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  textAlign: TextAlign.left,
                                  TextSpan(
                                    text: "Watered: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(text: DateFormat.yMMMd().format(displayPlant.last_watered), style: TextStyle(fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  textAlign: TextAlign.right,
                                  TextSpan(
                                    text: "Room: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(text: displayPlant.room, style: TextStyle(fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  textAlign: TextAlign.left,
                                  TextSpan(
                                    text: "Light Type: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(text: displayPlant.light_type.name, style: TextStyle(fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  textAlign: TextAlign.right,
                                  TextSpan(
                                    text: "Light Level: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(text: displayPlant.light_level.name, style: TextStyle(fontWeight: FontWeight.normal)),
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
                              children: [

                              ],
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
        x.showNotification(body: "Your ${plant.plant_name} needs some love!", title: "BloomBuddy", payLoad: "payload");
        plant.hasShownNotification = true;
      }
      return 0.0;
    }

    // Calculate the watering level as a fraction between 0 and 1
    double wateringLevel = 1.0 - (hoursSinceLastWatered / wateringIntervalInHours);
    wateringLevel.clamp(0, 1);
    return wateringLevel;
  }
}

