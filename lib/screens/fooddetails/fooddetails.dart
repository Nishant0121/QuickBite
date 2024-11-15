import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_bite/model/food.dart';
import 'package:quick_bite/model/user.dart';
import 'package:quick_bite/services/food.dart';

class FoodDetailScreen extends StatefulWidget {
  final Food food;

  const FoodDetailScreen({Key? key, required this.food}) : super(key: key);

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final FoodService _foodService = FoodService();
  int quantity = 1; // Default quantity is set to 1

  @override
  Widget build(BuildContext context) {
    var box = GetStorage();
    var loginUserMap = box.read('loginUser');
    var loginUser = loginUserMap != null ? AppUser.fromMap(loginUserMap) : null;

    print(widget.food.userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.title ?? 'Food Details'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image with Shadow
            if (widget.food.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Image.network(
                    widget.food.imageUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 80),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Food Title
            Text(
              widget.food.title ?? 'No Title',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Food Price
            Text(
              'Price: ₹${widget.food.price ?? 'N/A'}',
              style: const TextStyle(fontSize: 22, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Food Description
            Text(
              widget.food.description ?? 'No Description',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            // Quantity Selector Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quantity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.redAccent,
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (loginUser != null) {
                    await _foodService.addFoodToCart(
                        widget.food, loginUser, quantity);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('${widget.food.title} added to cart')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
