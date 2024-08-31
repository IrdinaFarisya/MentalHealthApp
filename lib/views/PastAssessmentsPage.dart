import 'package:flutter/material.dart';
import 'package:mentalhealthapp/model/appUser.dart';
import 'package:mentalhealthapp/model/assessment.dart';
import 'package:mentalhealthapp/Controller/request_controller.dart';
import 'dart:convert';

class PastAssessmentsPage extends StatefulWidget {
  final AppUser? user;

  PastAssessmentsPage({this.user});

  @override
  _PastAssessmentsPageState createState() => _PastAssessmentsPageState();
}

class _PastAssessmentsPageState extends State<PastAssessmentsPage> {
  List<Map<String, dynamic>> pastAssessments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPastAssessments();
  }

  Future<void> _loadPastAssessments() async {
    try {
      RequestController req = RequestController(path: "/api/fetchPastAssessments.php");
      req.setBody({
        'appUserId': widget.user?.appUserId.toString(),
      });
      await req.post();

      if (req.status() == 200) {
        var data = req.result();
        if (data is List) {
          setState(() {
            pastAssessments = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load past assessments');
      }
    } catch (e) {
      print('Error loading past assessments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Past Assessments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'BodoniModa',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pastAssessments.isEmpty
          ? Center(child: Text('No past assessments found.'))
          : ListView.builder(
        itemCount: pastAssessments.length,
        itemBuilder: (context, index) {
          var assessment = pastAssessments[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(assessment['assessmentName'] ?? 'Unknown Assessment'),
              subtitle: Text('Date: ${assessment['created_at'] ?? 'Unknown Date'}'),
              trailing: Text(assessment['result'] ?? 'No Result'),
              onTap: () {
                _showAssessmentDetails(assessment);
              },
            ),
          );
        },
      ),
    );
  }

  void _showAssessmentDetails(Map<String, dynamic> assessment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(assessment['assessmentName'] ?? 'Assessment Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Date: ${assessment['dateCompleted'] ?? 'Unknown Date'}'),
                SizedBox(height: 8),
                Text('Result: ${assessment['result'] ?? 'No Result'}'),
                SizedBox(height: 16),
                Text('Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(assessment['details'] ?? 'No additional details available.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}