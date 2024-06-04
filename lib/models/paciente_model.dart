import 'dart:convert';

PacienteModel pacienteModelFromJson(String str) =>
    PacienteModel.fromJson(json.decode(str));

String pacienteModelToJson(PacienteModel data) => json.encode(data.toJson());

class PacienteModel {
  int? id;
  String nombre;
  String pApellido;
  String sApellido;
  double peso;
  int edad;
  int actividad;

  PacienteModel({
    this.id,
    required this.nombre,
    required this.pApellido,
    required this.sApellido,
    required this.peso,
    required this.edad,
    required this.actividad,
  });

  factory PacienteModel.fromJson(Map<String, dynamic> json) => PacienteModel(
        id: json["id"],
        nombre: json["nombre"],
        pApellido: json["p_apellido"],
        sApellido: json["s_apellido"],
        edad: json["edad"],
        peso: json["peso"]?.toDouble(),
        actividad: json["actividad"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "p_apellido": pApellido,
        "s_apellido": sApellido,
        "edad": edad,
        "peso": peso,
        "actividad": actividad,
      };
}
