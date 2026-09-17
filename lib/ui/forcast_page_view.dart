// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, use_build_context_synchronously, deprecated_member_use, avoid_print, unnecessary_string_interpolations, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:climate_compass/model/model_weather.dart';
import 'package:climate_compass/model/model_weather_days6.dart';
import 'package:climate_compass/ui/home_page_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForcastPage extends StatefulWidget {
  final String city_name;

  const ForcastPage({Key? key, required this.city_name}) : super(key: key);

  @override
  State<ForcastPage> createState() => _ForcastPageState();
}

class _ForcastPageState extends State<ForcastPage>
    with SingleTickerProviderStateMixin {
  late final String city_name;
  var dio = Dio();
  var lat;
  var lon;
  IconData? iconApi;
  late Future<modelWeather> weatherDataModel;
  late StreamController<List<ModelData6Days>> weatherDataModelDays6;
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    city_name = widget.city_name;
    weatherDataModel = getDataWeather(city_name);
    weatherDataModelDays6 = StreamController<List<ModelData6Days>>();
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
              getDataDays();
              if (dataWeather!.description == "clear sky") {
                iconApi = CupertinoIcons.sun_max;
              } else if (dataWeather.description == "few clouds") {
                iconApi = CupertinoIcons.cloud_sun_fill;
              } else if (dataWeather.description == "scattered clouds") {
                iconApi = Icons.cloud;
              } else if (dataWeather.description == "broken clouds") {
                iconApi = Icons.cloud;
              } else if (dataWeather.description == "shower rain") {
                iconApi = Icons.cloudy_snowing;
              } else if (dataWeather.description == "rain") {
                iconApi = CupertinoIcons.cloud_sun_rain_fill;
              } else if (dataWeather.description == "thunderstorm") {
                iconApi = Icons.thunderstorm;
              } else if (dataWeather.description == "snow") {
                iconApi = CupertinoIcons.snow;
              } else {
                iconApi = Icons.sort_rounded;
              }
              return FadeTransition(
                opacity: _animation,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromARGB(255, 45, 30, 117),
                        Color.fromARGB(255, 186, 94, 198),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
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
                        const SizedBox(
                          height: 10,
                        ),
                        Icon(
                          iconApi,
                          size: 130,
                          color: Colors.white,
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
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 45, 30, 117),
                                Color.fromARGB(255, 186, 94, 198),
                              ],
                            ),
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
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 45, 30, 117),
                                Color.fromARGB(255, 186, 94, 198),
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Next Forcast",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 13,
                                ),
                                StreamBuilder(
                                  stream: weatherDataModelDays6.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var forcastDays6 = snapshot.data;
                                      return SizedBox(
                                        height: 150,
                                        child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: 6,
                                          itemBuilder: (context, pos) {
                                            return listItemDays6(
                                                forcastDays6![pos]);
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
                                  return const HomePageView();
                                },
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 45, 30, 117),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 11, top: 5, right: 11, bottom: 5),
                            child: Text(
                              "Home",
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

  Future<modelWeather> getDataWeather(String cityName) async {
    var apiKey = "19f2e25c30fda7647de152a3b7754b0e";

    var responce = await dio.get(
      "https://api.openweathermap.org/data/2.5/weather",
      queryParameters: {
        'q': cityName,
        'appid': apiKey,
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

  SizedBox listItemDays6(ModelData6Days modelData6Days) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            modelData6Days.dtTxt.substring(0, 10).toString(),
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Icon(Icons.cloud, size: 30, color: Colors.white),
          Row(
            children: [
              Text(
                modelData6Days.temp_max.round().toString() + '\u00B0',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(
                width: 7,
              ),
              Text(
                modelData6Days.temp_min.round().toString() + '\u00B0',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 149, 148, 148),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getDataDays() async {
    List<ModelData6Days> weather6DaysList = [];

    try {
      var responce = await dio.get(
        "https://api.codebazan.ir/weather/?city=ساری",
      );
      print(responce);

      for (var item = 0; item < responce.data['list'].length; item++) {
        var model = responce.data['list'][item];
        ModelData6Days modelData6Days = ModelData6Days(
          model['dt_txt'],
          model['weather'][0]['description'],
          model['main']['temp_min'],
          model['main']['temp_max'],
        );
        weather6DaysList.add(modelData6Days);
      }
      weatherDataModelDays6.add(weather6DaysList);
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
