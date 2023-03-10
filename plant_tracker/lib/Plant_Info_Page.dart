import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'Plant_DB.dart';
import 'Navigation_Drawer.dart';

class PlantInfoPage extends StatelessWidget {
  Plant displayPlant;
  PlantInfoPage({required this.displayPlant});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plant Details"),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 44, 71, 22),
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
            color: Color.fromRGBO(0, 0, 0, 0.7),
            width: double.infinity,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    displayPlant.plant_name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
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
                            child: Text(displayPlant.light_type.displayValue, style: TextStyle(fontSize: 18),),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(displayPlant.light_level.displayValue, style: TextStyle(fontSize: 18),),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
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
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                   SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Room",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    displayPlant.room!.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Note",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    displayPlant.note.note,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
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