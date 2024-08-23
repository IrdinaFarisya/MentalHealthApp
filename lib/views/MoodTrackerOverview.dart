import 'package:flutter/material.dart';
import 'package:mentalhealthapp/model/mood.dart';
import 'package:mentalhealthapp/views/AppointmentScreen.dart';
import 'package:mentalhealthapp/views/MoodTracker.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mentalhealthapp/views/UserHome.dart';
import 'package:mentalhealthapp/views/UserProfile.dart';

class MoodTrackerOverview extends StatefulWidget {
  @override
  _MoodTrackerOverviewState createState() => _MoodTrackerOverviewState();
}

class _MoodTrackerOverviewState extends State<MoodTrackerOverview> {
  List<Mood> recentMoods = [];
  bool isLoading = true;
  int _selectedIndex = 1;

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

  void _showMoodDetailDialog(Mood mood) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(mood.mood ?? 'Unknown Mood'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mood.details ?? 'No description available',
                style: TextStyle(fontSize: 15,color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
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
      backgroundColor: Colors.white,
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
                'Mood Distribution',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibreBaskerville',
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : MoodBarChart(moodEntries: recentMoods),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(4),
                          title: Text(mood.mood ?? 'Unknown Mood'),
                          subtitle: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(mood.date!))),
                          trailing: Icon(Icons.mood),
                          onTap: () {
                            // Navigate to detail view of this mood entry
                            _showMoodDetailDialog(mood);
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Add this line
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Therapists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true, // Add this line to ensure unselected labels are shown
        onTap: (index) {
          // Handle item tap
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserHomePage(),
                ),
              );
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoodTrackerOverview(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentScreen(),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(),
                ),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}

class MoodBarChart extends StatelessWidget {
  final List<Mood> moodEntries;

  MoodBarChart({required this.moodEntries});

  @override
  Widget build(BuildContext context) {
    Map<String, int> moodCounts = {};

    for (var mood in moodEntries) {
      if (mood.mood != null) {
        moodCounts[mood.mood!] = (moodCounts[mood.mood!] ?? 0) + 1;
      }
    }

    List<BarChartGroupData> barGroups = moodCounts.entries.map((entry) {
      return BarChartGroupData(
        x: _getMoodIndex(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.black,
            width: 16,
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                String title;
                switch (value.toInt()) {
                  case 0: title = 'Joy'; break;
                  case 1: title = 'Sadness'; break;
                  case 2: title = 'Disgust'; break;
                  case 3: title = 'Anger'; break;
                  case 4: title = 'Envy'; break;
                  case 5: title = 'Anxiety'; break;
                  case 6: title = 'Ennui'; break;
                  case 7: title = 'Fear'; break;
                  case 8: title = 'Embarrassment'; break;
                  default: title = ''; break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xff37434d),
            width: 1,
          ),
        ),
        barGroups: barGroups,
      ),
    );
  }

  int _getMoodIndex(String mood) {
    switch (mood) {
      case 'Joy': return 0;
      case 'Sadness': return 1;
      case 'Disgust': return 2;
      case 'Anger': return 3;
      case 'Envy': return 4;
      case 'Anxiety': return 5;
      case 'Ennui': return 6;
      case 'Fear': return 7;
      case 'Embarrassment': return 8;
      default: return -1;
    }
  }
}

class MoodDetailPage extends StatelessWidget {
  final Mood mood;

  MoodDetailPage({required this.mood});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Details'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mood.mood ?? 'Unknown Mood',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(mood.date!))}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              mood.details ?? 'No description available',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
