import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Management Dashboard',
          style: TextStyle(color: Colors.white),  // Set text color to white
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStatisticsDashboard(),
          const SizedBox(height: 20),
          _buildQuickActions(),
          const SizedBox(height: 20),
          _buildPatientAlerts(),
          const SizedBox(height: 20),
          _buildNotificationsPanel(),
          const SizedBox(height: 20),
          _buildHealthOverview(),
          const SizedBox(height: 20),
          _buildAgendaView(),
        ],
      ),
    );
  }

  Widget _buildStatisticsDashboard() {
    return CustomCard(
      title: 'Statistics Dashboard',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatTile('Daily Visits', '5', Icons.calendar_today),
          _buildStatTile('Weekly Visits', '15', Icons.calendar_view_week),
          _buildStatTile('Patients on Hold', '2', Icons.access_time),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Quick Action Button 1
          SizedBox(
            width: 120, // Set width to control button size
            child: _buildQuickActionButton(
              onPressed: () {},
              icon: Icons.add,
              label: "Add Patient",
              color: Colors.blue,
            ),
          ),

          const SizedBox(width: 8),

          // Quick Action Button 2
          SizedBox(
            width: 120,
            child: _buildQuickActionButton(
              onPressed: () {},
              icon: Icons.group,
              label: "View Patients",
              color: Colors.green,
            ),
          ),

          const SizedBox(width: 8),

          // Quick Action Button 3
          SizedBox(
            width: 120,
            child: _buildQuickActionButton(
              onPressed: () {},
              icon: Icons.event,
              label: "Add Event",
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientAlerts() {
    return CustomCard(
      title: 'Patient Alerts & Reminders',
      child: Column(
        children: [
          _buildAlertTile(
            'Missed Follow-Up for John Doe',
            Icons.warning,
            Colors.redAccent,
          ),
          _buildAlertTile(
            'Upcoming Appointment: Jane Smith - 3:00 PM',
            Icons.event,
            Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsPanel() {
    return CustomCard(
      title: 'Notifications',
      child: Column(
        children: [
          _buildNotificationTile(
            'System Update Available',
            Icons.notifications,
            Colors.orangeAccent,
          ),
          _buildNotificationTile(
            'New Patient Contact Info Updated',
            Icons.info,
            Colors.lightBlueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthOverview() {
    return CustomCard(
      title: 'Patient Health Overview',
      child: Column(
        children: [
          _buildHealthTile(
            'Age Group: 30-40',
            '12 Patients',
            Icons.health_and_safety,
            Colors.greenAccent,
          ),
          _buildHealthTile(
            'Frequent Condition: Hypertension',
            '8 Patients',
            Icons.healing,
            Colors.purpleAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaView() {
    return CustomCard(
      title: 'Agenda View',
      child: Column(
        children: [
          _buildAgendaTile("Today's Agenda", Icons.today),
          _buildAgendaTile("Filter by Appointment Type", Icons.filter_list),
        ],
      ),
    );
  }

  Widget _buildStatTile(String title, String trailing, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Text(trailing),
    );
  }

  Widget _buildAlertTile(String title, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
    );
  }

  Widget _buildNotificationTile(String title, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
    );
  }

  Widget _buildHealthTile(String title, String trailing, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      trailing: Text(trailing),
    );
  }

  Widget _buildAgendaTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
    );
  }

  Widget _buildQuickActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),  // Set icon color to white
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),  // Set label color to white
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final Widget child;

  const CustomCard({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}
