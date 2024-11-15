import 'package:flutter/material.dart';

// Home page widget with a stateful widget for dynamic updates
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
          'Home', // Set the title of the app bar
          style: TextStyle(color: Colors.white),  // Set text color to white
        ),
        backgroundColor: Colors.blueAccent, // Set app bar background color
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0), // Padding around the list
        children: [
          _buildStatisticsDashboard(), // Build the statistics dashboard section
          const SizedBox(height: 20), // Spacing between sections
          _buildQuickActions(), // Build the quick actions section
          const SizedBox(height: 20),
          _buildPatientAlerts(), // Build the patient alerts section
          const SizedBox(height: 20),
          _buildNotificationsPanel(), // Build the notifications section
          const SizedBox(height: 20),
          _buildHealthOverview(), // Build the health overview section
          const SizedBox(height: 20),
          _buildAgendaView(), // Build the agenda view section
        ],
      ),
    );
  }

  // Builds the statistics dashboard section
  Widget _buildStatisticsDashboard() {
    return CustomCard(
      title: 'Statistics Dashboard',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatTile('Daily Visits', '5', Icons.calendar_today), // Daily visits stat
          _buildStatTile('Weekly Visits', '15', Icons.calendar_view_week), // Weekly visits stat
          _buildStatTile('Patients on Hold', '2', Icons.access_time), // Patients on hold stat
        ],
      ),
    );
  }

  // Builds the quick actions section with horizontal scroll
  Widget _buildQuickActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Allows horizontal scrolling
      child: Row(
        children: [
          // Quick Action Button 1
          SizedBox(
            width: 120, // Set width to control button size
            child: _buildQuickActionButton(
              onPressed: () {}, // Action for button press
              icon: Icons.add, // Button icon
              label: "Add Patient", // Button label
              color: Colors.blue, // Button background color
            ),
          ),

          const SizedBox(width: 8), // Spacing between buttons

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

  // Builds the patient alerts section
  Widget _buildPatientAlerts() {
    return CustomCard(
      title: 'Patient Alerts & Reminders',
      child: Column(
        children: [
          _buildAlertTile(
            'Missed Follow-Up for John Doe', // Alert title
            Icons.warning, // Alert icon
            Colors.redAccent, // Icon color
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

  // Builds the notifications section
  Widget _buildNotificationsPanel() {
    return CustomCard(
      title: 'Notifications',
      child: Column(
        children: [
          _buildNotificationTile(
            'System Update Available', // Notification title
            Icons.notifications, // Notification icon
            Colors.orangeAccent, // Icon color
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

  // Builds the patient health overview section
  Widget _buildHealthOverview() {
    return CustomCard(
      title: 'Patient Health Overview',
      child: Column(
        children: [
          _buildHealthTile(
            'Age Group: 30-40', // Health detail title
            '12 Patients', // Health detail information
            Icons.health_and_safety, // Icon for health detail
            Colors.greenAccent, // Icon color
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

  // Builds the agenda view section
  Widget _buildAgendaView() {
    return CustomCard(
      title: 'Agenda View',
      child: Column(
        children: [
          _buildAgendaTile("Today's Agenda", Icons.today), // Agenda item
          _buildAgendaTile("Filter by Appointment Type", Icons.filter_list),
        ],
      ),
    );
  }

  // Helper widget to build a statistic tile for the dashboard
  Widget _buildStatTile(String title, String trailing, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue), // Icon on the left side
      title: Text(title), // Title of the statistic
      trailing: Text(trailing), // Statistic value on the right side
    );
  }

  // Helper widget to build an alert tile for the alerts section
  Widget _buildAlertTile(String title, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor), // Icon with specified color
      title: Text(title), // Title of the alert
    );
  }

  // Helper widget to build a notification tile
  Widget _buildNotificationTile(String title, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor), // Icon with specified color
      title: Text(title), // Title of the notification
    );
  }

  // Helper widget to build a health tile in the health overview section
  Widget _buildHealthTile(String title, String trailing, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor), // Icon with specified color
      title: Text(title), // Title of the health detail
      trailing: Text(trailing), // Information about the health detail
    );
  }

  // Helper widget to build an agenda tile
  Widget _buildAgendaTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent), // Icon on the left
      title: Text(title), // Title of the agenda item
    );
  }

  // Helper widget to build a quick action button with an icon and label
  Widget _buildQuickActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed, // Action when the button is pressed
      icon: Icon(icon, color: Colors.white),  // Set icon color to white
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),  // Set label color to white
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Button background color
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Button padding
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Button shape with rounded corners
      ),
    );
  }
}

// Custom card widget with a title and child content
class CustomCard extends StatelessWidget {
  final String title; // Title of the card
  final Widget child; // Child content to display inside the card

  const CustomCard({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners for the card
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title, // Card title
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Title style
            ),
            const Divider(), // Divider line below the title
            child, // Child content of the card
          ],
        ),
      ),
    );
  }
}


// ==> structure of widget-based modular approach