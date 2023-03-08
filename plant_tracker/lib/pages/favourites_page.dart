import 'package:flutter/material.dart';
import '../Navigation_Drawer.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Favourites"),
          backgroundColor: const Color.fromARGB(255, 156, 232, 94),
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0), fontSize: 22)),
      body: const Align(
        alignment: Alignment.center,
        child: Text("Favourite Plants"),
      ),
      drawer: const NavDrawer(),
    );
  }
}
