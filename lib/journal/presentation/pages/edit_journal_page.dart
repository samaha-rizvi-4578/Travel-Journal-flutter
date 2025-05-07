import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './../../../journal/data/journal_model.dart';
import './../../../journal/data/journal_repository.dart';
import './../../../shared/utils/image_picker_helper.dart';
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
  late TextEditingController budgetController;
  late String selectedMood;
  late bool visited;
  String? imageUrl;
  String? selectedCountry;

  final ImagePickerHelper _imagePicker = ImagePickerHelper();

  @override
  void initState() {
    super.initState();
    final journal = widget.journal;

    // Initialize controllers and fields with existing journal data
    notesController = TextEditingController(text: journal.notes);
    budgetController = TextEditingController(
      text: journal.budget != null ? journal.budget.toString() : '',
    );
    selectedMood = journal.mood;
    visited = journal.visited;
    imageUrl = journal.imageUrl;
    selectedCountry = journal.placeName;
  }

  @override
  void dispose() {
    notesController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  Future<void> _updateJournal(BuildContext context) async {
    final updatedJournal = widget.journal.copyWith(
      notes: notesController.text,
      mood: selectedMood,
      visited: visited,
      imageUrl: imageUrl,
      budget: int.tryParse(budgetController.text), // Parse budget as integer
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
            // Display the country as read-only
            TextFormField(
              initialValue: selectedCountry,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Editable budget field
            TextFormField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Budget',
                suffixText: '\$USD', // Add currency suffix
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a budget';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Visited toggle
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

            // Mood dropdown
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

            // Notes field
            TextFormField(
              controller: notesController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Display the image if available
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Hero(
                tag: 'journal-image-${widget.journal.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl!, height: 200, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 16),

            // Change image button
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