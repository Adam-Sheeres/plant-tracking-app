import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Navigation_Drawer.dart';
import 'package:intl/intl.dart';
import '../plantdb.dart';

// list of enums to be used for dropdown
List<String> lightLevels = LightLevel.values.map((e) => e.name).toList();
List<String> lightTypes = LightType.values.map((e) => e.name).toList();

class AddPlantPage extends StatefulWidget {
  final plantDB db;

  const AddPlantPage({required this.db, Key? key}) : super(key: key);

  @override
  State<AddPlantPage> createState() => _AddPlantPage();
}

class _AddPlantPage extends State<AddPlantPage> {
  // setting initial dropdown value
  String dropdownLevelValue = lightLevels.first;
  String dropdownTypeValue = lightTypes.first;

  // controllers to get user input
  TextEditingController dateController = TextEditingController();
  TextEditingController plantNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController waterDaysController = TextEditingController();

  DateTime entryDate = DateTime.now();

  @override
  void dispose() {
    dateController.dispose();
    plantNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Plant",
          style: TextStyle(
            fontSize: 35,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildPlantName(),
              ElevatedButton(
                onPressed: () {
                  },
                child: const Text('Upload Image'),
              ),
              _buildDate(context),
              _buildWaterDays(),
              _buildDescription(),
              _buildLightInfo(),
              _buildButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Align _buildButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: const BorderSide(color: Color.fromARGB(255, 156, 232, 94)),
        ))),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Add Plant',
              style: TextStyle(
                fontSize: 25,
              )),
        ),
        onPressed: () {
          print("HELLO??");
                  Plant newPlant = Plant(
                    plant_id: widget.db.plant_list.length + 1,
                    plant_name: plantNameController.text,
                    date_added: entryDate,
                    water_days: int.parse(waterDaysController.text),
                    last_watered: entryDate,
                    water_volume: 0,
                    light_level: LightLevel.values
                        .firstWhere((level) => level.name == dropdownLevelValue),
                    light_type: LightType.values
                        .firstWhere((type) => type.name == dropdownTypeValue),
                    imageUrl: "",
                    description: descriptionController.text,
                    isFavourite: false,
                    note: [],
                    room: null,
                  );
                  print("Adding plant: " + newPlant.toString());
                  widget.db.addPlant(newPlant);
                
          Navigator.pop(context);
        },
      ),
    );
  }

  Column _buildDate(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Entry Date: ',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: dateController,
            maxLines: 1,
            minLines: 1,
            readOnly: true,
            onTap: () {
              showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101))
                  .then((pickedDate) {
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat.yMMMMEEEEd().format(pickedDate);
                  entryDate = pickedDate;
                  setState(() {
                    dateController.text = formattedDate;
                  });
                }
              });
            },
            decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(), //icon of text field
                labelText: "Enter Date" //label text of field
                ),
          ),
        ),
      ],
    );
  }

  Column _buildPlantName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Plant: ',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: plantNameController,
            maxLines: 1,
            minLines: 1,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter name of plant to be added!',
            ),
          ),
        ),
      ],
    );
  }

  Column _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Description: ',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: descriptionController,
            maxLines: 10,
            minLines: 10,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter a brief description of your plant ...',
            ),
          ),
        ),
      ],
    );
  }

  Column _buildWaterDays() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Watering Days: ',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: waterDaysController,
            maxLines: 1,
            minLines: 1,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter number of days between watering',
            ),
          ),
        ),
      ],
    );
  }

  Row _buildLightInfo() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Light Info: ',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Light Level dropdown
        DropdownButton<String>(
          value: dropdownLevelValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          // style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            // color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownLevelValue = value!;
            });
          },
          items: lightLevels.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        // Light Type dropdown (direct/indirect)
        DropdownButton<String>(
          value: dropdownTypeValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          // style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            // color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownTypeValue = value!;
            });
          },
          items: lightTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
