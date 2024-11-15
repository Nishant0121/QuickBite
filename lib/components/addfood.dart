import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AddFood extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(int) togglePage; // Accept the togglePage function

  const AddFood({required this.userData, required this.togglePage, super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final _formKey = GlobalKey<FormState>();
  String? _title, _description, _price, _reviews;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.camera.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }

    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      print('Permission granted');
    } else {
      print('Permission denied');
    }
  }

  Future<void> pickImage() async {
    // Request camera permission
    await requestPermission();

    // Pick an image from the gallery
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Upload the image to Firebase Storage
      String filePath =
          'food_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      File file = File(image.path);
      await FirebaseStorage.instance.ref(filePath).putFile(file);
      String downloadUrl =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl; // Store the image URL
      });
    }
  }

  Future<void> addFood() async {
    if (_formKey.currentState!.validate() && _imageUrl != null) {
      _formKey.currentState!.save();

      // Save data to Firestore
      await FirebaseFirestore.instance.collection('foods').add({
        'title': _title,
        'description': _description,
        'price': _price,
        'reviews': _reviews,
        'imageUrl': _imageUrl,
        'userId': widget.userData['uid'],
      });

      // Clear form after submission
      _formKey.currentState!.reset();
      setState(() {
        _imageUrl = null;
      });

      print('Food added successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Food')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value,
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a price' : null,
                onSaved: (value) => _price = value,
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reviews'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter reviews' : null,
                onSaved: (value) => _reviews = value,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  if (_imageUrl == null)
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 205, 25),
                        ),
                        onPressed: pickImage,
                        child: const Text(
                          'Pick Image',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  if (_imageUrl != null)
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            20.0), // This makes the corners rounded
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                20.0), // Match the border radius
                            // Optional: Add a border
                          ),
                          child: Image.network(
                            _imageUrl!,
                            fit: BoxFit.cover, // Optional: Adjust the image fit
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // Display selected image
              const SizedBox(height: 16),
              if (_imageUrl != null)
                Expanded(
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: addFood,
                      child: const Text('Add Food'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
