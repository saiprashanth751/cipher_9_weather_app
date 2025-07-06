import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLoading = false;
  String error = '';

  void attemptLogin() async {
  setState(() {
    isLoading = true;
    error = '';
  });

  final response = await http.post(
    Uri.parse('https://reqres.in/api/login'),
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': 'reqres-free-v1',
    },
    body: jsonEncode({
      'email': emailCtrl.text.trim(),
      'password': passCtrl.text.trim(),
    }),
  );

  setState(() => isLoading = false);

  if (response.statusCode == 200) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => WeatherScreen()),
    );
  } else {
    setState(() {
      error = 'Login failed';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passCtrl, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : attemptLogin,
              child: isLoading
                  ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text('Login'),
            ),
            if (error.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(error, style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}



class WeatherScreen extends StatefulWidget {
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    final city = 'London';

    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=51.5072&longitude=0.1276&current_weather=true'));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      setState(() {
        error = 'Could not load weather';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (isLoading) {
      body = Center(child: CircularProgressIndicator());
    } else if (error.isNotEmpty) {
      body = Center(child: Text(error));
    } else {
      final temp = weatherData!['current_weather']['temperature'];
      final wind = weatherData!['current_weather']['windspeed'];
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Weather in London', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Temperature: $temp°C', style: TextStyle(fontSize: 18)),
            Text('Wind Speed: $wind km/h', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Weather')),
      body: body,
    );
  }
}
