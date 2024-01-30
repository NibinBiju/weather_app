import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class WeatherController with ChangeNotifier {
  WeatherAppModel? weatherAppModel;
  bool isLoading = false;
  double latitude = 0;
  double longitude = 0;
  Position? currentPosition;
  String currentAddress = '';

  fetchdata() async {
    await getCurrentLocation();
    await getAddress();
    isLoading = true;
    var uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=236cd43a1cdafc62daf7a1e13d2ca628');
    var response = await http.get(uri);

    print(response.statusCode);
    print(response.body);
    try {
      var Jsondata = jsonDecode(response.body);
      weatherAppModel = WeatherAppModel.fromJson(Jsondata);
    } catch (e) {
      print(e);
    }
    isLoading = false;

    notifyListeners();
  }

  // Future<void> getCurrentLocation() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     permission = await Geolocator.requestPermission();
  //     LocationPermission ask = await Geolocator.requestPermission();
  //   } else {
  //     Position _currentPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.best,
  //     );
  //     latitude = _currentPosition.altitude;
  //     longitude = _currentPosition.longitude;
  //     currentPosition = _currentPosition;
  //   }
  // }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      } else {
        Position _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        currentPosition = _currentPosition;
        print('$latitude, $longitude');
      }
    } catch (e) {
      print("Error getting current position: $e");
      // Handle the error gracefully
    }
  }

  Future<void> getAddress() async {
    try {
      List<Placemark> placemark =
          await placemarkFromCoordinates(latitude, longitude);

      Placemark place = placemark[0];

      currentAddress = '${place.locality},${place.country}';
    } catch (e) {
      print(e);
    }
  }
}
