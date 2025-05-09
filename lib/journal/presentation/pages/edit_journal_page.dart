import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './../../../journal/data/journal_model.dart';
import './../../../journal/data/journal_repository.dart';
import './../../../shared/utils/image_picker_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './../../../journal/bloc/journal_bloc.dart';

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
      budget: int.tryParse(budgetController.text),
    );

    try {
      await context.read<JournalRepository>().updateJournal(updatedJournal);
      context.read<JournalBloc>().reloadJournals(); // Reload the journals
      Navigator.pop(context); // Go back to the updated journal's details page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating journal: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Journal',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          TextButton(
            onPressed: () => _updateJournal(context),
            child: const Text(
              'Save',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
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
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal,
                ),
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
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal,
                ),
                suffixText: '\$USD', // Add currency suffix
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Visited toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Visited',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal,
                  ),
                ),
                Switch(
                  value: visited,
                  activeColor: Colors.teal,
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
              decoration: const InputDecoration(
                labelText: 'Mood',
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Notes field
            TextFormField(
              controller: notesController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Notes',
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal,
                ),
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
                  child: Image.network(
                    imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Change image button
            
          ],
        ),
      ),
    );
  }
}