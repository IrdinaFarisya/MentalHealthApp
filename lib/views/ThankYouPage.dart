import 'package:flutter/material.dart';
import 'package:mentalhealthapp/main.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SereneSoul',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
            fontFamily: 'BodoniModa',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Thank You for Applying!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: 'BodoniModa',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your application will be reviewed. Please try to login after 24 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontFamily: 'LibreBaskerville'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                        (route) => false,
                  );
                },
                child: const Text('Okay', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
