import 'dart:ui';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:weather_app/ScrollCard.dart';
import 'package:http/http.dart' as http;
import 'secrets.dart' as apikey;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getWeatherData() async {
    String cityName = 'London';
    String countryName = 'uk';

    try {
      var url = Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName,$countryName&APPID=${apikey.apiKey}');
      var response = await http.get(url);

      // if everything is alright then create a data
      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        return data;
      } else {
        throw 'Oops!... Something went wrong';
      }
    } catch (e) {
      throw e.toString();
    }
    //return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Coolest Weather Application',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getWeatherData;
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
          future: getWeatherData(),
          builder: (context, snapshot) {
            // if the data is fetching from the api then shoiwng the progression circle
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            // if there is some error then showing the error message
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }
            // getting result in buil function

            final data = snapshot.data!;
            final currentTemperature = data['list'][0]['main']['temp'];
            final currentSky = data['list'][1]['weather'][0]['main'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(children: [
                              Text(
                                '$currentTemperature F',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 70,
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              Text(
                                '$currentSky',
                                style: const TextStyle(fontSize: 20),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Weather forecast cards
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Weather Forecast',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  // Horizontal Scrollable Cards
                  SizedBox(
                    height: 150, // remember bro listview always need hight
                    child: ListView.builder(
                        itemCount: 30,
                        itemBuilder: (context, index) {
                          // variable declarations
                          final hourlyForecast = data['list'][index + 1];
                          final unixTimestamp =
                              hourlyForecast['dt']; // Example: 1732417200
                          final DateTime dateTime =
                              DateTime.fromMillisecondsSinceEpoch(
                                  unixTimestamp * 1000);
                          final String time =
                              DateFormat('HH:mm').format(dateTime);
                          final icons =
                              data['list'][index + 1]['weather'][0]['main'];
                          final temperature = hourlyForecast['main']['temp'];

                          //String time = '123';
                          return ScrollCard(
                            weatherIcon: icons == 'Clouds' || icons == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            weatherTemperature: temperature,
                            weatherTime: time,
                          );
                        },
                        padding: const EdgeInsets.all(5),
                        scrollDirection: Axis.horizontal),
                  ),

                  // Additional information
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AddInfoCard(
                        time: '123',
                        icon: Icons.water_drop,
                        weatherCondition: 'Humidity',
                      ),
                      AddInfoCard(
                        time: '324',
                        icon: Icons.umbrella,
                        weatherCondition: 'Rain',
                      ),
                      AddInfoCard(
                        time: '242',
                        icon: Icons.ramen_dining,
                        weatherCondition: 'Strom',
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

// additional information card
class AddInfoCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String weatherCondition;

  const AddInfoCard({
    super.key,
    required this.time,
    required this.icon,
    required this.weatherCondition,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
        ),
        Text(
          weatherCondition,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          time,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
