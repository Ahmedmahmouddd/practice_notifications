import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:practice_notifications/theme/theme.dart';

enum RepeatOption { never, daily, weekly }

DateTimeComponents? toMatchComponents(RepeatOption option) {
  switch (option) {
    case RepeatOption.never:
      return null;
    case RepeatOption.daily:
      return DateTimeComponents.time;
    case RepeatOption.weekly:
      return DateTimeComponents.dayOfWeekAndTime;
  }
}

Future<RepeatOption?> showRepeatPickerDialog(BuildContext context) {
  return showDialog<RepeatOption>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => pickerTheme(
      dialogContext,
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: appBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: const Text(
                'Repeat?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _RepeatOptionTile(
              label: 'Every day',
              onTap: () => Navigator.pop(dialogContext, RepeatOption.daily),
            ),
            _RepeatOptionTile(
              label: 'Every week',
              onTap: () => Navigator.pop(dialogContext, RepeatOption.weekly),
            ),
            _RepeatOptionTile(
              label: 'Never',
              onTap: () => Navigator.pop(dialogContext, RepeatOption.never),
            ),
            const Divider(height: 1, color: appLightGrey),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _RepeatOptionTile extends StatelessWidget {
  const _RepeatOptionTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.black)),
      onTap: onTap,
    );
  }
}
