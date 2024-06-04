import 'package:climate_wise/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:climate_wise/models/models.dart';
import 'package:climate_wise/providers/db_provider.dart';
import 'package:climate_wise/providers/providers.dart';
import 'package:climate_wise/widgets/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}

class ScrollDesignScreen extends StatelessWidget {
  ScrollDesignScreen({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    weatherProvider.getJsonData;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [.5, .5],
            colors: [
              Color(0xfffcedcc),
              Color(0xfffcedcc),
            ],
          ),
        ),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          children: [
            _Screen1(
                weather: weatherProvider.actualClima,
                uvi: weatherProvider.uviActual,
                pageController: _pageController),
            Screen2(pageController: _pageController),
          ],
        ),
      ),
    );
  }
}

class _Screen1 extends StatelessWidget {
  final PageController pageController;
  final Clima weather;
  final Uvi uvi;

  signOut() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      await FacebookAuth.instance.logOut();
    }
    await GoogleSignIn().signOut();

    await FirebaseAuth.instance.signOut();
  }

  const _Screen1(
      {super.key,
      required this.weather,
      required this.uvi,
      required this.pageController});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Background(),
        MainContent(
          pageController: pageController,
          weather: weather,
          uvi: uvi,
        ),
      ],
    );
  }
}

class MainContent extends StatelessWidget {
  final Uvi uvi;
  final Clima weather;
  final PageController pageController;

  const MainContent({
    super.key,
    required this.weather,
    required this.uvi,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    DBProvider.db.database;

    const textStyle = TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.bold,
      color: Color(0xffb58308),
    );
    const subtitleStyle = TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.bold,
      color: Color(0xffb58308),
    );
    const textStyleLandscape = TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: Color(0xffb58308),
    );
    const subtitleStyleLandscape = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xffb58308),
    );
    final dayProvider = Provider.of<DayProvider>(context);
    final now = DateTime.now();
    final isLate = now.hour >= 18;

    return SafeArea(
      bottom: false,
      minimum: EdgeInsets.only(bottom: 100),
      child: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitLayout(
                  context, subtitleStyle, textStyle, dayProvider, isLate)
              : _buildLandscapeLayout(context, subtitleStyleLandscape,
                  textStyleLandscape, dayProvider, isLate, pageController);
        },
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, TextStyle subtitleStyle,
      TextStyle textStyle, DayProvider dayProvider, bool isLate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () async {
                await DBProvider.db.deleteRentaById(1);
                Navigator.pushReplacementNamed(context, 'Welcome');
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                size: 30,
              ),
            ),
          ],
        ),
        const SizedBox(height: 00),
        Text('Temperatura: ', style: subtitleStyle),
        Text('${weather.temp.toStringAsFixed(1)}°', style: textStyle),
        Text(dayProvider.formattedDay, style: textStyle),
        Text('Húmedad: ${weather.humidity}%', style: subtitleStyle),
        if (!isLate)
          Text('Rayos UV: ${uvi.value.toStringAsFixed(0)}',
              style: subtitleStyle),
        Text('Presión atmosférica: ${weather.pressure} hPa',
            style: subtitleStyle),
        Expanded(child: Container()),
        SizedBox(height: 20),
        const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 200,
          color: Color(0xffb48307),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(
      BuildContext context,
      TextStyle subtitleStyle,
      TextStyle textStyle,
      DayProvider dayProvider,
      bool isLate,
      PageController pageController) {
    return Container(
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text('Temperatura: ', style: subtitleStyle),
              Text('${weather.temp.toStringAsFixed(1)}°', style: textStyle),
              Text(dayProvider.formattedDay, style: textStyle),
              Text('Húmedad: ${weather.humidity}%', style: subtitleStyle),
              if (!isLate)
                Text('Rayos UV: ${uvi.value.toStringAsFixed(0)}',
                    style: subtitleStyle),
              Text('Presión atmosférica: ${weather.pressure} hPa',
                  style: subtitleStyle),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () async {
                  await DBProvider.db.deleteRentaById(1);
                  Navigator.pushReplacementNamed(context, 'Welcome');
                },
                icon: Icon(
                  Icons.delete_forever_outlined,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 160,
                  color: Color(0xffb48307),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff50c2dd),
      height: double.infinity,
      alignment: Alignment.topCenter,
      child: const Image(
        image: AssetImage('assets/scroll-1.png'),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  final PageController pageController;

  const Screen2({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4af0c),
      body: Stack(
        children: [
          BackgroundPage2(),
          _HomeBody(),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              color: Colors.white,
              iconSize: 40,
              icon: Icon(Icons.arrow_upward),
              onPressed: () {
                pageController.animateToPage(
                  0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: .01,
                    blurRadius: 5,
                    offset: Offset(0, 1),
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'Notification');
                    },
                    icon: Icon(
                      Icons.notification_important_rounded,
                      color: Colors.black54,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => const Profile());
                    },
                    child: Icon(
                      Icons.person_outline_outlined,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff068a50),
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(15),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'Settings');
                    },
                    icon: Icon(
                      Icons.settings,
                      color: Colors.black54,
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

class _HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.actualClima;
    final uvi = weatherProvider.uviActual;

    final recommendations = buildRecommendations(weather, uvi);
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
                PageTitle(
                  paciente: paciente,
                ),
                Table(
                  children: recommendations.map((recommendation) {
                    return TableRow(
                      children: [
                        recommendation,
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
