import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kafe_app/screens/blend/blend_screen.dart';
import 'package:kafe_app/screens/contest/contest_screen.dart';
import 'package:kafe_app/screens/drying/drying_screen.dart';
import 'package:kafe_app/screens/field/fields_screen.dart';
import 'package:provider/provider.dart';
import 'package:kafe_app/providers/player_provider.dart';

class MainScaffold extends StatefulWidget {

  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    FieldsScreen(),
    DryingScreen(),
    BlendScreen(),
    ContestScreen(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMenuSelected(String value) async {
    switch (value) {
      case 'account':
        GoRouter.of(context).pushReplacementNamed("account");
        break;
      case 'logout':
        await FirebaseAuth.instance.signOut(); 
        GoRouter.of(context).pushReplacementNamed("login");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>().player;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: null,
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'account',
                child: Text("Mon profil"),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text("Déconnexion"),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200], 
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.park), label: "Champs"),
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department), label: "Séchage"),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: "Assemblage"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Concours"),
        ],
      ),
    );
  }
}
