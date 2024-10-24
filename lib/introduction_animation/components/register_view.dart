import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:la_perla/user_app/bottom_bar_user.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _secondLastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  late String _loggedInDocumentName; // Variable para almacenar el ID del documento recién creado
  DateTime? _selectedDate;
  bool _emailExists = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _secondLastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Check if email contains @ symbol
      if (!_emailController.text.contains('@')) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Invalid email address'),
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
        return;
      }

      // Initialize Firebase
      await Firebase.initializeApp();

      // Access Firestore instance
      final firestoreInstance = FirebaseFirestore.instance;

      // Check if email already exists
      QuerySnapshot querySnapshot = await firestoreInstance
          .collection('users')
          .where('email', isEqualTo: _emailController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Show an error message if the email already exists
        setState(() {
          _emailExists = true;
        });
        return;
      }

      // Create a new document in the "users" collection
      DocumentReference docRef =
          await firestoreInstance.collection('users').add({
        'name': _nameController.text,
        'lastName': _lastNameController.text,
        'secondLastName': _secondLastNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'phone': _phoneController.text,
        'birthdate': _selectedDate != null ? _selectedDate.toString() : '',
        'status': false,
      });

      if (docRef.id.isNotEmpty) {
        // Assign the document ID to the _loggedInDocumentName variable
        setState(() {
          _loggedInDocumentName = docRef.id;
        });

        // Show a success message or redirect to another screen
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Registration successful'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomBarUser(DocumentName: _loggedInDocumentName,),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Show an error message if the Firebase upload fails
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred while registering the data'),
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registration Form',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255), // Cambia el color de las letras a blanco
            fontSize: 20, // Ajusta el tamaño de las letras
            fontWeight: FontWeight.bold, // Aplica un estilo de fuente negrita
          ),
        ),
        backgroundColor: Color.fromARGB(255, 24, 21, 44), // Color de fondo de la AppBar
        elevation: 4.0, // Sombra de la AppBar
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
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _secondLastNameController,
                  decoration: InputDecoration(
                    labelText: 'Second Last Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your second last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
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
                    if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _emailExists = false;
                    });
                  },
                ),
                _emailExists
                    ? Text(
                        'This email is already registered',
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Permite solo la entrada de números
                  keyboardType: TextInputType.phone, // Establece el tipo de teclado en numérico
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? _selectedDate!.toString().split(' ')[0]
                            : '',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
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
                          'Register',
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
    );
  }
}
