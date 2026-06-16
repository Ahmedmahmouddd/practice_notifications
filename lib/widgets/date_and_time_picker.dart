import 'package:flutter/material.dart';
import 'package:practice_notifications/theme/theme.dart';
import 'package:timezone/timezone.dart' as tz;

String formatScheduleDateTime(tz.TZDateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.year}-$month-$day $hour:$minute';
}

Future<tz.TZDateTime?> pickScheduleDateTime(BuildContext context) async {
  final now = tz.TZDateTime.now(tz.local);

  final pickedDate = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: now,
    lastDate: now.add(const Duration(days: 30)),
    builder: (context, child) => pickerTheme(context, child),
  );
  if (pickedDate == null || !context.mounted) return null;

  final pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(now),
    builder: (context, child) => pickerTheme(context, child),
  );
  if (pickedTime == null) return null;

  final scheduled = tz.TZDateTime(
    tz.local,
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );

  if (scheduled.isBefore(now)) return null;
  return scheduled;
}
