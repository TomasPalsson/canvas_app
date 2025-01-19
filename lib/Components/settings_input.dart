import 'package:flutter/material.dart';

class SettingsInput extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final bool isPassword;

  const SettingsInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      controller: TextEditingController(text: value),
      onChanged: onChanged,
      obscureText: isPassword,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
