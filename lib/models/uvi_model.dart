import 'dart:convert';

class Uvi {
  double lat;
  double lon;
  DateTime dateIso;
  int date;
  double value;

  Uvi({
    required this.lat,
    required this.lon,
    required this.dateIso,
    required this.date,
    required this.value,
  });

  factory Uvi.fromJson(String str) => Uvi.fromMap(json.decode(str));

  factory Uvi.fromMap(Map<String, dynamic> json) {
    return Uvi(
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
      dateIso: DateTime.parse(json['date_iso'] ?? '1970-01-01T00:00:00Z'),
      date: json['date'] ?? 0,
      value: (json['value'] ?? 0).toDouble(),
    );
  }
}
