import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmer_helper/app/sign_in/email_sign_in_page.dart';
import 'package:farmer_helper/app/sign_in/sign_in_manager.dart';
import 'package:farmer_helper/app/sign_in/sign_in_button.dart';
import 'package:farmer_helper/app/sign_in/social_sign_in_button.dart';
import 'package:farmer_helper/common_widgets/platform_exception_alert_dialog.dart';
import 'package:farmer_helper/services/auth.dart';
import 'package:flutter/services.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);
  final SignInManager manager;
  final bool isLoading;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInErrors(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInErrors(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInErrors(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  void _showSignInErrors(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign In Fail',
      exception: exception,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return  ListView(
        children: <Widget>[
          SizedBox(
            child: _headerWidgetBuilder(),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 48.0,
                ),
                SocialSignInButton(
                  text: 'Sign In with Google',
                  assetName: 'images/google-logo.png',
                  color: Colors.white,
                  onPressed: isLoading ? null : () => _signInWithGoogle(context),
                  textColor: Colors.black87,
                  height: 40.0,
                ),
                SizedBox(
                  height: 8.0,
                ),
                SocialSignInButton(
                  assetName: 'images/facebook-logo.png',
                  text: 'Sign In with Facebook',
                  color: Color(0xFF334D92),
                  onPressed: isLoading ? null : () => _signInWithFacebook(context),
                  textColor: Colors.white,
                  height: 40.0,
                ),
                SizedBox(
                  height: 8.0,
                ),
                SignInButton(
                  text: 'Sign In with Email',
                  color: Colors.teal[700],
                  onPressed: isLoading ? null : () => _signInWithEmail(context),
                  textColor: Colors.white,
                  height: 40.0,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  'or',
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8.0,
                ),
                SignInButton(
                  text: 'Sign In Anonymous',
                  color: Colors.lime[300],
                  onPressed: isLoading ? null : () => _signInAnonymously(context),
                  textColor: Colors.black,
                  height: 40.0,
                ),
              ],
            ),
          ),
        ],
      );
  }

  Widget _headerWidgetBuilder() {
    if (isLoading) {
      return _frontImageWidget();
    } else {
      return _frontImageWidgetText();
    }
  }

  Stack _frontImageWidget() {
    return Stack(
      children: <Widget>[
        Container(
          height: 260.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0)),
            color: Colors.green[400],
            image: DecorationImage(
                image: AssetImage('images/Front.jpg'), fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                ),
                Text(
                  'Farmer Helper',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Welcome to Farmer Helper',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Stack _frontImageWidgetText() {
    return Stack(
      children: <Widget>[
        Container(
          height: 260.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0)),
            color: Colors.green[400],
            image: DecorationImage(
                image: AssetImage('images/Front.jpg'), fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                ),
                Text(
                  'Farmer Helper',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Welcome to Farmer Helper',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
