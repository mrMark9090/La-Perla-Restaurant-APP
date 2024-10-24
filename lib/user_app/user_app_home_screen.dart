import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:la_perla/introduction_animation/components/login_view.dart';
import 'package:la_perla/user_app/coment_screen.dart';

class UserAppHomeScreen extends StatefulWidget {
  final String DocumentName;

  UserAppHomeScreen({required this.DocumentName});

  @override
  _UserAppHomeScreenState createState() => _UserAppHomeScreenState();
}

class _UserAppHomeScreenState extends State<UserAppHomeScreen> {
  String userName = '';
  List<String> imageAssets = [
    'assets/user_app/principal_1.jpg',
    'assets/user_app/principal_2.jpg',
    'assets/user_app/principal_3.jpg',
    'assets/user_app/principal_4.jpg',
    'assets/user_app/principal_5.jpg',
    'assets/user_app/principal_6.jpg',
    'assets/user_app/principal_7.jpg',
    'assets/user_app/principal_8.jpg',
  ];

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;

      // Obtain the document with the provided name
      DocumentSnapshot documentSnapshot = await firestoreInstance
          .collection('users')
          .doc(widget.DocumentName)
          .get();

      // Check if the document exists and get the 'name' field
      if (documentSnapshot.exists) {
        setState(() {
          userName = documentSnapshot.get('name');
        });
      }
    } catch (e) {
      print('Error obtaining the user name: $e');
    }
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginForm()),
      (route) => false,
    );
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
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
            ),
            items: imageAssets.map((imageAsset) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Hero(
                      tag: imageAsset,
                      child: Image.asset(
                        imageAsset,
                        fit: BoxFit.cover,
                        width: 1000,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Restaurant “La Perla”',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Restaurant “La Perla” has become one of the favorite spots for breakfast and brunches served in the local way. We also offer casual lunches and romantic dinners during sunsets with your feet in the sand or at our terraces overlooking La Ropa beach and Zihuatanejo Bay.\n\nLocated in the most famous beach in Ixtapa – Zihuatanejo “La Ropa beach” and founded by Don Francisco Ibarra Valdovinos + and Doña Raquel Rivera Bustos, we offer traditional local cuisine based on red snapper whole fish grilled on both sides and served with garlic and fresh tortillas, spiny Pacific lobsters, mahi-mahi, octopus, squid, jumbo and medium-size shrimp, crayfish, fresh clams and oysters, conch, scallops. We also serve poultry and beef, and Mexican cuisine dishes like chiles rellenos, enchiladas, tacos, sopes, and quesadillas.\n\nRestaurant “La Perla” offers dinners a memorable dining romantic event in which you can enjoy the most amazing sunsets in Zihuatanejo on La Ropa beach while viewing the seagulls and the ocean.',
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'OUR SERVICES',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Once you arrive at La Perla and look around, you can see they take lots of dedication and pride in their work. Restaurant La Perla is more than just the food we serve; your spirit will be pleased as you see our gardens full of native plants and flowers. Doña Raquel, the owner, farms her own tomatoes, chilies, spearmint, epazote, and other fine herbs used in our kitchen and bar.\n\nLa Perla Restaurant has 2 full bars. One bar is led by Javier Ibarra Rivera, the youngest brother, and fluent in English, pleasing his customers at the bar with his stories and oldies music from the 70s and 80s (Rolling Stones, Bryan Adams, Dire Straits, Eric Clapton, Credence Clearwater Revival…).\n\nZIHUATANEJO SPORTS BAR LA PERLA\n\nLa Perla Sports Bar has been open for 25 years, offering TV satellite sports and news service. We have a very nice bar overlooking the beach and the bay while you are watching your favorite games: NHL Sunday ticket, College football and Basketball. Please call ahead to make sure we have the game and seat available for you. The Sports Bar is led by Francisco Ibarra Rivera and his assistant Jesus (Chucho).',
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16),
                      Text(
                        'OUR SERVICES',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Once you arrive at La Perla and look around, you can see they take lots of dedication and pride in their work. Restaurant La Perla is more than just the food we serve; your spirit will be pleased as you see our gardens full of native plants and flowers. Doña Raquel, the owner, farms her own tomatoes, chilies, spearmint, epazote, and other fine herbs used in our kitchen and bar.\n\nLa Perla Restaurant has 2 full bars. One bar is led by Javier Ibarra Rivera, the youngest brother, and fluent in English, pleasing his customers at the bar with his stories and oldies music from the 70s and 80s (Rolling Stones, Bryan Adams, Dire Straits, Eric Clapton, Credence Clearwater Revival…).\n\nZIHUATANEJO SPORTS BAR LA PERLA\n\nLa Perla Sports Bar has been open for 25 years, offering TV satellite sports and news service. We have a very nice bar overlooking the beach and the bay while you are watching your favorite games: NHL Sunday ticket, College football and Basketball. Please call ahead to make sure we have the game and seat available for you. The Sports Bar is led by Francisco Ibarra Rivera and his assistant Jesus (Chucho).',
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'For more information:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Phone: (from USA) 011 (52) 755 554-2700'),
                      Text('Fax: (from USA) 011 (52) 755 554-5095'),
                      Text('Cell: +52 755 557-0149'),
                      Text('e-mail: laperla_zihua@yahoo.com.mx'),
                      Text('Playa La Ropa S/N Col. La Ropa, Zihuatanejo, Gro. México C.P. 40880'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToComentariosScreen,
        child: Icon(Icons.comment),
        backgroundColor: Color.fromARGB(255, 24, 21, 44),
      ),
    );
  }

  void navigateToComentariosScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComentariosScreen(DocumenName: widget.DocumentName),
      ),
    );
  }
}
