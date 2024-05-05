import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class CoffeeItem {
  final String name;
  final double price;
  final String imageAsset;

  CoffeeItem({required this.name, required this.price, required this.imageAsset});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CoffeeMenu(),
    );
  }
}

class CoffeeMenu extends StatefulWidget {
  @override
  _CoffeeMenuState createState() => _CoffeeMenuState();
}

class _CoffeeMenuState extends State<CoffeeMenu> {
  final List<CoffeeItem> _menuItems = [
    CoffeeItem(name: 'Espresso', price: 7, imageAsset: 'assets/espresso.png'),
    CoffeeItem(name: 'Latte', price: 13, imageAsset: 'assets/latte.png'),
    CoffeeItem(name: 'Cappuccino', price: 11, imageAsset: 'assets/cappuccino.png'),
    CoffeeItem(name: 'Mocha', price: 14, imageAsset: 'assets/mocha.png'),
  ];

  final Map<CoffeeItem, int> _cartItems = {};

  double _totalPrice = 0.0;

  void _addToCart(CoffeeItem item) {
    setState(() {
      if (_cartItems.containsKey(item)) {
        _cartItems[item] = _cartItems[item]! + 1;
      } else {
        _cartItems[item] = 1;
      }
      _totalPrice += item.price;
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
      _totalPrice = 0.0;
    });
  }

  void _navigateToOrderSummary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSummary(
          cartItems: _cartItems,
          totalPrice: _totalPrice,
          onOrderSubmitted: () => _clearCart(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 7),
        child: Container(
          color: Colors.blue, // Set background color to blue
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Center(
            child: Text(
              'Coffee Shop',
              style: TextStyle(
                color: Colors.white, // Set text color to white
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.brown, // Set background color to light brown
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Image.asset(
                        item.imageAsset,
                        width: 50,
                        height: 50,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.name),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _addToCart(item),
                          ),
                        ],
                      ),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total: \$${_totalPrice.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20,color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _clearCart(),
                  child: const Text('Clear Cart'),
                ),
                ElevatedButton(
                  onPressed: () => _navigateToOrderSummary(context),
                  style: ElevatedButton.styleFrom(
                  ),
                  child: const Text('View Order'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Exit the app
                SystemNavigator.pop();
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final Map<CoffeeItem, int> cartItems;
  final double totalPrice;
  final VoidCallback onOrderSubmitted;

  OrderSummary({
    required this.cartItems,
    required this.totalPrice,
    required this.onOrderSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 6),
        child: AppBar(
          backgroundColor: Colors.blue, // Set background color to blue
          title: const Text(
            'Order Summary',
            style: TextStyle(
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.brown, // Set background color to light brown
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems.keys.elementAt(index);
                  final quantity = cartItems[item];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Image.asset(
                        item.imageAsset,
                        width: 50,
                        height: 50,
                      ),
                      title: Text('$quantity ${item.name}'),
                      subtitle: Text('\$${(item.price * quantity!).toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20,color: Colors.white),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  onOrderSubmitted();
                  Navigator.pop(context);
                },
                child: const Text('Submit Order'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}