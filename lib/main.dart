import 'package:flutter/material.dart';
import 'package:mentalhealthapp/views/UserLogin.dart'; // Replace with your actual UserLogin.dart path
import 'package:mentalhealthapp/views/TherapistLogin.dart'; // Replace with your actual TherapistLogin.dart path
import 'package:mentalhealthapp/views/TherapistRegister.dart'; // Replace with your actual TherapistRegister.dart path
import 'package:mentalhealthapp/views/ThankYouPage.dart'; // Replace with your actual ThankYouPage.dart path
import 'model/NotificationService.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serene Soul',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
      routes: {
        '/userlogin': (context) => UserLogin(),
        '/therapistlogin': (context) => TherapistLogin(),
        '/therapistregister': (context) => TherapistRegister(),
        '/thankyou': (context) => ThankYouPage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image or color
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/front.jpg'), // Replace with your background image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row for "Serene" and "Soul"
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Serene',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.white70,
                        fontFamily: 'BodoniModa',
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.brown,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Soul',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.brown,
                        fontFamily: 'BodoniModa',
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black45,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Buttons at the bottom center
          Positioned(
            bottom: 50,
            width: MediaQuery.of(context).size.width, // Match screen width
            child: Column(
              children: [
                // UserLogin button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserLogin()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
                      foregroundColor: Colors.white, // Text and icon color
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                    ),
                    icon: const Icon(Icons.person),
                    label: const Text(
                      "Let's Get Started",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'BodoniModa',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Spacer between buttons
                // TherapistLogin button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TherapistLogin()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
                      foregroundColor: Colors.white, // Text and icon color
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                    ),
                    icon: const Icon(Icons.group),
                    label: const Text(
                      '    Help Others    ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'BodoniModa',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}