import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatefulWidget {
  final String DocumentName;

  const HistoryScreen({super.key, required this.DocumentName});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reservation History',
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
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.DocumentName)
            .collection('reservations')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final reservation = snapshot.data!.docs[index];
                final fecha = reservation['fecha'];
                final hora = reservation['hora'];
                final mesa = reservation['mesa'];
                final personas = reservation['numero_personas'];

                return ListTile(
                  title: Text('Date: $fecha - Time: $hora'),
                  subtitle: Text('Table: $mesa - People: $personas'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteReservation(reservation.reference);
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('You have no reservations.'));
          }
        },
      ),
    );
  }

  void _deleteReservation(DocumentReference reservationRef) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Reservation'),
          content: Text('Are you sure you want to delete this reservation?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                reservationRef.delete();
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
