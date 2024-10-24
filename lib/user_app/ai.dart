import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class GalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: GalleryScreen(),
    );
  }
}

class GalleryScreen extends StatelessWidget {
  final List<String> imageAssets = [
    'assets/user_app/menu_es_1.png',
    'assets/user_app/menu_es_2.png',
    'assets/user_app/menu_us_1.png',
    'assets/user_app/menu_us_2.png',
    'assets/user_app/desayuno_es_1.png',
    'assets/user_app/desayuno_es_2.png',
    // Add more image paths here
  ];

  final List<String> imageDescriptions = [
    'Menu En Español 1',
    'Menu En Español 2',
    'Menu In English 1',
    'Menu In English 2',
    'Dreakfast',
    'Desayuno',
    // Add more image descriptions here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Menu',
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
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 25,
        ),
        itemCount: imageAssets.length,
        physics: ScrollPhysics(), // Enable scrolling
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageDetailScreen(
                    imageAsset: imageAssets[index],
                    description: imageDescriptions[index],
                  ),
                ),
              );
            },
            child: Column(
              children: [
                SizedBox(height: 5),
                AspectRatio(
                  aspectRatio: 1.34, // Set the aspect ratio for a square container
                  child: Container(
                    height: 120,
                    width: 120, // Set a fixed height for the container
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: AssetImage(imageAssets[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  imageDescriptions[index],
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final String imageAsset;
  final String description;

  ImageDetailScreen({
    required this.imageAsset,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
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
      body: Container(
        child: PhotoView(
          imageProvider: AssetImage(imageAsset),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2.0,
          initialScale: PhotoViewComputedScale.contained,
        ),
      ),
    );
  }
}