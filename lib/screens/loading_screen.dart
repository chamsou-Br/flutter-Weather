import 'package:flutter/material.dart';
import 'package:weather/screens/location_screen.dart';
import 'package:weather/services/location.dart';
import 'package:weather/services/networking.dart';

const kApiKrey = '52585d7924e48ab03d0eb14e749b703a';
const api =
    'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double longitude;
  double latitude;
  double tempurator;
  int condition;
  String cityName;

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocationData();
    });
  }

  void getLocationData() async {
    LocationClass locationdata = LocationClass();
    await locationdata.getPosition();
    longitude = locationdata.longitude;
    latitude = locationdata.latitude;
    NetworkingClass networking = NetworkingClass(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$kApiKrey');
    await networking.fetchData();
    tempurator = networking.tempurator;
    condition = networking.condition;
    cityName = networking.cityName;
    print('$tempurator');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
        tempurator: tempurator,
        condition: condition,
        cityName: cityName,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
