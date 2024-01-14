import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

String getWeatherAnimation(String? mainCondition) {
  if (mainCondition == null) return 'assets/sunny.json';

  switch (mainCondition.toLowerCase()) {
    case 'fog':
      return 'assets/cloud.json';
    case 'shower rain' || 'rain':
      return 'assets/rain.json';
    case 'thunderstorm':
      return 'assets/thunder.json';
    case 'clear':
      return 'assets/sunny.json';
    default:
      return 'assets/sunny.json';
  }
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('7f15aab53685a7e10ce0cd0f03a1f228');
  Weather? _weather;

  _fetchWeather() async {
    Location location = await _weatherService.getCurrentLocation();

    try {
      final weather = await _weatherService.getWeather(location);
      setState(() {
        _weather = weather;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(201, 28, 28, 0),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 96, bottom: 64),
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icLoc.png',
                    height: 20,
                    width: 20,
                    color: Color.fromARGB(255, 86, 86, 86)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_weather?.cityName ?? 'unknown',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color.fromARGB(255, 86, 86, 86))),
                ),
              ],
            ),
            Expanded(
                child:
                    Lottie.asset(getWeatherAnimation(_weather?.mainCondition))),
            Column(
              children: [
                Text(
                  '${_weather?.temperature.round()}°',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      color: Color.fromARGB(255, 86, 86, 86)),
                ),
                Text(
                  _weather?.mainCondition ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color.fromARGB(255, 86, 86, 86)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
