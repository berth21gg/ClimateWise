import 'package:flutter/material.dart';
import 'package:climate_wise/models/paciente_model.dart';

class PageTitle extends StatelessWidget {
  final PacienteModel paciente;
  const PageTitle({
    super.key,
    required this.paciente,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola ${paciente.nombre}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Estas recomendaciones han sido basadas en los datos que nos ha proporcionado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
