import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/model/food.dart';
import 'package:quick_bite/model/user.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Food>> getFood() async {
    List<Food> foodList = [];

    try {
      // Query the 'foods' collection in Firestore
      QuerySnapshot querySnapshot = await _firestore.collection('foods').get();

      // Map each document to a Food instance and add to foodList
      foodList =
          querySnapshot.docs.map((doc) => Food.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching food data: $e');
    }

    return foodList;
  }

  //add food to cart
  Future<void> addFoodToCart(Food food, AppUser user, quantity) async {
    try {
      // Reference to the user's cart document
      final userCartDoc = _firestore.collection('cart').doc(user.uid);

      // Check if the user's cart document already exists
      final cartDocSnapshot = await userCartDoc.get();

      // Food item data to add
      final foodData = {
        'title': food.title,
        'description': food.description,
        'price': food.price,
        'quantity': quantity,
        'reviews': food.reviews,
        'imageUrl': food.imageUrl,
      };

      if (cartDocSnapshot.exists) {
        // If the document exists, update the `foods` array by adding the new food item
        await userCartDoc.update({
          'foods': FieldValue.arrayUnion([foodData]),
        });
      } else {
        // If the document doesn't exist, create it with a `foods` array containing the food item
        await userCartDoc.set({
          'userId': user.uid,
          'foods': [foodData],
        });
      }
    } catch (e) {
      print('Error adding food to cart: $e');
    }
  }

  // function to get the user's cart data
  Future<Map<String, dynamic>?> getUserCart(user) async {
    try {
      // Reference to the user's cart document
      final userCartDoc = _firestore.collection('cart').doc(user.uid);

      // Get the document snapshot
      final cartDocSnapshot = await userCartDoc.get();

      // Check if the document exists
      if (cartDocSnapshot.exists) {
        // Return the cart data as a map
        return cartDocSnapshot.data() as Map<String, dynamic>?;
      } else {
        // If the document doesn't exist, return null
        return null;
      }
    } catch (e) {
      print('Error fetching user cart: $e');
      return null;
    }
  }
}
