import 'package:flutter/material.dart';

typedef OnSearchCallback = void Function(String query);

class SearchBarInput extends StatefulWidget {
  final String hintText;
  final OnSearchCallback onSearch;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const SearchBarInput({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.controller,
    this.focusNode,
  });

  @override
  _SearchBarInputState createState() => _SearchBarInputState();
}

class _SearchBarInputState extends State<SearchBarInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool get _isControllerExternallyManaged => widget.controller != null;
  bool get _isFocusNodeExternallyManaged => widget.focusNode != null;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    // Listen to changes to update the UI (for the clear button)
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _onClearSearch() {
    _controller.clear();
    widget.onSearch('');

    if (!_isFocusNodeExternallyManaged) {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    if (!_isControllerExternallyManaged) {
      _controller.dispose();
    }
    if (!_isFocusNodeExternallyManaged) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
    elevation: 2,
    borderRadius: BorderRadius.circular(12),
    child: ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, child) {
        return TextField(
          key: const Key('search_bar_input_text_field'),
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onSubmitted: (query) {
            widget.onSearch(query.trim());
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    key: const Key('search_bar_input_clear_button'),
                    icon: const Icon(Icons.clear),
                    onPressed: _onClearSearch,
                    tooltip: 'Clear search',
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        );
      },
    ),
  );
}
