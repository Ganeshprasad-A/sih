import 'package:flutter/material.dart';
import 'screens/plant_list_screen.dart'; // Import your PlantListScreen

void main() {
  runApp(const MedicinalPlantsApp());
}

class MedicinalPlantsApp extends StatelessWidget {
  const MedicinalPlantsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      title: 'Medicinal Plants App', // App title
      theme: ThemeData(
        primarySwatch: Colors.green, // Use a theme color relevant to plants
        visualDensity: VisualDensity.adaptivePlatformDensity, // Adaptive density
      ),
      home: const PlantListScreen(), // Initial screen to show the plant list
    );
  }
}
