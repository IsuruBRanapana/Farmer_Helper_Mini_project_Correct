import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmer_helper/app/home/home_page.dart';
import 'package:farmer_helper/app/sign_in/sign_in.dart';
import 'package:farmer_helper/services/auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth=Provider.of<AuthBase>(context,listen: false);
    return Container(
      child: StreamBuilder<User>(
          stream: auth.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.active) {
              User user = snapshot.data;
              if (user == null) {
                return SignInPage.create(context);
              }
              return HomePage();
            } else {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          }),
    );
  }
}
