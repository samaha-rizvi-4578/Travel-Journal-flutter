// main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:auth_repo/auth_repo.dart'; // Make sure this is correct
import 'firebase_options.dart';
import 'app.dart';

// ✅ Declare global repository
late final AuthRepository globalAuthRepo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Initialize global repository
  final authRepo = AuthRepository();
  globalAuthRepo = authRepo;

  runApp(App(authRepo: authRepo));
}
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:auth_repo/auth_repo.dart';
// import 'package:auth_ui/auth_ui.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp(authRepo: AuthRepository()));
// }

// // 1. Wishlist Item Model
// class WishlistItem {
//   final String? id;
//   final String place;
//   final int people;
//   final String reason;
//   final DateTime date;
//   final bool visited;
//   final String userId;

//   WishlistItem({
//     this.id,
//     required this.place,
//     required this.people,
//     required this.reason,
//     required this.date,
//     required this.visited,
//     required this.userId,
//   });

//   Map<String, dynamic> toMap() => {
//         'place': place,
//         'people': people,
//         'reason': reason,
//         'date': date.millisecondsSinceEpoch,
//         'visited': visited,
//         'userId': userId,
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//   factory WishlistItem.fromMap(String id, Map<String, dynamic> map) => WishlistItem(
//         id: id,
//         place: map['place'] ?? '',
//         people: (map['people'] ?? 0).toInt(),
//         reason: map['reason'] ?? '',
//         date: DateTime.fromMillisecondsSinceEpoch(map['date']),
//         visited: map['visited'] ?? false,
//         userId: map['userId'] ?? '',
//       );

//   WishlistItem copyWith({
//     String? id,
//     String? place,
//     int? people,
//     String? reason,
//     DateTime? date,
//     bool? visited,
//     String? userId,
//   }) {
//     return WishlistItem(
//       id: id ?? this.id,
//       place: place ?? this.place,
//       people: people ?? this.people,
//       reason: reason ?? this.reason,
//       date: date ?? this.date,
//       visited: visited ?? this.visited,
//       userId: userId ?? this.userId,
//     );
//   }
// }

// // 2. Wishlist Repository
// class WishlistRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Stream<List<WishlistItem>> getWishlist(String userId) {
//     return _firestore
//         .collection('wishlists')
//         .where('userId', isEqualTo: userId)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => WishlistItem.fromMap(doc.id, doc.data()))
//             .toList());
//   }

//   Future<void> saveItem(WishlistItem item) async {
//     try {
//       if (item.id == null) {
//         await _firestore.collection('wishlists').add(item.toMap());
//       } else {
//         await _firestore.collection('wishlists').doc(item.id).set(item.toMap());
//       }
//     } catch (e) {
//       debugPrint("Error saving item: $e");
//       rethrow;
//     }
//   }

//   Future<void> deleteItem(String itemId) async {
//     try {
//       await _firestore.collection('wishlists').doc(itemId).delete();
//     } catch (e) {
//       debugPrint("Error deleting item: $e");
//       rethrow;
//     }
//   }
// }

// // 3. Main App Widget
// class MyApp extends StatelessWidget {
//   final AuthRepository authRepo;
//   final WishlistRepository wishlistRepo = WishlistRepository();

//   MyApp({super.key, required this.authRepo});

