import 'package:flutter/material.dart';

import '../Components/loading_enum.dart';

class SettingsComp extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const SettingsComp({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class LoadingWidgetSettingsComp extends StatelessWidget {
  final String title;
  final LoadingWidget value;
  final Function(LoadingWidget) onChanged;

  const LoadingWidgetSettingsComp({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<LoadingWidget>(
                value: value,
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: (value) {
                  onChanged(value!);
                },
                items: LoadingWidget.values
                    .map((e) => DropdownMenuItem<LoadingWidget>(
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: e.widget,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  e.name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
