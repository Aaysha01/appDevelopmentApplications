import 'package:flutter/material.dart';

import '../main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class home extends StatelessWidget {
  const home({Key? key}) : super(key: key);

  _tapButton() {
    debugPrint("Tapped");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("2D Editing Canvas"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.art_track_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
              );
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightGreen,
          hoverColor: Colors.red.shade400,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
          child: const Icon(Icons.art_track_outlined)),

      body:


          Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: new AssetImage('img33.jpg'),
                  //image: NetworkImage('https://picsum.photos/250?image=9'),

                  fit: BoxFit.fill,
                ),
              ),
              child:Column(
                children: [
                  Stack(
                      children:[
                        Opacity(
                          opacity: 0.5,
                          child:ClipPath(
                              clipper: waveclipper(),
                              child: Container(
                                  color: Colors.deepOrangeAccent, height: 170)
                          ),

                        ),
                        ClipPath(
                            clipper: waveclipper(),
                            child: Container(
                                color: Colors.pinkAccent, height: 150)
                        ),                   ]
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _getCard(context),
                      _getAvator(),
                    ],  ),
                ],
              )










          ),
    );
  }

  Container _getCard(context) {
    return Container(
        width: 350,
        height: 130,
        margin: EdgeInsets.only(top: 170.0),
        decoration: BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.circular(50.5),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("2D Canvas Editing"),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.person_outline),
                    Text("buildappswithAaaysha"),
                  ]),
              ElevatedButton(
                child: const Text('Lets\' Draw'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                onPressed: () {
                  // Navigate to second route when tapped.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                },
              ),
            ]));
  }

  Container _getAvator() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        border: Border.all(color: Colors.redAccent, width: 1.2),
        image: DecorationImage(
          image: new AssetImage('imager9X.jpg'),
          //image: NetworkImage('https://picsum.photos/250?image=9'),

          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class waveclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    debugPrint(size.width.toString());
    var path = new Path();
    path.lineTo(0,size.height);
    var firstStart =Offset(size.width/5, size.height);
    var firstEnd=Offset(size.width/2.25, size.height-50.0);
    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart=Offset(size.width-(size.width/3.24), size.height-105);
    var secondEnd=Offset(size.width, size.height-10);
    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width,0);
    path.close();
    return path;
    throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }

}

