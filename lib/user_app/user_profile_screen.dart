import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la_perla/user_app/edit_screen_user.dart';

class UserProfileScreen extends StatefulWidget {
  final String DocumentName;

  UserProfileScreen({required this.DocumentName});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;

      DocumentSnapshot documentSnapshot = await firestoreInstance
          .collection('users')
          .doc(widget.DocumentName)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          userData = documentSnapshot.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }

  void navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(DocumenName: widget.DocumentName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'User Profile',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 24, 21, 44),
        elevation: 4.0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Name'),
            subtitle: Text(userData['name'] ?? ''),
          ),
          ListTile(
            title: Text('First Name'),
            subtitle: Text(userData['lastName'] ?? ''),
          ),
          ListTile(
            title: Text('Last Name'),
            subtitle: Text(userData['secondLastName'] ?? ''),
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text(userData['email'] ?? ''),
          ),
          ListTile(
            title: Text('Password'),
            subtitle: Text(userData['password'] ?? ''),
          ),
          ListTile(
            title: Text('Phone'),
            subtitle: Text(userData['phone'] ?? ''),
          ),
          ListTile(
            title: Text('Date of Birth'),
            subtitle: Text(userData['birthdate'] ?? ''),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToEditProfile,
        child: Icon(Icons.edit),
        backgroundColor: Color.fromARGB(255, 24, 21, 44),
      ),
    );
  }
}
