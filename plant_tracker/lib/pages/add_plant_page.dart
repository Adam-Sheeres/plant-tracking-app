import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:plant_tracker/plant_db.dart';
import 'package:image_picker/image_picker.dart';

// list of enums to be used for dropdown
List<String> lightLevels = LightLevel.values.map((e) => e.name).toList();
List<String> lightTypes = LightType.values.map((e) => e.name).toList();

class AddPlantPage extends StatefulWidget {
  final plant_db db;

  const AddPlantPage({required this.db, Key? key}) : super(key: key);

  @override
  State<AddPlantPage> createState() => _AddPlantPage();
}

class _AddPlantPage extends State<AddPlantPage> {
  XFile? image;
  final ImagePicker picker = ImagePicker();

  String base64Image = "";

  late Uint8List imageBytes;

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });

    Uint8List imagebyte = await image!.readAsBytes();
    base64Image = base64Encode(imagebyte);
    print(base64Image);
  }

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
              _buildUploadImage(),
              _buildPlantName(),
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
          if (plantNameController.text.isEmpty ||
              waterDaysController.text.isEmpty) {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildMissingFieldsPopup(context),
            );
          } else {
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
              room: "",
              hasShownNotification: false,
            );
            widget.db.addPlant(newPlant);

            Navigator.pop(context);
          }
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

  Center _buildUploadImage() {
    return Center(
      child: Column(
        children: [
          image != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      //to show image, you type like this.
                      File(image!.path),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                    ),
                  ),
                )
              : const Text(
                  " ",
                  style: TextStyle(fontSize: 20),
                ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildImagePopup(context),
              );
            },
            child: const Text('Upload Image'),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePopup(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select Media',
        textAlign: TextAlign.center,
      ),
      content: Container(
        height: MediaQuery.of(context).size.height / 6,
        child: Column(
          children: [
            ElevatedButton(
              //if user click this button, user can upload image from gallery
              onPressed: () {
                Navigator.pop(context);
                getImage(ImageSource.gallery);
              },
              child: Row(
                children: [
                  const Icon(Icons.image),
                  const Text('  Gallery'),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            ElevatedButton(
              //if user click this button. user can upload image from camera
              onPressed: () {
                Navigator.pop(context);
                getImage(ImageSource.camera);
              },
              child: Row(
                children: [
                  const Icon(Icons.camera),
                  const Text('  Camera'),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
        ),
      ),
      // actions: <Widget>[
      //   TextButton(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     child: const Text('Close'),
      //   ),
      // ],
    );
  }

  Widget _buildMissingFieldsPopup(BuildContext context) {
    return AlertDialog(
      title: const Text('Missing Fields!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
              "Unable to add plant, please enter the name and watering days."),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
