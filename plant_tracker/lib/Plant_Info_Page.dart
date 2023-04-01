import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'Plant_DB.dart';
import 'Navigation_Drawer.dart';

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
      body: Stack(
        children: [
          Hero(
            tag: displayPlant.plant_name,
            child: Image.network(
              displayPlant.imageUrl,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          Container(
            color: const Color.fromRGBO(0, 0, 0, 0.7),
            width: double.infinity,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    displayPlant.plant_name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Light Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            displayPlant.light_type.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            displayPlant.light_level.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    displayPlant.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Room",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    displayPlant.room.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Note",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    displayPlant.note.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
    );
  }
}
