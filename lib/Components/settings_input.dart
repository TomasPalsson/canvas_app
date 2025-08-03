import 'package:flutter/material.dart';

class SettingsInput extends StatefulWidget {
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
  State<SettingsInput> createState() => _SettingsInputState();
}

class _SettingsInputState extends State<SettingsInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);

    // Pipe text changes back up
    _controller.addListener(() => widget.onChanged(_controller.text));
  }

  @override
  void didUpdateWidget(covariant SettingsInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent gives us a new value, update the controller *without* moving the caret
    if (widget.value != _controller.text) {
      _controller
        ..text = widget.value
        ..selection = TextSelection.collapsed(offset: widget.value.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      obscureText: widget.isPassword,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
