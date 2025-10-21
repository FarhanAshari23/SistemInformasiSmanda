import 'package:flutter/material.dart';

class AppDropdownField extends StatelessWidget {
  final String hint;
  final double width;
  final List<DropdownMenuEntry<String>> items;
  final ValueChanged<String?> onSelected;
  final String? initSelection;

  const AppDropdownField({
    super.key,
    required this.hint,
    required this.width,
    required this.items,
    required this.onSelected,
    this.initSelection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownMenu<String>(
      width: width,
      hintText: hint,
      enableSearch: false,
      menuHeight: 200,
      requestFocusOnTap: false,
      initialSelection: initSelection,
      inputDecorationTheme: theme.inputDecorationTheme,
      dropdownMenuEntries: items,
      onSelected: onSelected,
    );
  }
}
