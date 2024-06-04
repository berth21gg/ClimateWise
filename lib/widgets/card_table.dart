import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/models.dart';

class CardTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: const [
        TableRow(
          children: [
            _SingleCard(
              color: Colors.red,
              icon: Icons.fireplace_outlined,
              text: 'Usa gorra',
              subtitle: 'La temperatura y el índice UV es alto.',
            ),
          ],
        ),
        TableRow(
          children: [
            _SingleCard(
              color: Colors.orange,
              icon: Icons.shield_outlined,
              text: 'Usa protector solar',
              subtitle:
                  'El índice UV es alto. Se recomienda uso de protector solar.',
            ),
          ],
        ),
        TableRow(
          children: [
            _SingleCard(
              color: Colors.blue,
              icon: Icons.water_drop_outlined,
              text: 'Hidrátate constantemente',
              subtitle:
                  'La húmedad es baja, por lo que se recomeinda hidratación constante.',
            ),
          ],
        ),
        TableRow(
          children: [
            _SingleCard(
              color: Colors.blueAccent,
              icon: Icons.house_outlined,
              text: 'Limita el tiempo al aire libre',
              subtitle:
                  'La larga exposición al aire libre puede causar quemaduras severas en la piel.',
            ),
          ],
        ),
      ],
    );
  }
}

List<_SingleCard> buildRecommendations(Clima weather, Uvi uvi) {
  List<_SingleCard> recommendations = [];

  // Dependiendo de los campos disponibles en el clima y la uvi, generamos recomendaciones
  if (weather.temp > 30 && DateTime.now().hour < 18) {
    recommendations.add(const _SingleCard(
      color: Colors.red,
      icon: Icons.fireplace_outlined,
      text: 'Usa gorra',
      subtitle: 'La temperatura y el índice UV es alto.',
    ));
  }
  if (uvi.value > 7 && DateTime.now().hour < 18) {
    recommendations.add(const _SingleCard(
      color: Colors.orange,
      icon: Icons.shield_outlined,
      text: 'Usa protector solar',
      subtitle:
          'El índice UV es alto. Se recomienda uso de protector solar cada dos horas.',
    ));
  }
  if (weather.humidity < 30) {
    recommendations.add(const _SingleCard(
      color: Colors.blue,
      icon: Icons.water_drop_outlined,
      text: 'Hidrátate constantemente',
      subtitle:
          'La húmedad es baja, por lo que se recomeinda hidratación constante.',
    ));
  }
  if (uvi.value > 7 && DateTime.now().hour < 18) {
    recommendations.add(const _SingleCard(
      color: Colors.blueAccent,
      icon: Icons.house_outlined,
      text: 'Limita el tiempo al aire libre',
      subtitle:
          'La larga exposición al aire libre puede causar quemaduras severas en la piel.',
    ));
  }

  return recommendations;
}

class _SingleCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String? subtitle;

  const _SingleCard({
    required this.icon,
    required this.color,
    required this.text,
    this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    final String subtitleText;
    (subtitle != '') ? subtitleText = subtitle! : subtitleText = '';
    return _CardBackground(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20,
            ),
            child: CircleAvatar(
              backgroundColor: color,
              radius: 30,
              child: Icon(
                icon,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Flexible(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    maxLines: 2,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    subtitleText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardBackground extends StatelessWidget {
  final Widget child;

  const _CardBackground({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(254, 254, 254, .65),
              borderRadius: BorderRadius.circular(20),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
