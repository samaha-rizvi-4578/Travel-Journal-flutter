// lib/journal/presentation/pages/add_journal_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './../../../shared//utils/image_picker_helper.dart';
import './../../../journal/data/journal_model.dart';
import './../../../journal/data/journal_repository.dart';
import 'package:auth_repo/auth_repo.dart';
import 'package:auth_ui/auth_ui.dart';

class AddJournalPage extends StatefulWidget {
  const AddJournalPage({super.key});

  @override
  State<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController placeController;
  late TextEditingController budgetController;
  late TextEditingController notesController;

  String? imageUrl;
  bool visited = false;
  String selectedMood = 'Happy';

  final ImagePickerHelper _imagePicker = ImagePickerHelper();

  @override
  void initState() {
    super.initState();
    placeController = TextEditingController();
    budgetController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    placeController.dispose();
    budgetController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final user = context.read<AuthBloc>().state.user;
      if (user == null) return;

      final newJournal = TravelJournal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        placeName: placeController.text,
        imageUrl: imageUrl,
        notes: notesController.text,
        mood: selectedMood,
        visited: visited,
        userId: user.id,
        createdAt: Timestamp.now(),
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
      setState(() {
        imageUrl = pickedImage;
      });
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
              TextFormField(
                controller: placeController,
                decoration: const InputDecoration(labelText: 'Place Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Place name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Budget (Optional)'),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl!, height: 200, fit: BoxFit.cover),
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