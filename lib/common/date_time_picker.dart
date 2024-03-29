import 'package:flutter/material.dart';
import 'package:flutter_grab/common/theme.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
//    final DateTime picked = await showDatePicker(
//        context: context,
//        initialDate: selectedDate,
//        firstDate: DateTime(2015, 8),
//        lastDate: DateTime(2101));
//    if (picked != null && picked != selectedDate) selectDate(picked);
    DatePicker.showDatePicker(
      context,
      currentTime: selectedDate,
      locale: LocaleType.zh,
      onConfirm: (picked) {
        if (picked != null && picked != selectedDate) selectDate(picked);
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
//    final TimeOfDay picked =
//        await showTimePicker(context: context, initialTime: selectedTime);
//    if (picked != null && picked != selectedTime) selectTime(picked);
    final now = new DateTime.now();
    final currentDate = DateTime(
        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

    DatePicker.showTimePicker(
      context,
      currentTime: currentDate,
      locale: LocaleType.zh,
      onConfirm: (picked) {
        if (picked != null && picked != selectedDate)
          selectTime(TimeOfDay.fromDateTime(picked));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = textStylePublish;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat("y年M月d日").format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
//            valueText: selectedTime.format(context),
            valueText: MaterialLocalizations.of(context)
                .formatTimeOfDay(selectedTime, alwaysUse24HourFormat: true),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: textStyleLabel,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
