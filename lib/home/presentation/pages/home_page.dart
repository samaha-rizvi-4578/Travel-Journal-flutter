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

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;

    // Pages for each tab
    final List<Widget> _pages = [
      _buildHomeTab(user?.email ?? 'Guest'),
      const JournalFeedPage(), // Directly show the Journal Feed Page
      _buildLogoutTab(context),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Journal'),
        backgroundColor: Colors.teal[700], // Apply travel theme color
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.teal[700], // Active tab color
        unselectedItemColor: Colors.teal[400], // Inactive tab color
        backgroundColor: Colors.teal[50], // Background color
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

  // Home Tab
  Widget _buildHomeTab(String email) {
    return Container(
      color: Colors.teal[50], // Background color for the home tab
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, $email!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.teal[700], // Text color
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: MapView(), // Use the MapView widget here
          ),
        ],
      ),
    );
  }

  // Logout Tab
  Widget _buildLogoutTab(BuildContext context) {
    // Directly log out the user and redirect to the login page
    context.read<AuthBloc>().add(AuthLogoutRequested());
    context.go('/'); // Redirect to login page
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Come back soon!'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}