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
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: Colors.grey,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.teal),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.orange, width: 2),
              ),
            ),
            onChanged: widget.onSearch,
          ),
        ),
        const SizedBox(width: 8),

        // Filter Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.teal),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: selectedFilter,
            underline: const SizedBox(), // Remove default underline
            icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
            items: const [
              DropdownMenuItem(
                value: 'None',
                child: Text(
                  'No Filter',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Budget',
                child: Text(
                  'Budget',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Visited',
                child: Text(
                  'Visited',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Wishlist',
                child: Text(
                  'Wishlist',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Alphabetical',
                child: Text(
                  'Alphabetical',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
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
        ),
      ],
    );
  }
}