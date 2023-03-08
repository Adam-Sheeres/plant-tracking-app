import 'package:flutter/material.dart';
import '../Navigation_Drawer.dart';
import 'package:intl/intl.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPage();
}

class _AddPlantPage extends State<AddPlantPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime entryDate = DateTime.now();

  @override
  void dispose() {
    dateController.dispose();
    titleController.dispose();
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
              _buildTitle(),
              _buildDate(context),
              _buildDescription(),
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
          side: BorderSide(color: Colors.blue.shade700),
        ))),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Create Entry',
              style: TextStyle(
                fontSize: 25,
              )),
        ),
        onPressed: () {
          // need to add functionality here to add plant to local storage/database
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

  Column _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Title: ',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: titleController,
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
}
