import 'package:flutter/material.dart';
import 'package:weather/services/weather.dart';
import 'package:weather/utitlities/constants.dart';
import 'package:weather/services/location.dart';
import 'package:weather/services/networking.dart';
import 'package:weather/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.tempurator, this.condition, this.cityName});
  final double tempurator;
  final int condition;
  final String cityName;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double tempurator;
  int condition;
  String cityName;
  String noteWeather;
  String iconWeather;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tempurator = widget.tempurator;
    condition = widget.condition;
    cityName = widget.cityName;
    iconWeather = WeatherModel().getWeatherIcon(condition);
    noteWeather = WeatherModel().getMessage((tempurator - 273.15).toInt());
  }

  void getLocationData() async {
    LocationClass locationdata = LocationClass();
    await locationdata.getPosition();
    double longitude = locationdata.longitude;
    double latitude = locationdata.latitude;
    NetworkingClass networking = NetworkingClass(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$kApiKrey');
    await networking.fetchData();
    tempurator = networking.tempurator;
    condition = networking.condition;
    cityName = networking.cityName;
    iconWeather = WeatherModel().getWeatherIcon(condition);
    noteWeather = WeatherModel().getMessage((tempurator - 273.15).toInt());
  }

  void getLocationDataPay(var city) async {
    NetworkingClass networking = NetworkingClass(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$kApiKrey');
    await networking.fetchData();
    tempurator = networking.tempurator;
    condition = networking.condition;
    cityName = networking.cityName;
    print(cityName);
    setState(() {
      iconWeather = WeatherModel().getWeatherIcon(condition);
      noteWeather = WeatherModel().getMessage((tempurator - 273.15).toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        getLocationData();
                      });
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var name = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));
                      print(name);
                      if (name != null) {
                        setState(() {
                          print(name);
                          getLocationDataPay(name);
                        });
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${(tempurator - 273.15).toInt()}°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$iconWeather',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$noteWeather $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
