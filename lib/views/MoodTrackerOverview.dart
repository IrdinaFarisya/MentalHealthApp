import 'package:flutter/material.dart';
import 'package:mentalhealthapp/model/mood.dart';
import 'package:mentalhealthapp/views/MoodTracker.dart';
import 'package:intl/intl.dart';

class MoodTrackerOverview extends StatefulWidget {
  @override
  _MoodTrackerOverviewState createState() => _MoodTrackerOverviewState();
}

class _MoodTrackerOverviewState extends State<MoodTrackerOverview> {
  List<Mood> recentMoods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentMoods();
  }

  Future<void> _fetchRecentMoods() async {
    setState(() {
      isLoading = true;
    });

    try {
      Mood moodModel = Mood();
      List<Mood> fetchedMoods = await moodModel.fetchMood();
      setState(() {
        recentMoods = fetchedMoods;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error fetching recent moods: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch recent moods. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
      body: RefreshIndicator(
        onRefresh: _fetchRecentMoods,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoodTrackerPage()),
                  ).then((_) => _fetchRecentMoods());
                },
                child: Text(
                  'New Mood Entry',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Recent Mood Entries',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibreBaskerville',
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : recentMoods.isEmpty
                    ? Center(child: Text('No mood entries found.'))
                    : ListView.builder(
                  itemCount: recentMoods.length,
                  itemBuilder: (context, index) {
                    Mood mood = recentMoods[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          title: Text(mood.mood ?? 'Unknown Mood'),
                          subtitle: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(mood.date!))),
                          trailing: Icon(Icons.mood),
                          onTap: () {
                            // Navigate to detail view of this mood entry
                            // You'll need to create this page
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MoodDetailPage(mood: mood)));
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
