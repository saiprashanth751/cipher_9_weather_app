import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';

  void validateLogin() {
    String u = usernameController.text;
    String p = passwordController.text;
    if (u == 'admin' && p == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CartScreen()),
      );
    } else {
      setState(() {
        error = 'Invalid credentials';
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
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: validateLogin, child: Text('Login')),
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

class CartScreen extends StatelessWidget {
  final List<String> availableItems = [
    'Apples',
    'Bananas',
    'Oranges',
    'Mangoes',
    'Pineapples'
  ];

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Shopping Cart')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Available Items:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: availableItems.map((item) {
                return ElevatedButton(
                  onPressed: () => cart.addItem(item),
                  child: Text('Add $item'),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Text('Cart Items:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (_, index) {
                  final item = cart.items[index];
                  return ListTile(
                    title: Text(item),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => cart.removeItem(item),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartProvider extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => _items;

  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String item) {
    _items.remove(item);
    notifyListeners();
  }
}