//   PageRouteBuilder _fadeRoute(Widget screen) {
//     return PageRouteBuilder(
//       pageBuilder: (_, __, ___) => screen,
//       transitionsBuilder: (_, animation, __, child) {
//         return FadeTransition(
//           opacity: animation,
//           child: child,
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 300),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiRepositoryProvider(
//       providers: [
//         RepositoryProvider.value(value: authRepo),
//         RepositoryProvider.value(value: wishlistRepo),
//       ],
//       child: BlocProvider(
//         create: (_) => AuthBloc(authRepo: authRepo)..add(AuthUserChanged(authRepo.currentUser)),
//         child: MaterialApp(
//           title: 'Travel Journal',
//           theme: ThemeData(
//             useMaterial3: true,
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: Colors.teal,
//               brightness: Brightness.light,
//             ),
//             textTheme: GoogleFonts.poppinsTextTheme(),
//             scaffoldBackgroundColor: const Color(0xFFF2FAF9),
//             appBarTheme: const AppBarTheme(
//               backgroundColor: Color(0xFFB2DFDB),
//               foregroundColor: Colors.black87,
//               elevation: 0,
//             ),
//             inputDecorationTheme: InputDecorationTheme(
//               filled: true,
//               fillColor: Colors.teal[50],
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               labelStyle: const TextStyle(color: Colors.teal),
//             ),
//             iconTheme: const IconThemeData(color: Colors.teal),
//           ),
//           onGenerateRoute: (settings) {
//             switch (settings.name) {
//               case '/':
//                 return _fadeRoute(const LoginScreen());
//               case '/home':
//                 return _fadeRoute(const HomeScreen());
//               case '/wishlist':
//                 return _fadeRoute(const WishlistScreen());
//               default:
//                 return null;
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// // 4. Home Screen
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = context.select((AuthBloc bloc) => bloc.state.user);
//     final username = user?.email?.split('@').first ?? 'Traveler';

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green[800],
//         title: Column(
//           children: [
//             Text('VOYAGER', 
//                 style: GoogleFonts.playfairDisplay(
//                   fontSize: 22, 
//                   fontWeight: FontWeight.w700, 
//                   color: Colors.white)),
//             Text('Welcome, $username', 
//                 style: const TextStyle(fontSize: 14, color: Colors.white70)),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               context.read<AuthBloc>().add(AuthLogoutRequested());
//               Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
//             },
//             child: const Text('LOGOUT', 
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//       body: _buildBody(context),
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Travel Journal', 
//                     style: GoogleFonts.playfairDisplay(
//                       fontSize: 36, 
//                       fontWeight: FontWeight.w700)),
//                 const SizedBox(height: 8),
//                 Container(height: 3, width: 350, color: Colors.green[800]),
//                 const SizedBox(height: 24),
//                 Text("What's your adventure plan?", 
//                     style: GoogleFonts.roboto(
//                       fontSize: 24, 
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green[800],
//                     )),
//                 const SizedBox(height: 12),
//                 Text(
//                   "We'll help you document every step of your incredible journey",
//                   style: GoogleFonts.roboto(fontSize: 18),
//                 ),
//                 const SizedBox(height: 32),
//                 _buildActionButtons(context),
//               ],
//             ),
//           ),
//           if (MediaQuery.of(context).size.width > 800)
//             Image.asset('assets/travel.png', height: 300),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () => Navigator.pushNamed(context, '/wishlist'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green[800],
//               padding: const EdgeInsets.symmetric(vertical: 16),
//             ),
//             child: const Text('MY WISHLIST', style: TextStyle(fontSize: 16)),
//           ),
//         ),
//         const SizedBox(height: 16),
//         SizedBox(
//           width: double.infinity,
//           child: OutlinedButton(
//             onPressed: () {},
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               side: BorderSide(color: Colors.green[800]!),
//             ),
//             child: Text('COMMUNITY JOURNALS', 
//               style: TextStyle(color: Colors.green[800], fontSize: 16)),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // 5. Wishlist Screen
// class WishlistScreen extends StatefulWidget {
//   const WishlistScreen({super.key});

//   @override
//   State<WishlistScreen> createState() => _WishlistScreenState();
// }

// class _WishlistScreenState extends State<WishlistScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _placeController = TextEditingController();
//   final TextEditingController _peopleController = TextEditingController();
//   final TextEditingController _reasonController = TextEditingController();
//   DateTime? _selectedDate;
//   final WishlistRepository _wishlistRepo = WishlistRepository();

//   @override
//   void dispose() {
//     _placeController.dispose();
//     _peopleController.dispose();
//     _reasonController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = context.select((AuthBloc bloc) => bloc.state.user);
    
//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: Text('Please login to view your wishlist')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green[800],
//         title: const Text('My Travel Wishlist'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _showAddItemDialog(context, user.id),
//           ),
//         ],
//       ),
//       body: StreamBuilder<List<WishlistItem>>(
//         stream: _wishlistRepo.getWishlist(user.id),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final items = snapshot.data ?? [];

//           if (items.isEmpty) {
//             return const Center(child: Text('No destinations added yet'));
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: items.length,
//             itemBuilder: (context, index) => _buildWishlistItem(items[index]),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildWishlistItem(WishlistItem item) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(item.place, style: const TextStyle(
//                   fontSize: 20, fontWeight: FontWeight.bold)),
//                 Checkbox(
//                   value: item.visited,
//                   onChanged: (value) => _wishlistRepo.saveItem(
//                     item.copyWith(visited: value ?? false),
//                   ),
//                 ),
//               ],
//             ),
//             _buildDetailRow(Icons.people, '${item.people} people'),
//             _buildDetailRow(Icons.flag, item.reason),
//             _buildDetailRow(
//               Icons.calendar_today, 
//               DateFormat('MMM dd, yyyy').format(item.date),
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () => _wishlistRepo.deleteItem(item.id!),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: Colors.green[800]),
//           const SizedBox(width: 8),
//           Text(text),
//         ],
//       ),
//     );
//   }

//   void _showAddItemDialog(BuildContext context, String userId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add New Destination'),
//         content: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(
//                   controller: _placeController,
//                   decoration: const InputDecoration(labelText: 'Place Name'),
//                   validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                 ),
//                 TextFormField(
//                   controller: _peopleController,
//                   decoration: const InputDecoration(labelText: 'Number of People'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                 ),
//                 TextFormField(
//                   controller: _reasonController,
//                   decoration: const InputDecoration(labelText: 'Reason for Visiting'),
//                   validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                 ),
//                 TextButton(
//                   child: Text(_selectedDate == null 
//                       ? 'Select Date' 
//                       : DateFormat('MMM dd, yyyy').format(_selectedDate!)),
//                   onPressed: () async {
//                     final date = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2100),
//                     );
//                     if (date != null) setState(() => _selectedDate = date);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => _addItem(context, userId),
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _addItem(BuildContext context, String userId) async {
//     if (_formKey.currentState!.validate() && _selectedDate != null) {
//       try {
//         await _wishlistRepo.saveItem(
//           WishlistItem(
//             place: _placeController.text,
//             people: int.parse(_peopleController.text),
//             reason: _reasonController.text,
//             date: _selectedDate!,
//             visited: false,
//             userId: userId,
//           ),
//         );
//         _placeController.clear();
//         _peopleController.clear();
//         _reasonController.clear();
//         setState(() => _selectedDate = null);
//         if (mounted) Navigator.pop(context);
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to add: $e')),
//           );
//         }
//       }
//     }
//   }
// }