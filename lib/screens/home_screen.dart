import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showWelcome = false;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _checkFirstLogin();
  }

  Future<void> _checkFirstLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
          
      if (doc.exists && doc.data()?['firstLogin'] == true) {
        setState(() {
          _showWelcome = true;
          _userName = doc.data()?['fullName'];
        });
        
        // Mark first login as complete
        await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'firstLogin': false});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Welcome to K53 Simulator!'),
            content: Text('Hello $_userName! Get ready to ace your driver\'s license test.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _showWelcome = false);
                },
                child: const Text('Get Started'),
              ),
            ],
          ),
        );
      });
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('K53 Simulator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          )
        ],
      ),
      body: const Center(
        child: Text('Welcome to K53 Simulator!'),
      ),
    );
  }
}