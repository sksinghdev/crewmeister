import 'package:flutter/material.dart';

class FilterDialog {
  static Future<void> show({
    required BuildContext context,
    String? initialType,
    DateTimeRange? initialDateRange,
    required ValueChanged<String?> onTypeChanged,
    required ValueChanged<DateTimeRange?> onDateChanged,
    required VoidCallback onClear,
    required VoidCallback onApply,
  }) async {
    String? tempType = initialType;
    DateTimeRange? tempDate = initialDateRange;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Absences'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: tempType,
                    isExpanded: true,
                    hint: const Text("Select type"),
                    items: ["sickness", "vacation"].map((type) {
                      return DropdownMenuItem(
                          value: type, child: Text(type));
                    }).toList(),
                    onChanged: (val) {
                      setState(() => tempType = val);
                      onTypeChanged(val);
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    child: Text(
                      tempDate != null
                          ? "${tempDate?.start.toLocal().toString().split(' ')[0]} → ${tempDate?.end.toLocal().toString().split(' ')[0]}"
                          : "Select Date Range",
                    ),
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => tempDate = picked);
                        onDateChanged(picked);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("Clear"),
                  onPressed: () {
                    onTypeChanged(null);
                    onDateChanged(null);
                    onClear();
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text("Apply"),
                  onPressed: () {
                    onApply();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
