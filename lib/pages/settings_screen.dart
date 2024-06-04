import 'package:flutter/material.dart';
import 'package:climate_wise/providers/db_provider.dart';
import '../models/models.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actualización de datos"),
      ),
      body: Center(
        child: _HomeBody(),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<PacienteModel?> pacienteFuture =
        DBProvider.db.getPacienteById(1);

    return FutureBuilder<PacienteModel?>(
      future: pacienteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró el paciente'));
        } else {
          final paciente = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                RegisterPage(paciente: paciente),
              ],
            ),
          );
        }
      },
    );
  }
}

class RegisterPage extends StatefulWidget {
  final PacienteModel paciente;

  const RegisterPage({
    super.key,
    required this.paciente,
  });

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  late Map<String, String> formValues;
  late TextEditingController nombreController;
  late TextEditingController pApellidoController;
  late TextEditingController sApellidoController;
  late TextEditingController edadController;
  late TextEditingController pesoController;

  @override
  void initState() {
    super.initState();
    formValues = {
      'id': widget.paciente.id.toString(),
      'nombre': widget.paciente.nombre,
      'p_apellido': widget.paciente.pApellido,
      's_apellido': widget.paciente.sApellido,
      'edad': widget.paciente.edad.toString(),
      'peso': widget.paciente.peso.toString(),
      'actividad': widget.paciente.actividad.toString(),
    };
    nombreController = TextEditingController(text: widget.paciente.nombre);
    pApellidoController =
        TextEditingController(text: widget.paciente.pApellido);
    sApellidoController =
        TextEditingController(text: widget.paciente.sApellido);
    edadController =
        TextEditingController(text: widget.paciente.edad.toString());
    pesoController =
        TextEditingController(text: widget.paciente.peso.toString());
  }

  @override
  void dispose() {
    nombreController.dispose();
    pApellidoController.dispose();
    sApellidoController.dispose();
    edadController.dispose();
    pesoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffffffff),
            Color(0xfffcedcc),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 100,
          ),
          child: Form(
            key: myFormKey,
            child: Column(
              children: [
                CustomInputField(
                  controller: nombreController,
                  formProperty: 'nombre',
                  formValues: formValues,
                  hintText: 'Ingrese su Nombre',
                  labelText: 'Nombre',
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  controller: pApellidoController,
                  formProperty: 'p_apellido',
                  formValues: formValues,
                  hintText: 'Ingrese su Primer Apellido',
                  labelText: 'Primer Apellido',
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  controller: sApellidoController,
                  formProperty: 's_apellido',
                  formValues: formValues,
                  hintText: 'Ingrese su Segundo Apellido',
                  labelText: 'Segundo Apellido',
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  controller: edadController,
                  formProperty: 'edad',
                  formValues: formValues,
                  hintText: 'Ingrese su Edad',
                  labelText: 'Edad',
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  controller: pesoController,
                  formProperty: 'peso',
                  formValues: formValues,
                  hintText: 'Ingrese su Peso',
                  labelText: 'Peso',
                ),
                const SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  value: formValues['actividad'],
                  style: const TextStyle(color: Colors.black),
                  dropdownColor: Colors.white,
                  focusColor: Colors.red,
                  items: const [
                    DropdownMenuItem(
                      value: '1',
                      child: Text('Nula'),
                    ),
                    DropdownMenuItem(
                      value: '2',
                      child: Text('Intermitente'),
                    ),
                    DropdownMenuItem(
                      value: '3',
                      child: Text('Constante'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      formValues['actividad'] = value ?? '1';
                    });
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (!myFormKey.currentState!.validate()) {
                      print("Formulario no válido");
                      return;
                    }

                    print(formValues);
                    final nuevoPaciente = PacienteModel(
                      id: widget.paciente.id,
                      nombre: formValues['nombre']!,
                      pApellido: formValues['p_apellido']!,
                      sApellido: formValues['s_apellido']!,
                      edad: int.parse(formValues['edad']!),
                      peso: double.parse(formValues['peso']!),
                      actividad: int.parse(formValues['actividad']!),
                    );
                    await DBProvider.db.updatePaciente(nuevoPaciente);
                    Navigator.pushReplacementNamed(context, 'ScrollDesign');
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String formProperty;
  final Map<String, String> formValues;

  const CustomInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    required this.formValues,
    required this.formProperty,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: Colors.black),
      onChanged: (value) {
        formValues[formProperty] = value;
      },
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        hintStyle: const TextStyle(color: Colors.black26),
        floatingLabelStyle: const TextStyle(color: Color(0xff068a50)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff068a50)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff068a50)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
