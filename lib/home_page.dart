import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/additional_information_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/weather_forecast_card_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<Map<String, dynamic>> weather;
  String cityName = "Delhi";
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _popularCities = [
    "Delhi",
    "Mumbai",
    "Bengaluru",
    "Kolkata",
    "Chennai",
    "Hyderabad",
    "London",
    "New York",
  ];

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateCity(String newCity) {
    if (newCity.trim().isEmpty) return;
    setState(() {
      cityName = newCity.trim();
      weather = getCurrentWeather();
      _isSearching = false;
      _searchController.clear();
    });
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ??
          const String.fromEnvironment('OPENWEATHER_API_KEY');

      if (apiKey.isEmpty) {
        throw 'API key not found. Please set OPENWEATHER_API_KEY in your .env file.';
      }

      final query = Uri.encodeComponent(cityName);
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$query&APPID=$apiKey",
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200' && data['cod'] != 200) {
        throw data['message'] ?? 'City not found or failed to load';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  IconData getWeatherIcon(String sky) {
    switch (sky.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.water_drop;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.cloud;
    }
  }

  String formatTime(String dtTxt) {
    try {
      final time = DateTime.parse(dtTxt);
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (_) {
      return dtTxt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search city (e.g. Delhi, Mumbai)...",
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _updateCity,
              )
            : Text(
                cityName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
        actions: [
          if (_isSearching) ...[
            IconButton(
              onPressed: () => _updateCity(_searchController.text),
              icon: const Icon(Icons.check),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
              icon: const Icon(Icons.close),
            ),
          ] else ...[
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ],
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              weather = getCurrentWeather();
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () => _updateCity("Delhi"),
                          child: const Text('Reset to Delhi'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final resolvedCityName = data['city']['name'] ?? cityName;
          final countryCode = data['city']['country'] ?? '';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick city selector chips
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _popularCities.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final city = _popularCities[index];
                        final isSelected = cityName.toLowerCase() == city.toLowerCase() ||
                            resolvedCityName.toString().toLowerCase() == city.toLowerCase();

                        return ChoiceChip(
                          label: Text(city),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              _updateCity(city);
                            }
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Location indicator
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blueAccent, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        countryCode.isNotEmpty
                            ? "$resolvedCityName, $countryCode"
                            : resolvedCityName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Main weather card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "$currentTemp K",
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Icon(
                                  getWeatherIcon(currentSky),
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentSky,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Weather forecast title
                  const Text(
                    "Hourly Forecast",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Hourly forecast list
                  SizedBox(
                    height: 125,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        final hourlySky = hourlyForecast['weather'][0]['main'];
                        final hourlyTemp = hourlyForecast['main']['temp'].toString();
                        final timeStr = hourlyForecast['dt_txt'].toString();

                        return WeatherForecastCardWidget(
                          time: formatTime(timeStr),
                          icon: getWeatherIcon(hourlySky),
                          temp: "$hourlyTemp K",
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Additional information title
                  const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Additional information row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInformationWidget(
                        icon: Icons.water_drop,
                        condition: "Humidity",
                        level: "$currentHumidity%",
                      ),
                      AdditionalInformationWidget(
                        icon: Icons.air,
                        condition: "Wind Speed",
                        level: "$currentWindSpeed",
                      ),
                      AdditionalInformationWidget(
                        icon: Icons.beach_access,
                        condition: "Pressure",
                        level: "$currentPressure",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
