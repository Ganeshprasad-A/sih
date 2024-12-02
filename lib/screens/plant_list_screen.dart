import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant_model.dart';
import 'plant_detail_screen.dart';

class PlantListScreen extends StatefulWidget {
  const PlantListScreen({Key? key}) : super(key: key);

  @override
  _PlantListScreenState createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  late Future<List<Plant>> _plantsFuture;

  @override
  void initState() {
    super.initState();
    _plantsFuture = fetchPlants(); // Fetch plants on initialization
  }

  Future<List<Plant>> fetchPlants() async {
  const apiUrl = 'http://192.168.67.124:3000'; // Replace with your backend URL
  try {
    final response = await http.get(Uri.parse('$apiUrl/plants')).timeout(
      const Duration(seconds: 10), // Set a timeout for the request
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}'); // Debug log for response body
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Plant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load plants. Status Code: ${response.statusCode}');
    }
  } on Exception catch (e) {
    throw Exception('Error fetching plants: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medicinal Plants")),
      body: FutureBuilder<List<Plant>>(
        future: _plantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No plants available",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final plants = snapshot.data!;
          return ListView.builder(
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return ListTile(
                leading: Stack(
                  children: [
                    Image.network(
                      plant.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error), // Handle image loading errors
                    ),
                    if (plant.modelUrl.isNotEmpty)
                      const Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(Icons.threed_rotation, size: 16, color: Colors.green), // Indicator for 3D model
                      ),
                  ],
                ),
                title: Text(plant.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plant.botanicalName),
                    Row(
                      children: [
                        if (plant.audioUrl.isNotEmpty)
                          const Icon(Icons.audiotrack, size: 16, color: Colors.blue), // Indicator for audio
                        if (plant.videoUrl.isNotEmpty)
                          const Icon(Icons.videocam, size: 16, color: Colors.red), // Indicator for video
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantDetailScreen(plant: plant),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
