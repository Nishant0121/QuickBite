import 'package:flutter/material.dart';
import 'package:quick_bite/model/food.dart';
import 'package:quick_bite/services/food.dart';

class Delivery extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(int) togglePage;

  const Delivery({required this.userData, required this.togglePage, super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  bool isLoading = true;
  List<Food> foodList = [];
  final FoodService _foodService = FoodService();

  @override
  void initState() {
    super.initState();
    getFoodList();
  }

  Future<void> getFoodList() async {
    setState(() {
      isLoading = true;
    });

    // Fetch food items and take only the first 10
    List<Food> fetchedFoodList = await _foodService.getFood();

    // Check if the widget is still mounted before updating state
    if (mounted) {
      setState(() {
        foodList = fetchedFoodList.take(10).toList(); // Only keep the first 10
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                childAspectRatio:
                    0.75, // Adjust the aspect ratio to your liking
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                final food = foodList[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/foodDetails',
                      arguments: food),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the food image at the top

                        Expanded(
                          child: food.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Image.network(
                                    food.imageUrl!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error),
                                  ),
                                )
                              : const Icon(Icons.image_not_supported,
                                  size: 80, color: Colors.grey),
                        ),

                        // Display the food title, price, and description
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.title ?? 'No Title',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Price: ${food.price ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                food.description ?? 'No Description',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    // Call the superclass's dispose method
    super.dispose();
  }
}
