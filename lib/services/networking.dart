import 'dart:convert';

import 'package:http/http.dart' as http;

const kApiKrey = '52585d7924e48ab03d0eb14e749b703a';

class NetworkingClass {
  NetworkingClass(this.url);
  final String url;
  double tempurator;
  int condition;
  String cityName;

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    if (response.statusCode != 200) print('error');

    tempurator = data['main']['temp'];
    condition = data['weather'][0]['id'];
    cityName = data['name'];
  }
}
