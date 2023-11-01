import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static Future<Map<String, dynamic>> getData(String url) async {
    final uri = Uri.parse(url);
    final uriResponse = await http.get(uri);

    if (uriResponse.statusCode == 200) {
      return jsonDecode(uriResponse.body);
    } else {
      throw Exception('Falha ao baixar dados: ${uriResponse.statusCode}');
    }
  }
}
