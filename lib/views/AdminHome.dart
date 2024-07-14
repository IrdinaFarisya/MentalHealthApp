import 'package:flutter/material.dart';
import '../model/therapist.dart';
import '../model/admin.dart';
import 'TherapistApplicationDetails.dart';

class AdminHome extends StatefulWidget {
  final Admin admin;

  AdminHome({required this.admin});

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Therapist> pendingTherapists = [];

  @override
  void initState() {
    super.initState();
    _loadPendingTherapists();
  }

  Future<void> _loadPendingTherapists() async {
    List<Therapist> therapists = await Therapist.fetchPendingTherapists();
    setState(() {
      pendingTherapists = therapists;
    });
  }

  Future<void> _approveTherapist(Therapist therapist) async {
    bool success = await therapist.approveTherapist();
    if (success) {
      setState(() {
        pendingTherapists.remove(therapist);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Therapist approved successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to approve therapist')),
      );
    }
  }

  void _viewApplicationDetails(Therapist therapist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TherapistApplicationDetails(
          therapist: therapist,
          onApprove: _approveTherapist,
        ),
      ),
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
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pending Applications',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: 'BodoniModa',
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: pendingTherapists.isEmpty
                    ? const Center(
                  child: Text(
                    'No pending applications.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'BodoniModa',
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: pendingTherapists.length,
                  itemBuilder: (context, index) {
                    final therapist = pendingTherapists[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(
                          therapist.name ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'BodoniModa',
                          ),
                        ),
                        subtitle: Text(
                          therapist.email ?? '',
                          style: const TextStyle(
                            fontFamily: 'BodoniModa',
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _viewApplicationDetails(therapist),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: const Text('View Details'),
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