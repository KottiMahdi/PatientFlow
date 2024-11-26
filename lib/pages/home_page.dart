import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent.shade400,
      ),
      body: ListView(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.04), // Dynamic padding
        children: [
          _buildStatisticsDashboard(),
          SizedBox(height: mediaQuery.size.height * 0.02),
          _buildQuickActions(),
          SizedBox(height: mediaQuery.size.height * 0.02),
          _buildPatientAlerts(),
          SizedBox(height: mediaQuery.size.height * 0.02),
          _buildNotificationsPanel(),
          SizedBox(height: mediaQuery.size.height * 0.02),
          _buildHealthOverview(),
          SizedBox(height: mediaQuery.size.height * 0.02),
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
          _buildQuickActionButton(
            onPressed: () {},
            icon: Icons.add,
            label: "Add Patient",
            color: Colors.blue,
          ),
          _buildQuickActionButton(
            onPressed: () {},
            icon: Icons.group,
            label: "View Patients",
            color: Colors.green,
          ),
          _buildQuickActionButton(
            onPressed: () {},
            icon: Icons.event,
            label: "Add Event",
            color: Colors.purple,
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
      trailing: Text(trailing, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAlertTile(String title, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildNotificationTile(String title, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildHealthTile(String title, String trailing, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Text(trailing, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAgendaTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildQuickActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        label: Text(label, style: TextStyle(color: color)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          side: BorderSide(color: color, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}
