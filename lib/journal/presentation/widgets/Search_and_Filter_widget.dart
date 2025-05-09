import 'package:flutter/material.dart';

class SearchAndFilterWidget extends StatefulWidget {
  final Function(String) onSearch;
  final Function(String) onFilter;

  const SearchAndFilterWidget({
    super.key,
    required this.onSearch,
    required this.onFilter,
  });

  @override
  State<SearchAndFilterWidget> createState() => _SearchAndFilterWidgetState();
}

class _SearchAndFilterWidgetState extends State<SearchAndFilterWidget> {
  String selectedFilter = 'None';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Search Field
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: widget.onSearch,
          ),
        ),
        const SizedBox(width: 8),

        // Filter Dropdown
        DropdownButton<String>(
          value: selectedFilter,
          items: const [
            DropdownMenuItem(value: 'None', child: Text('No Filter')),
            DropdownMenuItem(value: 'Budget', child: Text('Budget')),
            DropdownMenuItem(value: 'Visited', child: Text('Visited')),
            DropdownMenuItem(value: 'Wishlist', child: Text('Wishlist')),
            DropdownMenuItem(value: 'Alphabetical', child: Text('Alphabetical')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedFilter = value;
              });
              widget.onFilter(value);
            }
          },
        ),
      ],
    );
  }
}