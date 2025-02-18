import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:minimal_weatherapp/model/weathermodel.dart';

class Weatherservices {
  static const BASE_URL = 'http://api.weatherapi.com/v1';
  final String apikey;

  Weatherservices(this.apikey);

  /// Fetch weather using **current GPS location**
  Future<Weathermodel> getWeatherByLocation() async {
    Position position = await _determinePosition(); // Get location
    String locationQuery = '${position.latitude},${position.longitude}'; // Format as "latitude,longitude"

    final url = '$BASE_URL/forecast.json?key=$apikey&q=$locationQuery&days=1&aqi=no&alerts=no';
    
    print("Fetching weather from: $url"); // Debugging URL

    final response = await http.get(Uri.parse(url));

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}"); // Print full API response

    if (response.statusCode == 200) {
      return Weathermodel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error fetching weather data: ${response.body}');
    }
  }

  /// Fetch city name from GPS location
  Future<String> getCurrentCity() async {
    Position position = await _determinePosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    return placemarks[0].locality ?? "Unknown City";
  }

  /// Request GPS permission & fetch location
  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
