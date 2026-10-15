import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app/additional_information_widget.dart';

import 'package:weather_app/weather_forecast_card_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {


  var url = Uri.https('099dfae245db6e3987fbdc5bca64f69f', '099dfae245db6e3987fbdc5bca64f69f');
  void refresh(){
    print(url);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(onTap:refresh,child: Icon(Icons.refresh)),
          ),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Column(
                          children: [
                            Text(
                              "300K",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 12),
                            Icon(Icons.cloud, size: 50),
                            SizedBox(height: 8),
                            Text("Rain"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15,),
              // weather forecast
              Text(
                "Weather Forecast",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 12,),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(

                  children: [
                    WeatherForecastCardWidget(temp: "301.17", icon: Icons.cloud, time: "09:00"),
                    WeatherForecastCardWidget(temp: "301.17", icon: Icons.cloud, time: "09:00"),
                    WeatherForecastCardWidget(temp: "301.17", icon: Icons.cloud, time: "09:00"),
                    WeatherForecastCardWidget(temp: "301.17", icon: Icons.cloud, time: "09:00"),
                    WeatherForecastCardWidget(temp: "301.17", icon: Icons.cloud, time: "09:00"),


                  ],

                ),
              ),

              SizedBox(height: 15,),
              Text(
                "Additional Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 12,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInformationWidget(icon: Icons.water_drop, condition: "Humidity", level: "94"),
                  AdditionalInformationWidget(icon: Icons.water_drop, condition: "Humidity", level: "94"),
                  AdditionalInformationWidget(icon: Icons.water_drop, condition: "Humidity", level: "94"),
                  AdditionalInformationWidget(icon: Icons.water_drop, condition: "Humidity", level: "94")
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
