import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import './../../../shared/utils/image_picker_helper.dart';
import './../../../journal/data/journal_model.dart';
import './../../../journal/data/journal_repository.dart';
import 'package:auth_ui/auth_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import './../../../country_api/country_service.dart';

class AddJournalPage extends StatefulWidget {
  const AddJournalPage({super.key});

  @override
  State<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController budgetController;
  late TextEditingController notesController;

  String? imageUrl;
  bool visited = false;
  String selectedMood = 'Happy';

  final ImagePickerHelper _imagePicker = ImagePickerHelper();
  final CountryService _countryService = CountryService();

  List<Map<String, dynamic>> countries = [];
  String? selectedCountry;
  double? selectedLatitude;
  double? selectedLongitude;

  @override
  void initState() {
    super.initState();
    budgetController = TextEditingController();
    notesController = TextEditingController();

    _fetchCountries();
  }

  @override
  void dispose() {
    budgetController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _fetchCountries() async {
    try {
      final fetchedCountries = await _countryService.fetchCountries();
      fetchedCountries.sort((a, b) => a['name'].compareTo(b['name'])); // Sort alphabetically
      setState(() {
        countries = fetchedCountries;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching countries: $e")),
      );
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final user = context.read<AuthBloc>().state.user;
      if (user == null) return;

      final newJournal = TravelJournal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        placeName: selectedCountry ?? '',
        imageUrl: imageUrl,
        notes: notesController.text,
        mood: selectedMood,
        visited: visited,
        userId: user.id,
        createdAt: Timestamp.now(),
        latitude: selectedLatitude,
        longitude: selectedLongitude,
      );

      try {
        await context.read<JournalRepository>().addJournal(newJournal);
        Navigator.pop(context); // Go back to feed
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving journal: $e")),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await _imagePicker.pickImageFromGallery();
    if (pickedImage != null) {
      try {
        // Upload the image to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref();
        final imageRef = storageRef.child(
          'journal_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        final uploadTask = await imageRef.putFile(
          File(pickedImage),
        );

        // Get the download URL
        final downloadUrl = await imageRef.getDownloadURL();

        // Update the state with the image URL
        setState(() {
          imageUrl = downloadUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error uploading image: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Journal'),
        actions: [
          TextButton(
            onPressed: () => _submitForm(context),
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (countries.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true, // Enable search functionality
                    searchFieldProps: TextFieldProps(
                      decoration: const InputDecoration(
                        labelText: 'Search Country',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  items: countries.map((country) => country['name'] as String).toList(),
                  selectedItem: selectedCountry,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Country',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  onChanged: (value) {
                    final country =
                        countries.firstWhere((c) => c['name'] == value);
                    setState(() {
                      selectedCountry = country['name'];
                      selectedLatitude = country['latitude'];
                      selectedLongitude = country['longitude'];
                    });
                  },
                  validator: (value) =>
                      value == null || value.isEmpty
                          ? 'Please select a country'
                          : null,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Budget (Optional)',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Visited'),
                  Switch(
                    value: visited,
                    onChanged: (value) {
                      setState(() {
                        visited = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMood,
                items: const [
                  DropdownMenuItem(value: 'Happy', child: Text('Happy')),
                  DropdownMenuItem(value: 'Excited', child: Text('Excited')),
                  DropdownMenuItem(value: 'Relaxed', child: Text('Relaxed')),
                  DropdownMenuItem(
                    value: 'Adventurous',
                    child: Text('Adventurous'),
                  ),
                  DropdownMenuItem(
                    value: 'Reflective',
                    child: Text('Reflective'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedMood = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Mood'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: notesController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              if (imageUrl != null && imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Add Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}