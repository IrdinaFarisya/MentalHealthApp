import 'package:flutter/material.dart';
import '../model/therapist.dart';
import 'dart:convert';
import 'dart:typed_data';

class TherapistApplicationDetails extends StatelessWidget {
  final Therapist therapist;
  final Function(Therapist) onApprove;

  const TherapistApplicationDetails({
    Key? key,
    required this.therapist,
    required this.onApprove,
  }) : super(key: key);

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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Applicant Details',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'BodoniModa',
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            _buildInfoTable(),
            SizedBox(height: 30),
            Text(
              'Supporting Document',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'BodoniModa',
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            _buildSupportingDocument(),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () => onApprove(therapist),
                child: Text(
                  'Approve Application',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTable() {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      border: TableBorder.all(color: Colors.grey, width: 1),
      children: [
        _buildTableRow('Name', therapist.name ?? 'N/A'),
        _buildTableRow('Email', therapist.email ?? 'N/A'),
        _buildTableRow('Specialization', therapist.specialization ?? 'N/A'),
        _buildTableRow('Location', therapist.location ?? 'N/A'),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportingDocument() {
    if (therapist.supportingDocument == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No supporting document provided',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Document Preview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: _buildDocumentPreview(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentPreview() {
    String base64String = String.fromCharCodes(therapist.supportingDocument!);
    try {
      Uint8List decodedImage = base64Decode(base64String);

      return Image.memory(
        decodedImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 40),
                SizedBox(height: 8),
                Text('Error loading image', style: TextStyle(color: Colors.red)),
              ],
            ),
          );
        },
      );
    } catch (e) {
      return Center(
        child: Text('Error decoding image', style: TextStyle(color: Colors.red)),
      );
    }
  }
}
