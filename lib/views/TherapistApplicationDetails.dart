import 'package:flutter/material.dart';
import '../model/therapist.dart';

class TherapistApplicationDetails extends StatelessWidget {
  final Therapist therapist;
  final Function(Therapist) onApprove;

  const TherapistApplicationDetails({
    Key? key,
    required this.therapist,
    required this.onApprove,
  }) : super(key: key);

  Widget _buildSupportingDocument() {
    if (therapist.supportingDocument == null) {
      return Text('No supporting document provided',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 200,
        height: 200,
        color: Colors.grey[200],
        child: Image.memory(
          therapist.supportingDocument!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $error');
            return Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 40,
              ),
            );
          },
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Applicant Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'BodoniModa'),
            ),
            const SizedBox(height: 16),
            Text('Name: ${therapist.name ?? 'N/A'}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Email: ${therapist.email ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Specialization: ${therapist.specialization ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Supporting Document:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildSupportingDocument(),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => onApprove(therapist),
                child: Text('Approve Application', style: TextStyle( color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}