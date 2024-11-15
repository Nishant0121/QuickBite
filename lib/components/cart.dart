import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_bite/model/user.dart';
import 'package:quick_bite/services/food.dart';

class UserCart extends StatefulWidget {
  const UserCart({super.key});

  @override
  State<UserCart> createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FoodService _foodService = FoodService();
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    var box = GetStorage();
    var loginUserMap = box.read('loginUser');
    if (loginUserMap != null) {
      var loginUser = AppUser.fromMap(loginUserMap);
      var cartSnapshot =
          await _firestore.collection('cart').doc(loginUser.uid).get();
      if (cartSnapshot.exists) {
        var cartData = cartSnapshot.data();
        if (cartData != null && cartData['foods'] != null) {
          setState(() {
            cartItems = List<Map<String, dynamic>>.from(cartData['foods']);
          });
        }
      }
    } else {
      setState(() {
        cartItems = [];
      });
    }
  }

  int parseInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.orange[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Added this to allow scrolling
          child: cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Column(
                  // Using Column instead of ListView to wrap all content
                  children: cartItems.map((item) {
                    int price = parseInt(item['price']);
                    int quantity = parseInt(item['quantity']);
                    int totalPrice = price * quantity;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: item['imageUrl'] != null
                                ? Image.network(
                                    item['imageUrl'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.image, size: 60),
                                  )
                                : const Icon(Icons.image,
                                    size: 60, color: Colors.grey),
                          ),
                          title: Text(
                            item['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price: ₹$price',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                'Quantity: $quantity',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total: ₹$totalPrice',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 7),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }
}
