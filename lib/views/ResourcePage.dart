import 'package:flutter/material.dart';
import 'package:mentalhealthapp/model/NavigationBar.dart';
import 'package:mentalhealthapp/views/AppointmentScreen.dart';
import 'package:mentalhealthapp/views/MoodTrackerOverview.dart';
import 'package:mentalhealthapp/views/UserHome.dart';
import 'package:mentalhealthapp/views/UserProfile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mentalhealthapp/model/article.dart';
import 'package:mentalhealthapp/model/helpline.dart';
import 'package:mentalhealthapp/views/SelfAssessmentPage.dart';
import 'package:mentalhealthapp/model/supportGroup.dart';

class ResourcePage extends StatefulWidget {
  @override
  _ResourcePageState createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        backgroundColor: Colors.green[50],
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Articles"),
              _buildHorizontalList(articles.map((article) => _buildArticleCard(article)).toList()),

              _buildSectionTitle("Support Groups"),
              _buildHorizontalList(groups.map((groups) => _buildSupportGroupCard(groups)).toList()),

              _buildSectionTitle("Helplines"),
              _buildHorizontalList(helplines.map((helpline) => _buildHelplineCard(helpline)).toList()),

              _buildSectionTitle("Self Assessments"),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelfAssessmentPage()),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.assessment_outlined, color: Colors.black, size: 30),
                            SizedBox(width: 16),
                            Text(
                              'Take a Self-Assessment',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'LibreBaskerville',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildHorizontalList(List<Widget> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(children: items),
    );
  }

  Widget _buildArticleCard(Article article) {
    return GestureDetector(
      onTap: () => _launchURL(article.url),
      child: Container(
        width: 200, // Fixed width
        height: 100, // Fixed height (adjust as needed)
        margin: EdgeInsets.only(right: 16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                article.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2, // Limit to 2 lines
                overflow: TextOverflow.ellipsis, // Add ellipsis if the text overflows
              ),
            ),
            Icon(
              Icons.arrow_forward_outlined,
              size: 20,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportGroupCard(supportGroup groups) {
    return GestureDetector(
      onTap: () => _launchURL(groups.url),
      child: Container(
        width: 200, // Fixed width
        height: 100, // Fixed height (adjust as needed)
        margin: EdgeInsets.only(right: 16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                groups.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2, // Limit to 2 lines
                overflow: TextOverflow.ellipsis, // Add ellipsis if the text overflows
              ),
            ),
            Icon(
              Icons.arrow_forward_outlined,
              size: 20,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelplineCard(Helpline helpline) {
    return Container(
      width: 250, // Fixed width
      height: 140, // Fixed height (adjust as needed)
      margin: EdgeInsets.only(right: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            helpline.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () => _launchPhone(helpline.phoneNumber),
            child: Text(
              helpline.phoneNumber,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueAccent,
              ),
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () => _launchURL(helpline.website),
            child: Text(
              helpline.website,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
