import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimal_weatherapp/model/weathermodel.dart';

class WeatherProvider extends StateNotifier<AsyncValue<Weathermodel>>{


  WeatherProvider(): super(AsyncValue.loading()){
       fetchWeather();
  }
Future<void>fetchWeather() async{
  state = AsyncValue.loading();
  try {
    
    
  } catch (e) {
    
  }
}


}