import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'All Users',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userData = users[index].data() as Map<String, dynamic>;
                bool status = userData['status'] ?? false;

                return ExpansionTile(
                  title: Row(
                    children: [
                      Text(userData['name']),
                      SizedBox(width: 8),
                      Switch(
                        value: status,
                        onChanged: (value) {
                          // Lógica para cambiar el estado del usuario
                          _updateUserStatus(users[index].reference, value);
                        },
                      ),
                    ],
                  ),
                  subtitle: Text(userData['email']),
                  children: [
                    ListTile(
                      title: Text('First Last Name: ${userData['lastName']}'),
                    ),
                    ListTile(
                      title: Text('Second Last Name: ${userData['secondLastName']}'),
                    ),
                    ListTile(
                      title: Text('Phone: ${userData['phone']}'),
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // Método para actualizar el estado del usuario en Firestore
  void _updateUserStatus(DocumentReference userRef, bool newStatus) {
    userRef.update({'status': newStatus}).then((value) {
      print('Estado del usuario actualizado con éxito.');
    }).catchError((error) {
      print('Error al actualizar el estado del usuario: $error');
    });
  }
}
