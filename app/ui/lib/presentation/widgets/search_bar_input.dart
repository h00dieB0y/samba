import 'package:flutter/material.dart';

typedef OnSearchCallback = void Function(String query);

class SearchBarInput extends StatefulWidget {
  final String hintText;
  final OnSearchCallback onSearch;

  const SearchBarInput({super.key, required this.hintText, required this.onSearch});

  @override
  _SearchBarInputState createState() => _SearchBarInputState();
}

class _SearchBarInputState extends State<SearchBarInput> {

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Handle text changed
  }

  void _onSearch() {
    // Handle search
  }

  @override
  void dispose() {
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
            onSubmitted: widget.onSearch,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _controller.clear(),
                    ),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      );

}