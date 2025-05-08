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
        title: const Text('Travel Journal'),
        backgroundColor: Colors.teal[700],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(user?.email ?? 'Guest'),
          _buildJournalsTab(context),
          _buildLogoutDialog(context), // Show dialog instead of logging out immediately
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            // If Logout tab is selected, show confirmation dialog
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journals'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
      ),
    );
  }

  Widget _buildHomeTab(String email) {
    print('user email $email');
    return Container(
      color: Colors.teal[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, $email!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.teal[700],
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Expanded(child: MapView()),
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
          Text('Logging out...'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go('/');
              Navigator.of(context).pop(); // Close dialog after logout
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}