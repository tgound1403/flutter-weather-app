import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'city_screen.dart';
import 'package:clima/services/weather.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
  LocationScreen({this.locationWeather});
  final locationWeather;
}

class _LocationScreenState extends State<LocationScreen> {
  int conditionNumber;
  int temperature;
  String cityName;

  WeatherModel weatherModel = new WeatherModel();
  String message;
  String weatherIcon;

  void initState(){
    super.initState();
    updateUI(widget.locationWeather);
  }
  void updateUI(dynamic weatherData){
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        message = "";
        weatherIcon = "Error";
        cityName ="";
        return;
      }
      else {
        conditionNumber = weatherData['weather'][0]['id'];
        double temp = weatherData['main']['temp'];
        temperature = temp.toInt();
        cityName = weatherData['name'];
        message = weatherModel.getMessage(temperature);
        weatherIcon =weatherModel.getWeatherIcon(conditionNumber);
      }

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
                    onPressed: () async {
                       var weatherData = await weatherModel.getLocationWeather();
                       updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
    var typedName = await Navigator.push(context, MaterialPageRoute(builder: (context){ return CityScreen();}),);
    if( typedName != null ) {
    var weatherData = await weatherModel.getCityWeather(typedName);
    updateUI(weatherData);
    };
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
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$message in $cityName!",
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
