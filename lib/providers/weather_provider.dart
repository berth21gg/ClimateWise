import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:climate_wise/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WeatherProvider extends ChangeNotifier {
  final String _baseUrl = 'api.openweathermap.org';
  final String _apiKey = '3d16098103ec59a3bde073774be3967e';
  Clima actualClima = Clima(
    temp: 0.0,
    feelsLike: 0.0,
    tempMin: 0.0,
    tempMax: 0.0,
    pressure: 0,
    humidity: 0,
    seaLevel: 0,
    grndLevel: 0,
  );
  Uvi uviActual = Uvi(
    lat: 0.0,
    lon: 0.0,
    dateIso: DateTime.now(),
    date: 0,
    value: 0.0,
  );

  WeatherProvider() {
    getCurrentLocation();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si los servicios de localización están habilitados.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Los servicios de localización no están habilitados, no podemos continuar.
      return Future.error(
          'Los servicios de localización están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Los permisos están denegados, no podemos continuar.
        return Future.error('Los permisos de localización están denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Los permisos están denegados para siempre, no podemos continuar.
      return Future.error(
          'Los permisos de localización están denegados permanentemente.');
    }

    // Cuando llegamos a este punto, los permisos están garantizados y podemos obtener la localización.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      getClimaActual(position.latitude, position.longitude);
      getUviActual(position.latitude, position.longitude);
    } catch (e) {
      print(e);
    }
  }

  Future<String> getJsonData(String endpoint, double lat, double lon) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'units': 'metric',
      'appid': _apiKey,
    });
    var response = await http.get(url);
    print(response.body);
    return response.body;
  }

  getUviActual(double lat, double lon) async {
    final jsonData = await getJsonData('/data/2.5/uvi', lat, lon);
    final uvi = Uvi.fromJson(jsonData);
    uviActual = uvi;
    notifyListeners();
  }

  Future getClimaActual(double lat, double lon) async {
    final jsonData = await getJsonData('/data/2.5/weather', lat, lon);
    final clima = Clima.fromJson(jsonData);
    actualClima = clima;
    notifyListeners();
  }
}
