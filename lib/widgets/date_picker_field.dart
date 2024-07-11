import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  final TextEditingController dateController;
  final String? label;

  const DatePickerField(
      {super.key, required this.dateController, required this.label}
  );

  @override
  State<DatePickerField> createState() => DatePickerState();
}

class DatePickerState extends State<DatePickerField> {

  final int currentYear = DateTime.now().year;

  @override
  void dispose() {
    widget.dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(currentYear - 100),
      lastDate: DateTime.now(),
      locale: const Locale('it', 'IT')
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        widget.dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: widget.dateController,
              decoration: InputDecoration(
                labelText: widget.label,
                border: const OutlineInputBorder(),
              ),
              readOnly: true,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
    );
  }
}