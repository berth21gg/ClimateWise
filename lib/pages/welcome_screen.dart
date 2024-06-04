import 'package:flutter/material.dart';
import 'package:climate_wise/models/paciente_model.dart';
import 'package:climate_wise/providers/db_provider.dart';
import 'package:get/get.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    DBProvider.db.database;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 1);
              });
            },
            children: const [
              WelcomePage(),
              RegisterPage(),
            ],
          ),
          Container(
            alignment: const Alignment(0, .75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                onLastPage
                    ? Container()
                    : SmoothPageIndicator(
                        controller: _controller,
                        count: 2,
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xfffcedcc),
            Color(0xffffffff),
          ],
        ),
      ),
      child: const SafeArea(
        minimum: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
        // ignore: unnecessary_const
        child: const Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              maxRadius: 70,
              backgroundColor: Color(0xffe33f36),
              child: Icon(
                Icons.fireplace_outlined,
                color: Colors.white,
                size: 70,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Protégete de los cambios climáticos y evita tener\n malos ratos.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff000000),
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            )
          ],
        )),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
    final Map<String, String> formValues = {
      'nombre': 'nombre',
      'p_apellido': 'p_apellido',
      's_apellido': 's_apellido',
      'edad': 'edad',
      'peso': 'peso',
      'actividad': 'actividad',
    };
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
                  formProperty: 'nombre',
                  formValues: formValues,
                  hintText: 'Ingrese su Nombre',
                  labelText: 'Nombre',
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomInputField(
                  formProperty: 'p_apellido',
                  formValues: formValues,
                  hintText: 'Ingrese su Primer Apellido',
                  labelText: 'Primer Apellido',
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomInputField(
                  formProperty: 's_apellido',
                  formValues: formValues,
                  hintText: 'Ingrese su Segundo Apellido',
                  labelText: 'Segundo Apellido',
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomInputField(
                  formProperty: 'edad',
                  formValues: formValues,
                  hintText: 'Ingrese su Edad',
                  labelText: 'Edad',
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomInputField(
                  formProperty: 'peso',
                  formValues: formValues,
                  hintText: 'Ingrese su Peso',
                  labelText: 'Peso',
                ),
                const SizedBox(
                  height: 30,
                ),
                DropdownButtonFormField(
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
                    formValues['actividad'] = value ?? '1';
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: const ButtonStyle(),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (!myFormKey.currentState!.validate()) {
                      print("Formulario no válido");
                      return;
                    }
                    // Guardar datos del formulario
                    print(formValues);
                    final nuevoPaciente = PacienteModel(
                      nombre: formValues['nombre']!,
                      pApellido: formValues['p_apellido']!,
                      sApellido: formValues['s_apellido']!,
                      edad: int.parse(formValues['edad']!),
                      peso: double.parse(formValues['peso']!),
                      actividad: int.parse(formValues['actividad']!),
                    );
                    await DBProvider.db.nuevoPaciente(nuevoPaciente);
                    Get.offNamed('ScrollDesign');
                    //Navigator.pushReplacementNamed(context, 'ScrollDesign');
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
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String formProperty;
  final Map<String, String> formValues;
  const CustomInputField({
    super.key,
    this.hintText,
    this.labelText,
    this.helperText,
    required this.formValues,
    required this.formProperty,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
        color: Colors.black,
      ),
      onChanged: (value) {
        formValues[formProperty] = value;
      },
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        hintStyle: const TextStyle(
          color: Colors.black26,
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xff068a50),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff068a50),
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff068a50),
          ),
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
