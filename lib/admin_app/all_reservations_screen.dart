import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa el paquete de Firestore

class AllReservationsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'All Reservations',
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
      body: _buildAllReservationsList(),
    );
  }

  void _updateReservationStatus(DocumentReference reservationRef, bool newStatus) {
    reservationRef.update({'status': newStatus}).then((value) {
      // Actualización exitosa
    }).catchError((error) {
      print('Error al actualizar el status de la reserva: $error');
    });
  }

Widget _buildAllReservationsList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collectionGroup('reservations').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final reservations = snapshot.data!.docs;
      if (reservations.isEmpty) {
        return Center(
          child: Text('There are no reservations'),
        );
      }

      return ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index].data() as Map<String, dynamic>;
          final fecha = reservation['fecha'];
          final hora = reservation['hora'];
          final mesa = reservation['mesa'];
          final personas = reservation['numero_personas'];
          final email = reservation['email']; // Campo "email" en lugar de una referencia

          final status = reservation['status'] ?? false; // Asigna false si 'status' es nulo o no existe

          return ListTile(
            title: Text('Fecha: $fecha, Hora: $hora, Mesa: $mesa, Personas: $personas'),
            subtitle: Text('Email: $email'), // Utiliza directamente el valor del campo "email"
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    status ? Icons.toggle_on : Icons.toggle_off,
                    color: status ? Colors.green : Colors.red,
                  ),
                  onPressed: () {
                    // Lógica para cambiar el estado del campo 'status'
                    _updateReservationStatus(reservations[index].reference, !status);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para borrar la reserva
                    _deleteReservation(reservations[index].reference);
                  },
                  child: Text('Borrar'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void _deleteReservation(DocumentReference reservationRef) {
  reservationRef.delete().then((value) {
    print('Reserva eliminada correctamente');
  }).catchError((error) {
    print('Error al eliminar la reserva: $error');
  });
}

}
