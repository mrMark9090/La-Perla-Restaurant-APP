import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la_perla/user_app/bottom_bar_user.dart';

import '../../admin_app/bottom_bar_admin_sceen.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _loggedInDocumentName = ''; // Variable de clase para almacenar el nombre del documento

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Access Firestore instance
      final firestoreInstance = FirebaseFirestore.instance;

      // Check if user exists with the provided email and password
      QuerySnapshot userSnapshot = await firestoreInstance
          .collection('users')
          .where('email', isEqualTo: _emailController.text)
          .where('password', isEqualTo: _passwordController.text)
          .get();

      QuerySnapshot adminSnapshot = await firestoreInstance
          .collection('admin')
          .where('username', isEqualTo: _emailController.text)
          .where('password', isEqualTo: _passwordController.text)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        // Check if the user's account is temporarily suspended
        bool isSuspended = userSnapshot.docs[0].get('status');

        if (isSuspended) {
          // User account is suspended, show alert message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Login'),
                content: Text('Your account is temporarily suspended'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // User exists and account is not suspended, show success message or redirect to another screen
          setState(() {
            _loggedInDocumentName = userSnapshot.docs[0].id;
          });

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Login'),
                content: Text('Login successful'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomBarUser(DocumentName: _loggedInDocumentName),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      } else if (adminSnapshot.docs.isNotEmpty) {
        // Admin exists, show success message or redirect to another screen
        String adminDocumentName = adminSnapshot.docs[0].id; // Guarda el nombre del documento del administrador

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login'),
              content: Text('Admin login successful'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => bottomBarAdmin(DocumentName: adminDocumentName),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        // User does not exist or invalid credentials
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login'),
              content: Text('Invalid email or password'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
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
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 6.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 56.0),
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(38.0),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
