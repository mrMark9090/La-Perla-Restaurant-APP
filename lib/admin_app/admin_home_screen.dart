import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../introduction_animation/components/login_view.dart';

class AdminAppHomeScreen extends StatefulWidget {
  final String DocumentName;

  const AdminAppHomeScreen({super.key, required this.DocumentName});

  @override
  _AdminAppHomeScreenState createState() => _AdminAppHomeScreenState();
}

class _AdminAppHomeScreenState extends State<AdminAppHomeScreen> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() async {
    try {
      // Access the Firestore instance
      final firestoreInstance = FirebaseFirestore.instance;

      // Get the document with the provided name
      DocumentSnapshot documentSnapshot = await firestoreInstance
          .collection('admin')
          .doc(widget.DocumentName)
          .get();

      // Check if the document exists and get the 'name' field
      if (documentSnapshot.exists) {
        setState(() {
          userName = documentSnapshot.get('name');
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  void _deleteComment(String commentId) {
    // Access the Firestore instance
    final firestoreInstance = FirebaseFirestore.instance;

    // Delete the comment document from the 'comentarios' collection
    firestoreInstance.collection('comentarios').doc(commentId).delete().then((value) {
      print('Comment deleted successfully.');
    }).catchError((error) {
      print('Error deleting comment: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          child: Row(
            children: [
              Text(
                'Welcome, $userName!',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('Logout'),
              ),
            ],
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
      body: Center(
        child: _buildCommentsList(),
      ),
    );
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginForm()),
      (route) => false,
    );
  }

  Widget _buildCommentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('comentarios').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final comments = snapshot.data!.docs;
        if (comments.isEmpty) {
          return Center(
            child: Text('No comments available'),
          );
        }

        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index].data() as Map<String, dynamic>;
            final commentId = comments[index].id;
            final userEmail = comment['usuarioEmail'];
            final commentText = comment['comentario'];
            return ListTile(
              title: Text('Comment: $commentText'),
              subtitle: Text('User: $userEmail'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Logic to delete the comment when the delete button is pressed
                  _deleteComment(commentId);
                },
              ),
            );
          },
        );
      },
    );
  }
}
