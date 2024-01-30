import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/controller/weather_controller.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WeatherController>(context, listen: false).fetchdata();
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/lottie/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/lottie/clody.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/lottie/rainy.json';
      case 'thunderstorm':
        return 'assets/lottie/thunder.json';
      case 'clear':
        return 'assets/lottie/sunny.json';
      default:
        return 'assets/lottie/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    var _weatherController = Provider.of<WeatherController>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 87, 87, 87),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 87, 87, 87),
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
      ),
      body: _weatherController.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const Icon(
                  //   Icons.sunny,
                  //   color: Colors.orange,
                  //   size: 42,
                  // ),
                  // Text(_weatherController.currentAddress ?? 'N/a'),
                  // Text(
                  //     '${(double.parse(_weatherController.weatherAppModel?.main?.temp.toString() ?? "0") - 273.15).toStringAsFixed(2)}°C'),
                  Text(_weatherController.currentAddress,
                      style: GoogleFonts.oswald(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )),
                  Opacity(
                    opacity: 0.8,
                    child: Container(
                      width: 300,
                      height: 200,
                      child: Lottie.asset(
                          getWeatherAnimation(_weatherController
                                  .weatherAppModel?.main
                                  .toString() ??
                              ''),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "${(double.parse(_weatherController.weatherAppModel?.main?.temp.toString() ?? "0") - 273.15).toStringAsFixed(2)}°C",
                        style: GoogleFonts.oswald(
                          fontSize: 50,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
