import 'dart:convert';
import 'package:http/http.dart' as http;

class MapRepository {
  final String _baseUrl = 'http://157.253.124.26:8000';

  Future<List<dynamic>> fetchNearbyATMs({
    required double latitude,
    required double longitude,
    double radius = 1,
  }) async {
    final url = Uri.parse('$_baseUrl/atms/nearby?lat=$latitude&lon=$longitude&radius=$radius');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al cargar cajeros: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en MapRepository.fetchNearbyATMs: $e');
      return [];
    }
  }
}
