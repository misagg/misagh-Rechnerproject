// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, non_constant_identifier_names, camel_case_types, deprecated_member_use, use_build_context_synchronously, avoid_print, unnecessary_string_interpolations, prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:climate_compass/model/model_weather.dart';
import 'package:climate_compass/model/model_weather_days.dart';
import 'package:climate_compass/ui/forcast_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with SingleTickerProviderStateMixin {
  var dio = Dio();
  var city_name = "Tehran";
  var lat;
  var lon;
  late String imagetop;
  late Future<modelWeather> weatherDataModel;
  late StreamController<List<Model_Weather_Days>> weatherDataModelDays;
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    weatherDataModel = getDataWeather();
    weatherDataModelDays = StreamController<List<Model_Weather_Days>>();
    _animationController = AnimationController(
        duration: const Duration(seconds: 2), vsync: this, value: 0);
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: weatherDataModel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var dataWeather = snapshot.data;
              hourlyForecast(context, lat, lon);

              if (dataWeather!.description == "clear sky") {
                imagetop = "assets/images/sun.png";
              } else if (dataWeather.description == "few clouds") {
                imagetop = "assets/images/cloudy_day.png";
              } else if (dataWeather.description == "scattered clouds") {
                imagetop = "assets/images/cloud.png";
              } else if (dataWeather.description == "broken clouds") {
                imagetop = "assets/images/cloud.png";
              } else if (dataWeather.description == "shower rain") {
                imagetop = "assets/images/raning.png";
              } else if (dataWeather.description == "rain") {
                imagetop = "assets/images/cloud_sun_rain_fill.png";
              } else if (dataWeather.description == "thunderstorm") {
                imagetop = "assets/images/thunder.png";
              } else if (dataWeather.description == "snow") {
                imagetop = "assets/images/snow.png";
              } else {
                imagetop = "assets/images/sort_rounded.png";
              }

              return FadeTransition(
                opacity: _animation,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/night.png"),
                        fit: BoxFit.cover),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 27,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "$city_name",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                            const Text(
                              "Misagh Azimpoor",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          "$imagetop",
                          width: 100,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          dataWeather.temp.round().toString() + "\u00B0",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 55),
                        ),
                        Text(
                          dataWeather.description,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Max : " +
                                  dataWeather.temp_max.round().toString() +
                                  "\u00B0",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Min : " +
                                  dataWeather.temp_min.round().toString() +
                                  '\u00B0',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 340,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(83, 71, 160, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.rectangle_split_3x3_fill,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "6%",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.thermometer,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    dataWeather.humidity.toString() + "%",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.wind,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    dataWeather.speed.toString() + "km/h",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 340,
                          height: 210,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(83, 71, 160, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Today",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Février,12',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  child:
                                      StreamBuilder<List<Model_Weather_Days>>(
                                    stream: weatherDataModelDays.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var forcastDays = snapshot.data;

                                        return SizedBox(
                                          height: 140, // ارتفاع دلخواه
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            reverse: true,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 8,
                                            itemBuilder: (context, pos) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                ),
                                                child:
                                                    listItem(forcastDays![pos]),
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ForcastPage(
                                    city_name: city_name,
                                  );
                                },
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(83, 71, 160, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 11, top: 5, right: 11, bottom: 5),
                            child: Text(
                              "Next Forcast",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Image SetImageForMain(Model_Weather_Days model) {
    String descrption = model.desxrption;

    if (descrption == "clear sky") {
      return Image.asset(
        "assets/images/sun.png",
        width: 45,
      );
    } else if (descrption == "few clouds") {
      return Image.asset(
        "assets/images/cloudy_day.png",
        width: 45,
      );
    } else if (descrption == "scattered clouds") {
      return Image.asset(
        "assets/images/cloud.png",
        width: 45,
      );
    } else if (descrption == "broken clouds") {
      return Image.asset(
        "assets/images/cloud.png",
        width: 45,
      );
    } else if (descrption == "shower rain") {
      return Image.asset(
        "assets/images/raning.png",
        width: 45,
      );
    } else if (descrption == "rain") {
      return Image.asset(
        "assets/images/cloud_sun_rain_fill.png",
        width: 45,
      );
    } else if (descrption == "thunderstorm") {
      return Image.asset(
        "assets/images/thunder.png",
        width: 45,
      );
    } else if (descrption == "snow") {
      return Image.asset(
        "assets/images/snow.png",
        width: 45,
      );
    } else {
      return Image.asset(
        "assets/images/sort_rounded.png",
        width: 45,
      );
    }
  }

  SizedBox listItem(Model_Weather_Days forcastDays) {
    return SizedBox(
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            forcastDays.temp.round().toString() + "\u00B0" + "C",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          SetImageForMain(forcastDays),
          Text(
            forcastDays.time.substring(11, 16),
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<modelWeather> getDataWeather() async {
    var api_key = "19f2e25c30fda7647de152a3b7754b0e";

    var responce = await dio.get(
      "https://api.openweathermap.org/data/2.5/weather",
      queryParameters: {
        'q': city_name,
        'appid': api_key,
        'units': 'metric',
      },
    );
    lat = responce.data["coord"]["lat"];
    lon = responce.data["coord"]["lon"];
    var dataModel = modelWeather(
      responce.data["coord"]["lon"],
      responce.data["coord"]["lat"],
      responce.data["weather"][0]["main"],
      responce.data["weather"][0]["description"],
      responce.data["main"]["temp"],
      responce.data["main"]["temp_min"],
      responce.data["main"]["temp_max"],
      responce.data["main"]["humidity"],
      responce.data["wind"]["speed"],
      responce.data["dt"],
    );

    return dataModel;
  }

  void hourlyForecast(BuildContext context, lat, lon) async {
    var api_key = "19f2e25c30fda7647de152a3b7754b0e";

    List<Model_Weather_Days> weatherList = [];

    try {
      var responce = await dio.get(
        "https://api.openweathermap.org/data/2.5/forecast",
        queryParameters: {
          "appid": api_key,
          'lat': lat,
          'lon': lon,
          'cnt': 8,
          'units': 'metric',
        },
      );

      // String dateTimeString = responce.data['dt_txt'];
      // DateTime dateTime = DateTime.parse(dateTimeString);
      // String time = DateFormat.Hm().format(dateTime);

      for (var item = 0; item < responce.data['list'].length; item++) {
        var model = responce.data['list'][item];
        Model_Weather_Days model_weather_days = Model_Weather_Days(
          model['main']['temp'],
          model['dt_txt'],
          model['weather'][0]['description'],
        );
        weatherList.add(model_weather_days);
      }

      weatherDataModelDays.add(weatherList);
    } on DioError catch (e) {
      print(e.response!.statusCode);
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("there is on"),
        ),
      );
    }
  }
}
