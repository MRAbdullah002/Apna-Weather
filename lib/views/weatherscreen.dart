import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:minimal_weatherapp/model/weathermodel.dart';
import 'package:minimal_weatherapp/services/weatherservices.dart';
import 'package:minimal_weatherapp/utils/formattedtime.dart';
import 'package:minimal_weatherapp/utils/weatheranimation.dart';

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, AsyncValue<Weathermodel?>>(
  (ref) {
    return WeatherNotifier();
  },
);

class WeatherNotifier extends StateNotifier<AsyncValue<Weathermodel?>> {
  WeatherNotifier() : super(const AsyncValue.loading()) {
    fetchWeather();
  }

  final _weatherServices = Weatherservices('49865ee2a9314dec92e121246251902');

  Future<void> fetchWeather() async {
    state = const AsyncValue.loading();
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        state = AsyncValue.error(
            '⚠ No internet connection. Please check your network.',
            StackTrace.current);
        return;
      }
      Weathermodel fetchedWeather =
          await _weatherServices.getWeatherByLocation();
      state = AsyncValue.data(fetchedWeather);
    } catch (e, stackTrace) {
      state = AsyncValue.error(
          '❌ Failed to fetch weather data. Please try again later.',
          stackTrace);
    }
  }
}

class MyWeatherScreen extends ConsumerWidget {
  const MyWeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Weather', style: GoogleFonts.oxanium(fontSize: 34)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: weatherState.when(
          loading: () => Lottie.asset('assets/loading.json'),
          error: (error, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.oxanium(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    ref.read(weatherProvider.notifier).fetchWeather(),
                child: Text('Retry'),
              ),
            ],
          ),
          data: (weather) => weather == null
              ? Text('No weather data available')
              : SingleChildScrollView(
                  child: StreamBuilder(
                    stream: ref.read(weatherProvider.notifier).stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            FormattedTime.getFormattedDate(),
                            style: GoogleFonts.oxanium(
                                fontSize: 18, fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${weather.region}, ${weather.citiname}',
                            style: GoogleFonts.oxanium(
                                fontSize: 35, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 20),
                          Lottie.asset(getWeatherAnimation(weather)),
                          Text(
                            weather.maincondition,
                            style: GoogleFonts.oxanium(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            // ignore: unnecessary_null_comparison
                            weather.temperature != null
                                ? '${weather.temperature.round()} °C'
                                : 'N/A',
                            style: GoogleFonts.oxanium(
                                fontSize: 30, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Text(
                                '🌅 Sunrise: ${FormattedTime.formatTime(weather.sunrise)}',
                                style: GoogleFonts.oxanium(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '🌇 Sunset: ${FormattedTime.formatTime(weather.sunset)}',
                                style: GoogleFonts.oxanium(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      );
                    },
                  ),
                ),
        ),
      ),
      floatingActionButton: weatherState.hasValue
          ? SizedBox(
              height: mq.height * 0.06,
              width: mq.width * 0.30,
              child: FloatingActionButton(
                onPressed: () =>
                    ref.read(weatherProvider.notifier).fetchWeather(),
                backgroundColor: const Color.fromARGB(255, 133, 173, 243),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Refresh', style: GoogleFonts.oxanium(fontSize: 16)),
                    SizedBox(width: 5),
                    Icon(Icons.refresh, size: mq.height * .02),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
