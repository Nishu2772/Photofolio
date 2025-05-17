import 'dart:convert';

import 'package:Photofolio/ZoomPage.dart';
import 'package:Photofolio/model/ImageItem.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photofolio',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ImageItem> imageArray = [];

  fetchImages() async {
    //https://picsum.photos/v2/list?page=2&limit=100
    // https://picsum.photos/v2/list
    final response = await http.get(
      Uri.parse('https://picsum.photos/v2/list?page=2&limit=100'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      imageArray = data.map((json) => ImageItem.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade200, Colors.purple.shade300],
          ),
        ),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: SingleChildScrollView(
            child:
                imageArray.isEmpty
                    ? SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                    : Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.center,
                      children: List.generate(
                        imageArray.length,
                        (index) => getImageBox((imageArray[index].downloadUrl)),
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  getImageBox(String imgUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoZoomPage(galleryItems: imageArray),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        height: (MediaQuery.sizeOf(context).height * 50) / 100,
        width: (MediaQuery.sizeOf(context).width / 3) - (15 + 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        alignment: Alignment.center,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            imageBuilder:
                (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
            placeholder:
                (context, url) =>
                    CircularProgressIndicator(color: Colors.white),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        // child: Text("${index}"),
      ),
    );
  }
}
