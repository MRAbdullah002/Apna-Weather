import 'package:intl/intl.dart';

class Weathermodel {
  final String citiname;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String localtime;
  final double temperature;
  final double tempF;
  final bool isDayTime;
  final String maincondition;
  final String icon;
  final double windKph;
  final int humidity;
  final double uv;
  final double maxTempC;
  final double minTempC;
  final double avgTempC;
  final DateTime sunrise;
  final DateTime sunset;

  Weathermodel({
    required this.citiname,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.localtime,
    required this.temperature,
    required this.tempF,
    required this.isDayTime,
    required this.maincondition,
    required this.icon,
    required this.windKph,
    required this.humidity,
    required this.uv,
    required this.maxTempC,
    required this.minTempC,
    required this.avgTempC,
    required this.sunrise,
    required this.sunset,
  });

  /// ✅ Convert Object to JSON (Useful for Debugging)
  Map<String, dynamic> toJson() {
    return {
      "citiname": citiname,
      "region": region,
      "country": country,
      "lat": lat,
      "lon": lon,
      "localtime": localtime,
      "temperature": temperature,
      "tempF": tempF,
      "isDayTime": isDayTime,
      "maincondition": maincondition,
      "icon": icon,
      "windKph": windKph,
      "humidity": humidity,
      "uv": uv,
      "maxTempC": maxTempC,
      "minTempC": minTempC,
      "avgTempC": avgTempC,
      "sunrise": sunrise.toIso8601String(),
      "sunset": sunset.toIso8601String(),
    };
  }

  /// ✅ Convert JSON to `Weathermodel`
  factory Weathermodel.fromJson(Map<String, dynamic> json) {
    try {
      // Fetch sunrise & sunset safely
      String sunriseString = json['forecast']['forecastday'][0]['astro']['sunrise'] ?? "6:00 AM";
      String sunsetString = json['forecast']['forecastday'][0]['astro']['sunset'] ?? "6:00 PM";

      // Convert to DateTime safely
      DateTime sunrise = _parseTime(sunriseString);
      DateTime sunset = _parseTime(sunsetString);

      return Weathermodel(
        citiname: json['location']['name'] ?? 'Unknown City',
        region: json['location']['region'] ?? 'Unknown Region',
        country: json['location']['country'] ?? 'Unknown Country',
        lat: (json['location']['lat'] as num?)?.toDouble() ?? 0.0,
        lon: (json['location']['lon'] as num?)?.toDouble() ?? 0.0,
        localtime: json['location']['localtime'] ?? 'Unknown Time',
        temperature: (json['current']['temp_c'] as num?)?.toDouble() ?? 0.0,
        tempF: (json['current']['temp_f'] as num?)?.toDouble() ?? 0.0,
        isDayTime: json['current']['is_day'] == 1,
        maincondition: json['current']['condition']['text'] ?? 'Unknown',
        icon: json['current']['condition']['icon'] ?? '',
        windKph: (json['current']['wind_kmp'] as num?)?.toDouble() ?? 0.0,
        humidity: json['current']['humidity'] ?? 0,
        uv: (json['current']['uv'] as num?)?.toDouble() ?? 0.0,
        maxTempC: (json['forecast']['forecastday'][0]['day']['maxtemp_c'] as num?)?.toDouble() ?? 0.0,
        minTempC: (json['forecast']['forecastday'][0]['day']['mintemp_c'] as num?)?.toDouble() ?? 0.0,
        avgTempC: (json['forecast']['forecastday'][0]['day']['avgtemp_c'] as num?)?.toDouble() ?? 0.0,
        sunrise: sunrise,
        sunset: sunset,
      );
    } catch (e) {
      print("Error parsing weather JSON: $e");
      throw Exception("Failed to parse weather data");
    }
  }

  /// ✅ Helper Method to Parse Time Strings
  static DateTime _parseTime(String timeString) {
    final now = DateTime.now();
    final time = DateFormat('hh:mm a').parse(timeString);
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  /// ✅ Format Time
  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  /// ✅ Format Date
  String formatDate() {
    return DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
  }
}
