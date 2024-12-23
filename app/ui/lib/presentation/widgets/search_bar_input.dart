import 'dart:async';
import 'package:flutter/material.dart';

typedef OnSearchCallback = void Function(String query);

class SearchBarInput extends StatefulWidget {
  final String hintText;
  final OnSearchCallback onSearch;
  final Duration debounceDuration;

  const SearchBarInput({
    Key? key,
    required this.hintText,
    required this.onSearch,
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _SearchBarInputState createState() => _SearchBarInputState();
}

class _SearchBarInputState extends State<SearchBarInput> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Trigger a rebuild to update the UI based on the current text
    setState(() {});

    // Debounce the search callback
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(widget.debounceDuration, () {
      widget.onSearch(_controller.text);
    });
  }

  void _onClearSearch() {
    _controller.clear();
    widget.onSearch('');

    // Rebuild the widget
    setState(() {});
  }

  void _onSubmitted(String query) {
    // Cancel the debounce timer to prevent duplicate calls
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    widget.onSearch(query);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(12),
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            onSubmitted: _onSubmitted, // Updated here
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _onClearSearch,
                      tooltip: 'Clear search',
                    ),
                ],
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      );
}
