import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mentalhealthapp/views/login.dart';
import '../model/appUser.dart';
//import 'detailPage.dart'; // Import detailPage if needed

class ExplorePage extends StatefulWidget {
  final AppUser user;

  ExplorePage({required this.user});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final AppUser user;
  String resourceType = '';
  String resourceTitle = '';
  String resourceDescription = '';
  String contactInfo = '';
  int resourceId = 0;
  String image = '';
  String? getImages = '';
  int selectedCategoryId = 0;

  final List<MentalHealthResource> resources = [];

  String _formatTime(String? time) {
    if (time == null) {
      return '';
    }

    // Split the time into hours, minutes, and seconds
    List<String> parts = time.split(':');

    // Extract hours and minutes
    String hours = parts[0];
    String minutes = parts[1];

    // Return the formatted time as HH:mm
    return '$hours:$minutes';
  }

  @override
  void initState() {
    super.initState();
    loadResources();
  }

  Future<List<MentalHealthResource>> loadResources() async {
    // Load resources from a static method or API
    List<MentalHealthResource> loadedResources = await MentalHealthResource.loadResourcesStatic();

    setState(() {
      resources.clear();
      resources.addAll(loadedResources);
      print("Loaded resources: ${resources.length}");
    });
    return loadedResources;
  }

  Uint8List? _loadImage(index) {
    getImages = resources[index].resourceImage;

    if (getImages == null || getImages!.isEmpty) {
      print('Image is empty');
      return null;
    }

    try {
      getImages = getImages?.replaceAll(r'\\', '');
      getImages = getImages?.trim();

      if (getImages!.startsWith("data:image/jpeg;base64,")) {
        getImages = getImages?.substring(getImages!.indexOf(',') + 1);
      }

      Uint8List decodedImage = base64.decode(getImages!);

      if (decodedImage.isNotEmpty) {
        return decodedImage;
      } else {
        print('Decoded image is empty');
        return null;
      }
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }
  }

  void updateCategoryId(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Mental Health App',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => signIn()),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          buildSectionTitle(context, 'Explore'),
          Row(
            children: [
              Expanded(
                child: buildCategoryItem('Therapists', 1),
              ),
              Expanded(
                child: buildCategoryItem('Support Groups', 2),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: buildCategoryItem('Hotlines', 3),
              ),
              Expanded(
                child: buildCategoryItem('Articles', 4),
              ),
            ],
          ),
          buildSectionTitle(context, 'You might like these'),
          _buildGridView(resources ?? []),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, color: Colors.black),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code, color: Colors.black),
                label: 'QrCode',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard, color: Colors.black),
                label: 'Reward',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.black),
                label: 'Account',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExplorePage(user: widget.user),
                    ),
                  );
                  break;
                case 1:
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrScanner(user: widget.user),
                    ),
                  );*/
                  break;
                case 2:
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RewardPage(user: widget.user),
                    ),
                  );*/
                  break;
                case 3:
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => updateProfilePage(user: widget.user),
                    ),
                  );*/
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryItem(String title, int categoryId) {
    IconData iconData;

    switch (title) {
      case 'Therapists':
        iconData = Icons.person;
        break;
      case 'Support Groups':
        iconData = Icons.group;
        break;
      case 'Hotlines':
        iconData = Icons.phone;
        break;
      case 'Articles':
        iconData = Icons.article;
        break;
      default:
        iconData = Icons.category;
    }

    return Card(
      child: GestureDetector(
        onTap: () {
          print('Tapped on category: $title with categoryId: $categoryId');
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryPage(
                user: widget.user,
                categoryId: categoryId,
                resources: resources,
                imageBytes: _loadImage(categoryId),
              ),
            ),
          );*/
        },
        child: ListTile(
          leading: Icon(iconData),
          title: Text(title),
        ),
      ),
    );
  }

  Widget _buildGridView(List<MentalHealthResource> resources) {
    List<MentalHealthResource> filteredResources = resources.where((resource) {
      return selectedCategoryId == 0 || resource.categoryId == selectedCategoryId;
    }).toList();

    return Container(
      height: 400,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 50.0,
        ),
        itemCount: filteredResources.length,
        itemBuilder: (context, index) {
          MentalHealthResource resource = filteredResources[index];
          Uint8List? imageBytes = _loadImage(index);

          return GestureDetector(
            onTap: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    resource: resource,
                    imageBytes: _loadImage(index),
                  ),
                ),
              );*/
            },
            child: Card(
              elevation: 40.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: double.infinity,
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageBytes != null)
                      Image.memory(
                        imageBytes,
                        height: 90,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            resource.title ?? '',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text('Description: ${resource.description ?? ''}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MentalHealthResource {
  final int? resourceId;
  final String? title;
  final String? description;
  final String? contactInfo;
  final int? categoryId;
  final String? resourceImage;

  MentalHealthResource({
    this.resourceId,
    this.title,
    this.description,
    this.contactInfo,
    this.categoryId,
    this.resourceImage,
  });

  static Future<List<MentalHealthResource>> loadResourcesStatic() async {
    // Implement the method to load resources
    return [];
  }
}
