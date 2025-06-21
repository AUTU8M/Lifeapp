import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final Function(Map<String, bool>) onApplyFilters;
  final Map<String, bool> initialFilters;

  const FilterPage({
    Key? key, 
    required this.onApplyFilters,
    required this.initialFilters,
  }) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}


class _FilterPageState extends State<FilterPage> {
  bool allFilter = false;
  bool teachersAssignedFilter = false;
  bool startFilter = false;
  bool pendingFilter = false;
  bool completedFilter = false;

  @override
  void initState() {
    super.initState();
    allFilter = widget.initialFilters['all'] ?? false;
    teachersAssignedFilter = widget.initialFilters['teachersAssigned'] ?? false;
    startFilter = widget.initialFilters['skipped'] ?? false;
    pendingFilter = widget.initialFilters['pending'] ?? false;
    completedFilter = widget.initialFilters['completed'] ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Vision',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filters title
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Filters',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          // Filter options
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildFilterOption('All', allFilter, (value) {
                  setState(() {
                    allFilter = value;
                  });
                }),
                const Divider(height: 1),
                _buildFilterOption('Teachers Assigned', teachersAssignedFilter, (value) {
                  setState(() {
                    teachersAssignedFilter = value;
                  });
                }),
                const Divider(height: 1),
                _buildFilterOption('Skipped', startFilter, (value) {
                  setState(() {
                    startFilter = value;
                  });
                }),
                const Divider(height: 1),
                _buildFilterOption('Pending', pendingFilter, (value) {
                  setState(() {
                    pendingFilter = value;
                  });
                }),
                const Divider(height: 1),
                _buildFilterOption('Completed', completedFilter, (value) {
                  setState(() {
                    completedFilter = value;
                  });
                }),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Reset button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _resetFilters,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue, 
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.blue.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                // Submit button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: Colors.blue.shade500,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
                
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      allFilter = false;
      teachersAssignedFilter = false;
      startFilter = false;
      pendingFilter = false;
      completedFilter = false;
    });
  }

  void _applyFilters() {
    // Create a map of the current filter states
    final filters = {
      'all': allFilter,
      'teachersAssigned': teachersAssignedFilter,
      'skipped': startFilter,
      'pending': pendingFilter,
      'completed': completedFilter,
    };
    
    // Pass filters back to parent
    widget.onApplyFilters(filters);
    
    // Close the filter page
    Navigator.of(context).pop(filters);
  }
}