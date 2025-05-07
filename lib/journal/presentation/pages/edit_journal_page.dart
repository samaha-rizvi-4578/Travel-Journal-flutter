import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import './../../../journal/data/journal_model.dart';
import './../../../journal/data/journal_repository.dart';
import './../../../shared/utils/image_picker_helper.dart';
import './../../../country_api/country_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditJournalPage extends StatefulWidget {
  final TravelJournal journal;

  const EditJournalPage({super.key, required this.journal});

  @override
  State<EditJournalPage> createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  late TextEditingController notesController;
  late String selectedMood;
  late bool visited;
  String? imageUrl;

  final ImagePickerHelper _imagePicker = ImagePickerHelper();
  final CountryService _countryService = CountryService();

  List<Map<String, dynamic>> countries = [];
  String? selectedCountry;
  double? selectedLatitude;
  double? selectedLongitude;

  @override
  void initState() {
    super.initState();
    final journal = widget.journal;

    // Initialize controllers and fields with existing journal data
    notesController = TextEditingController(text: journal.notes);
    selectedMood = journal.mood;
    visited = journal.visited;
    imageUrl = journal.imageUrl;
    selectedCountry = journal.placeName;
    selectedLatitude = journal.latitude;
    selectedLongitude = journal.longitude;

    _fetchCountries();
  }

  @override
  void dispose() {
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

  Future<void> _updateJournal(BuildContext context) async {
    final updatedJournal = widget.journal.copyWith(
      placeName: selectedCountry,
      latitude: selectedLatitude,
      longitude: selectedLongitude,
      notes: notesController.text,
      mood: selectedMood,
      visited: visited,
      imageUrl: imageUrl,
    );

    try {
      await context.read<JournalRepository>().updateJournal(updatedJournal);
      Navigator.pop(context); // Go back to detail page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating journal: $e")),
      );
    }
  }

  Future<void> _pickImage(BuildContext context) async {
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

        // Update the state with the new image URL
        setState(() {
          imageUrl = downloadUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading image: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Journal'),
        actions: [
          TextButton(
            onPressed: () => _updateJournal(context),
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  final country = countries.firstWhere((c) => c['name'] == value);
                  setState(() {
                    selectedCountry = country['name'];
                    selectedLatitude = country['latitude'];
                    selectedLongitude = country['longitude'];
                  });
                },
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
                DropdownMenuItem(value: 'Adventurous', child: Text('Adventurous')),
                DropdownMenuItem(value: 'Reflective', child: Text('Reflective')),
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
              Hero(
                tag: 'journal-image-${widget.journal.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl!, height: 200, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _pickImage(context),
              icon: const Icon(Icons.image),
              label: const Text('Change Image'),
            ),
          ],
        ),
      ),
    );
  }
}