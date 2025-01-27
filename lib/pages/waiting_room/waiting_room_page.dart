import 'package:flutter/material.dart';

class WaitingRoomPage extends StatelessWidget {
  // Example list of waiting patients
  final List<Map<String, String>> waitingPatients = [
    {'name': 'John Doe', 'reason': 'General Checkup', 'time': '10:00 AM'},
    {'name': 'Jane Smith', 'reason': 'Follow-up', 'time': '10:15 AM'},
    {'name': 'Alex Johnson', 'reason': 'Blood Test', 'time': '10:30 AM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Waiting Room', style: TextStyle(color: Colors.white)), // App bar title
        backgroundColor: Colors.blueAccent.shade400, // App bar background color
      ),
      body: waitingPatients.isNotEmpty
          ? ListView.builder(
        itemCount: waitingPatients.length,
        itemBuilder: (context, index) {
          final patient = waitingPatients[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 6.0),
            child: Card(
               child: ListTile(
                leading: Icon(Icons.person, size: 40),
                title: Text(patient['name'] ?? 'Unknown'),
                subtitle: Text(
                    '${patient['reason']} • ${patient['time']}'),
                trailing: Icon(Icons.more_vert),
              ),
            ),
          );
        },
      )
          : Center(
        child: Text(
          'No patients in the waiting room.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to add a patient (e.g., navigate to a form)
        },
        child: Icon(Icons.add),
        tooltip: 'Add Patient',
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WaitingRoomPage(),
  ));
}
