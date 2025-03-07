import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_bite/screens/delivery/delivery.dart';
import 'package:quick_bite/screens/home/home.dart';
import 'package:quick_bite/screens/profile/profile.dart';

class MainPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const MainPage({required this.userData, super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Jump to the selected page
  }

  // Define a function to toggle between pages
  void togglePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var box = GetStorage();
    box.write('loginUser', widget.userData);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          Home(
            userData: widget.userData,
            togglePage: togglePage, // Pass the togglePage function to Home
          ),
          Delivery(
            userData: widget.userData,
            togglePage: togglePage, // Pass the togglePage function to Home
          ),
          Profile(
            userData: widget.userData,
            togglePage: togglePage, // Pass the togglePage function to Profile
          ),
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'Dilevery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
