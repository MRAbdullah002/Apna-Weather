bool isError = true;
String getWeatherAnimation(dynamic weather) {
    if (weather?.maincondition == null) return 'assets/loading.json';

    String condition = weather!.maincondition.toLowerCase();
    bool isDay = weather!.isDayTime;

    print('Weather condition received: $condition, Is Day: $isDay');
    isError= true;

    if (condition.contains('sunny') ||
        condition.contains('clear') ||
        condition == 'day') {
      return isDay ? 'assets/sunny.json' : 'assets/night.json';
    } else if (condition.contains('partly cloudy')) {
      return isDay
          ? 'assets/partialcloudyday.json'
          : 'assets/partialcloudynight.json';
    } 
    else if (condition.contains('few cloudy')) {
      return isDay
          ? 'assets/partialcloudyday.json'
          : 'assets/partialcloudynight.json';
    } else if (condition.contains('cloudy') || condition.contains('overcast')) {
      return 'assets/clouds.json';
    } else if (condition.contains('mist') ||
        condition.contains('fog') ||
        condition.contains('freezing fog') ||
        condition.contains('haze')) {
      return 'assets/hazyshower.json';
    } else if (condition.contains('patchy rain')) {
      return isDay ? 'assets/sunnyrainy.json' : 'assets/night rain.json';
    }else if(condition.contains('light rain') ||
        condition.contains('moderate rain') ||
        condition.contains('heavy rain')){
      return 'assets/rain.json';
        }
    
     else if (condition.contains('rain shower') ||
        condition.contains('torrential rain shower')) {
      return 'assets/rainshower.json';
    } else if (condition.contains('freezing rain') ||
        condition.contains('drizzle') ||
        condition.contains('sleet')) {
      return 'assets/rain.json';
    } else if (condition.contains('snow') ||
        condition.contains('blowing snow') ||
        condition.contains('blizzard') ||
        condition.contains('ice pellets')) {
      return 'assets/snow.json';
    } else if (condition.contains('thunder') ||
        condition.contains('thundery outbreaks')) {
      return condition.contains('rain')
          ? 'assets/thunderrainy.json'
          : 'assets/thunder.json';
    }
    return 'assets/loading.json';
  }
