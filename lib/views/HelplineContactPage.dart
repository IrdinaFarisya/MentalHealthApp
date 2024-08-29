import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mentalhealthapp/model/helpline.dart';

class HelplinePage extends StatelessWidget {
  HelplinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Helplines',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
            fontFamily: 'BodoniModa',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: helplines.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    helplines[index].name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    helplines[index].description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchPhone(helplines[index].phoneNumber),
                    child: Text(
                      helplines[index].phoneNumber,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchURL(helplines[index].website),
                    child: Text(
                      helplines[index].website,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
