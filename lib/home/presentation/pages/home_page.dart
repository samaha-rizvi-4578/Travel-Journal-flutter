import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_ui/auth_ui.dart';
import 'package:go_router/go_router.dart';
import './../../../../map/presentation/map_view.dart'; // Import the MapView widget
import './../../../../journal/presentation/pages/journal_feed_page.dart'; // Import JournalFeedPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const JournalFeedPage(),
    // Add other pages here if needed
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Add logo to the AppBar
            Image.asset(
              'assets/images/logoWhite.png', // Path to your logo image
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              'Wanderlog',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.teal[700],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(user?.email ?? 'Guest'),
          _buildJournalsTab(context),
          _buildLogoutDialog(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            _showLogoutDialog(context);
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        selectedItemColor: Colors.teal[700],
        unselectedItemColor: Colors.teal[400],
        backgroundColor: Colors.teal[50],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(String email) {
    return Container(
      
      color: Colors.teal[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, $email!',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.teal,
              ),
            ),
          ),
          const Expanded(
            child: MapView(),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalsTab(BuildContext context) {
    return const JournalFeedPage(); // Or any journal-related screen
  }

  Widget _buildLogoutDialog(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Logging out...',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: 16),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Logout",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.teal,
          ),
        ),
        content: const Text(
          "Are you sure you want to log out?",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.teal,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go('/');
              Navigator.of(context).pop(); // Close dialog after logout
            },
            child: const Text(
              "Logout",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}