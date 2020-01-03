import 'package:flutter/material.dart';
import 'package:farmer_helper/app/landing_page.dart';
import 'package:farmer_helper/services/auth.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Farmer Helper',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: LandingPage(),
      ),
    );
  }
}
