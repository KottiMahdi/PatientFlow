import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profilePicture = 'https://via.placeholder.com/150';
  String name = 'Dr. Jane Doe';
  String email = 'janedoe@example.com';
  String phone = '+123 456 7890';
  String specialization = 'Cardiologist';
  String bio = 'Add your bio here';

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) => name = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) => email = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Phone'),
              onChanged: (value) => phone = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Specialization'),
              onChanged: (value) => specialization = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Bio'),
              onChanged: (value) => bio = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Save changes
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _updateProfilePicture() {
    // Logic to update profile picture
  }

  void _logout() {
    // Logic to logout
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    double _getFontSize(double baseSize) {
      return screenWidth < 350 ? baseSize * 0.8 : screenWidth < 450 ? baseSize * 0.9 : baseSize;
    }

    return Scaffold(
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text('Profile', style: TextStyle(color: Colors.white)),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  GestureDetector(
                    onTap: _updateProfilePicture,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: screenWidth * 0.2,
                        backgroundImage: NetworkImage(profilePicture),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            child: Icon(Icons.camera_alt, size: 20, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(fontSize: _getFontSize(24), fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            specialization,
                            style: TextStyle(fontSize: _getFontSize(16), color: Colors.blueGrey, fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 8),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.email, color: Colors.blueGrey),
                            title: Text(
                              email,
                              style: TextStyle(fontSize: _getFontSize(16), color: Colors.grey),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.phone, color: Colors.blueGrey),
                            title: Text(
                              phone,
                              style: TextStyle(fontSize: _getFontSize(16), color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 8),
                          ListTile(
                            leading: Icon(Icons.info, color: Colors.blueGrey),
                            title: Text(
                              bio,
                              style: TextStyle(fontSize: _getFontSize(14), color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _editProfile,
                          icon: Icon(Icons.edit),
                          label: Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _logout,
                          icon: Icon(Icons.logout),
                          label: Text('Logout'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red, side: BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Color(0xFF1E88E5),
      hintColor: Color(0xFF607D8B),
      scaffoldBackgroundColor: Color(0xFFF5F5F5),
    ),
    home: ProfilePage(),
  ));
}