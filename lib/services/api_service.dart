import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant_model.dart';

class ApiService {
 final String baseUrl = "http://192.168.67.124:3000";
 // Backend API base URL
  /// Fetches the list of plants from the backend API
  Future<List<Plant>> fetchPlants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/plants')).timeout(
        const Duration(seconds: 10), // Timeout after 10 seconds
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Plant.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load plants. Status code: ${response.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Error fetching plants: $e');
    }
  }
}
