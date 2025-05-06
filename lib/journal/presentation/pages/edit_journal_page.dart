// lib/journal/presentation/pages/edit_journal_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import './../../../journal/data/journal_model.dart';
import './../../../journal/data/journal_repository.dart';
import './../../../shared/utils/image_picker_helper.dart';

class EditJournalPage extends StatefulWidget {
  final TravelJournal journal;

  const EditJournalPage({super.key, required this.journal});

  @override
  State<EditJournalPage> createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  late TextEditingController placeController;
  late TextEditingController notesController;
  late String selectedMood;
  late bool visited;
  String? imageUrl;

  final ImagePickerHelper _imagePicker = ImagePickerHelper();

  @override
  void initState() {
    super.initState();
    final journal = widget.journal;
    placeController = TextEditingController(text: journal.placeName);
    notesController = TextEditingController(text: journal.notes);
    selectedMood = journal.mood;
    visited = journal.visited;
    imageUrl = journal.imageUrl;
  }

  @override
  void dispose() {
    placeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _updateJournal(BuildContext context) async {
    final updatedJournal = widget.journal.copyWith(
      placeName: placeController.text,
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
      setState(() {
        imageUrl = pickedImage;
      });
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
            TextFormField(
              controller: placeController,
              decoration: const InputDecoration(labelText: 'Place Name'),
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