import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:la_perla/user_app/bottom_bar_user.dart';

class EditProfileScreen extends StatefulWidget {
  final String DocumenName;

  const EditProfileScreen({Key? key, required this.DocumenName}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _secondLastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();

  late String _oldEmail; // Variable para almacenar el valor original del correo electrónico
  bool _emailExists = false;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _secondLastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void loadProfileData() async {
    await Firebase.initializeApp();
    final firestoreInstance = FirebaseFirestore.instance;
    DocumentSnapshot docSnapshot =
        await firestoreInstance.collection('users').doc(widget.DocumenName).get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _nameController.text = data['name'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _secondLastNameController.text = data['secondLastName'] ?? '';
        _emailController.text = data['email'] ?? '';
        _passwordController.text = data['password']?? '';
        _phoneController.text = data['phone'] ?? '';

        // Obtener la fecha de nacimiento de la base de datos
        dynamic dateOfBirth = data['dateOfBirth'];
        if (dateOfBirth != null) {
          if (dateOfBirth is Timestamp) {
            DateTime dateTime = dateOfBirth.toDate();
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
            _dateOfBirthController.text = formattedDate;
          } else if (dateOfBirth is String) {
            _dateOfBirthController.text = dateOfBirth;
          }
        }

        // Asignar el valor original del correo electrónico
        _oldEmail = _emailController.text;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
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

      await Firebase.initializeApp();
      final firestoreInstance = FirebaseFirestore.instance;

      if (_emailController.text != _oldEmail) {
        QuerySnapshot querySnapshot = await firestoreInstance
            .collection('users')
            .where('email', isEqualTo: _emailController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            _emailExists = true;
          });
          return;
        }
      }

      await firestoreInstance.collection('users').doc(widget.DocumenName).update({
        'name': _nameController.text,
        'lastName': _lastNameController.text,
        'secondLastName': _secondLastNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'phone': _phoneController.text,
        'dateOfBirth': _dateOfBirthController.text,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Profile updated successfully'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomBarUser(DocumentName: widget.DocumenName),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      _dateOfBirthController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
                    obscureText: true, // Ocultar el texto de la contraseña
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateOfBirthController,
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
                          'Update Profile',
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
