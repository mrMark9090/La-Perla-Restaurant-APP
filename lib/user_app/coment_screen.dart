import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComentariosScreen extends StatefulWidget {
  final String DocumenName;

  const ComentariosScreen({Key? key, required this.DocumenName}); // Pass the user's email

  @override
  _ComentariosScreenState createState() => _ComentariosScreenState();
}

class _ComentariosScreenState extends State<ComentariosScreen> {
  String comentario = '';
  String userEmail = '';
  bool hasComment = false;

  @override
  void initState() {
    super.initState();
    checkUserComment();
  }

  void checkUserComment() async {
    final firestoreInstance = FirebaseFirestore.instance;
    String DocumentName = widget.DocumenName;
    DocumentSnapshot userSnapshot =
        await firestoreInstance.collection('users').doc(DocumentName).get();
    if (userSnapshot.exists) {
      userEmail = userSnapshot['email'] ?? '';
      hasComment = await checkUserHasComment(userEmail);
      setState(() {});
    } else {
      userEmail = '';
    }
  }

  Future<bool> checkUserHasComment(String userEmail) async {
    final firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot commentSnapshot = await firestoreInstance
        .collection('comentarios')
        .where('usuarioEmail', isEqualTo: userEmail)
        .get();

    return commentSnapshot.docs.isNotEmpty;
  }

  Future<void> _guardarComentario() async {
    if (hasComment) {
      // The user has already left a comment, show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('You cannot leave more comments'),
            content: Text('You have already left a comment previously.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Accept'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (comentario.isNotEmpty) {
      // Access the Firestore instance
      final firestoreInstance = FirebaseFirestore.instance;
      String DocumentName = widget.DocumenName;
      DocumentSnapshot userSnapshot =
          await firestoreInstance.collection('users').doc(DocumentName).get();
      if (userSnapshot.exists) {
        userEmail = userSnapshot['email'] ?? '';
      } else {
        userEmail = '';
      }
      firestoreInstance.collection('comentarios').add({
        'usuarioEmail': userEmail,
        'comentario': comentario,
      }).then((value) {
        print('Comentario saved in Firestore with ID: ${value.id}');
        setState(() {
          comentario = 'Thank you for your comment!';
          hasComment = true;
        });
      }).catchError((error) {
        print('Error while saving the comment in Firestore: $error');
        setState(() {
          comentario = 'Error while saving the comment.';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comments',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              enabled: !hasComment,
              onChanged: (value) {
                setState(() {
                  comentario = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Write your comment here',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _guardarComentario,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 56.0,
                ),
                backgroundColor: Color.fromARGB(255, 24, 21, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(38.0),
                ),
              ),
              child: Text(
                'Send',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
