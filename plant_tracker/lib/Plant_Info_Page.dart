import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'Plant_DB.dart';
import 'Navigation_Drawer.dart';
import 'My_Plants_Page.dart';

class PlantInfoPage extends StatelessWidget {
  Plant displayPlant;
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
                            Text(
                              displayPlant.plant_name,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                              ),
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
                                    text: "Last Watered: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(text: displayPlant.room!.name, style: TextStyle(fontWeight: FontWeight.normal)),
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
                                      fontSize: 18,
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
                                      fontSize: 18,
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
                            Text(
                              displayPlant.note.note,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
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
}
