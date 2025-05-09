import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import './../../../journal/data/journal_model.dart';
import './../../../journal/data/journal_repository.dart';
import 'package:auth_ui/auth_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './../../../country_api/country_service.dart';
import './../../../journal/bloc/journal_bloc.dart';

class AddJournalPage extends StatefulWidget {
  const AddJournalPage({super.key});

  @override
  State<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController budgetController;
  late TextEditingController notesController;

  bool visited = false;
  String selectedMood = 'Happy';

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
      fetchedCountries.sort((a, b) => a['name'].compareTo(b['name']));
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
      imageUrl: null,
      notes: notesController.text,
      mood: selectedMood,
      visited: visited,
      userEmail: user.email,
      createdAt: Timestamp.now(),
      latitude: selectedLatitude,
      longitude: selectedLongitude,
      budget: int.tryParse(budgetController.text),
    );

    try {
      await context.read<JournalRepository>().addJournal(newJournal);
      context.read<JournalBloc>().reloadJournals(); // Reload the journals
      Navigator.pop(context); // Go back to the "My Journals" tab
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving journal: $e")),
      );
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
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: const InputDecoration(
                        labelText: 'Search Country',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  items: countries.map((c) => c['name'] as String).toList(),
                  selectedItem: selectedCountry,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Country',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  onChanged: (value) {
                    final country = countries.firstWhere(
                      (c) => c['name'] == value,
                    );
                    setState(() {
                      selectedCountry = country['name'];
                      selectedLatitude = country['latitude'];
                      selectedLongitude = country['longitude'];
                    });
                  },
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please select a country' : null,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Budget',
                  suffixText: '\$USD',
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
            ],
          ),
        ),
      ),
    );
  }
}