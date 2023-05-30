import 'package:assignment/Home/home.dart';
import 'package:assignment/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    // we can save userid and manage session using session controller
    Future.delayed(Duration(seconds: 1)).then((value) {
      _prefs.then((prefs) {
        bool isLogged = prefs.getBool("is_logged") ?? false;
        if (isLogged) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MyHomePage(title: "Daily Tasks"),
              ),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
              (Route<dynamic> route) => false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: 'Workruit',
                  style: TextStyle(color: Colors.green, fontSize: 18)),
              WidgetSpan(
                  child: SizedBox(
                width: 10,
              )),
              TextSpan(text: 'Assignment!'),
            ],
          ),
        ),
      ),
    );
  }
}
