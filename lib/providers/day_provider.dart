import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayProvider extends ChangeNotifier {
  late final String formattedDay;

  DayProvider() {
    final now = DateTime.now();
    final formatter = DateFormat.EEEE('es-MX');
    formattedDay = formatter.format(now);
  }
}
