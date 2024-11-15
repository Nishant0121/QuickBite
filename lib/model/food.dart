import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String? description;
  final String? imageUrl;
  final String? price;
  final String? title;
  final String? reviews;
  final String? userId;

  Food({
    this.description,
    this.imageUrl,
    this.price,
    this.title,
    this.reviews,
    this.userId,
  });

  // Factory constructor to create a Food instance from Firestore data
  factory Food.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Food(
      description: data['description'] as String?,
      imageUrl: data['imageUrl'] as String?,
      price: data['price'] as String?,
      title: data['title'] as String?,
      reviews: data['reviews'] as String?,
      userId: data['userId'] as String?,
    );
  }
}
