import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDatePicker {
  final BuildContext context;
  DateTime? pickedDateTime;
  DateTime preSelectedDate, maximumDate, minimumDate;

  CustomDatePicker({
    required this.context,
    required this.maximumDate,
    required this.preSelectedDate,
    required this.minimumDate,
  });

  Future<DateTime?> openDatePicker() async {
    final platform = Theme.of(context).platform;
    pickedDateTime = platform == TargetPlatform.iOS ? await showAndroidDatePicker() : await showIOSDatePicker();
    return pickedDateTime;
  }

  Future<DateTime?> showIOSDatePicker() async {
    DateTime? selectedDate, currentDate;
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheet(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        onClosing: () {},
        enableDrag: false,
        builder: (context) {
          return Wrap(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: preSelectedDate,
                          minimumDate: minimumDate.copyWith(hour: 0, minute: 0, second: 0),
                          maximumDate: maximumDate.copyWith(hour: 23, minute: 59, second: 59),
                          onDateTimeChanged: (dateTime) {
                            currentDate = dateTime;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(11),
                          fixedSize: WidgetStateProperty.all(const Size.fromHeight(12)),
                          backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                          shape: WidgetStateProperty.all(
                            ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          splashFactory: NoSplash.splashFactory,
                        ),
                        onPressed: () async {
                          currentDate ??= preSelectedDate;
                          selectedDate = currentDate;
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Select",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    return selectedDate;
  }

  Future<DateTime?> showAndroidDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: preSelectedDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: minimumDate.copyWith(hour: 0, minute: 0, second: 0),
      lastDate: maximumDate.copyWith(hour: 23, minute: 59, second: 59),
      locale: Locale(Localizations.localeOf(context).languageCode),
      useRootNavigator: false,
    );
    return pickedDate;
  }
}
