// combined_zones_repository.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safezone/backend/models/map/combined_zone_model.dart';

class CombinedZonesRepository {
  final _apiUrl = "${dotenv.env['API_URL']}/map";

  Future<CombinedZonesResponse> getCombinedZones() async {
    final response = await http.get(Uri.parse('$_apiUrl/map-zones'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['success'] == true) {
        return CombinedZonesResponse.fromJson(data);
      } else {
        throw Exception(
            'API returned unsuccessful response: ${data['message'] ?? 'Unknown error'}');
      }
    } else {
      throw Exception(
          'Failed to load combined zones. Status code: ${response.statusCode}');
    }
  }
}
