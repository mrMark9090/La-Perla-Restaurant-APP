import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la_perla/user_app/histroy_reservation.dart'; // Import the Firestore package

class RegistrationForm extends StatefulWidget {
  final String DocumentName;

  const RegistrationForm({super.key, required this.DocumentName});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  String _userEmail = '';
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _selectedMesa = 1;
  int _selectedPersonas = 1;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _selectedTime.hour, minute: 0),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = TimeOfDay(hour: picked.hour, minute: 0);
      });
    }
  }

  // Method to check if there is an existing reservation with the same date and time
  Future<bool> _checkExistingReservation() async {
    final firestoreInstance = FirebaseFirestore.instance;
    String DocumentName = widget.DocumentName;

    final reservationSnapshot = await firestoreInstance
        .collection('users')
        .doc(DocumentName)
        .collection('reservations')
        .where('status', isEqualTo: false) // Add the condition for the 'status' field
        .get();

    return reservationSnapshot.docs.isNotEmpty;
  }

  // Method to save data to Firebase Firestore
  void _saveDataToFirestore() async {
    bool reservationExists = await _checkExistingReservation();
    if (reservationExists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('You already have a reservation.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final firestoreInstance = FirebaseFirestore.instance;
      String DocumentName =
          widget.DocumentName; // Replace 'user_id' with the current user's ID
      DocumentSnapshot userSnapshot =
          await firestoreInstance.collection('users').doc(DocumentName).get();
      if (userSnapshot.exists) {
        _userEmail = userSnapshot['email'] ??
            ''; // If email is not available, assign an empty string
      } else {
        _userEmail = '';
      }
      firestoreInstance.collection('users').doc(DocumentName).collection('reservations').add({
        'fecha': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'hora': _selectedTime.format(context),
        'mesa': _selectedMesa,
        'numero_personas': _selectedPersonas,
        'email': _userEmail,
        'status': false, // Add the 'status' field and set its value to false
      }).then((value) {
        print('Data saved to Firestore with ID: ${value.id}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Reservation made successfully.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        print('Error saving data to Firestore: $error');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred while making the reservation. Please try again.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Reserve a Table',
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: ListTile(
                    title: Text("Date"),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                  ),
                ),
              ),

              SizedBox(height: 16), // Space between fields

              // Time
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: GestureDetector(
                  onTap: () => _selectTime(context),
                  child: ListTile(
                    title: Text("Time"),
                    subtitle: Text(_selectedTime.format(context)),
                  ),
                ),
              ),

              // Table
              ListTile(
                title: Text("Table",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                trailing: DropdownButton<int>(
                  value: _selectedMesa,
                  onChanged: (value) {
                    setState(() {
                      _selectedMesa = value!;
                    });
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    15,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text(
                        'Table ${index + 1}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),

              // Number of people
              ListTile(
                title: Text("Number of People",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                trailing: DropdownButton<int>(
                  value: _selectedPersonas,
                  onChanged: (value) {
                    setState(() {
                      _selectedPersonas = value!;
                    });
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    15,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),

              // Submit Button
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveDataToFirestore,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 56.0), backgroundColor: Color.fromARGB(255, 24, 21, 44), // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(38.0),
                  ),
                ),
                child: Text(
                  'Reserve a Table',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryScreen(
                DocumentName: widget.DocumentName,
              ), // Replace 'user_id' with the current user's ID
            ),
          );
        },
        backgroundColor: Color.fromARGB(255, 24, 21, 44), // Change the FloatingActionButton color here
        child: Icon(Icons.history),
      ),
    );
  }
}
