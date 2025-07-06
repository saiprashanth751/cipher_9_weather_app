import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      setState(() {
        isDone = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isDone ? OnboardingScreen() : Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  double opacity1 = 0;
  double opacity2 = 0;
  double opacity3 = 0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), () => setState(() => opacity1 = 1));
    Timer(Duration(milliseconds: 1000), () => setState(() => opacity2 = 1));
    Timer(Duration(milliseconds: 1500), () => setState(() => opacity3 = 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: opacity1,
              duration: Duration(milliseconds: 800),
              child: Text(
                'Welcome to Flutter App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: opacity2,
              duration: Duration(milliseconds: 800),
              child: Text(
                'Build beautiful UIs',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: opacity3,
              duration: Duration(milliseconds: 800),
              child: Text(
                'Fast development, expressive design',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
