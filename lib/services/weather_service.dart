import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class Location {
  late double longitude;
  late double latitude;
  late String? city;

  Location(
      {required this.latitude, required this.longitude, required this.city});
}

class WeatherService {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(Location location) async {
    final longitude = location.longitude;
    final latitude = location.latitude;
    final city = location.city ?? "";

    final response = await http.get(Uri.parse(
        '$baseUrl?lon=$longitude&lat=$latitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body), city);
    } else {
      throw Exception('failed to load weather data');
    }
  }

  Future<Location> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Location location = Location(
        latitude: position.latitude,
        longitude: position.longitude,
        city: placemarks[0].name);

    return location;
  }
}
