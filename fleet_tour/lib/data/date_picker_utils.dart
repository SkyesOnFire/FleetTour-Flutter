import 'package:fleet_tour/providers/date_controller.dart';
import 'package:flutter/material.dart';

class DatePickerUtils {
  static Widget dateTimePickerWidget({
    required DateTimePickerController controller,
    required BuildContext context,
    required DateTime initialDateTime,
    required DateTime firstDateTime,
    required DateTime lastDateTime,
    String locale = 'pt_BR',
  }) {
    return ElevatedButton(
      onPressed: () => _selectDateTime(context, controller, initialDateTime, firstDateTime, lastDateTime, locale),
      child: const Text('Selecionar Data e Hora'),
    );
  }

  static Future<void> _selectDateTime(
    BuildContext context,
    DateTimePickerController controller,
    DateTime initialDateTime,
    DateTime firstDateTime,
    DateTime lastDateTime,
    String locale,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: firstDateTime,
      lastDate: lastDateTime,
      locale: Locale(locale.split('_')[0], locale.split('_')[1]),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        controller.updateSelectedDateTime(selectedDateTime);
      }
    }
  }
}
