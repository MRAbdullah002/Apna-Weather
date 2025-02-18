import 'package:intl/intl.dart';

class FormattedTime {
  /// Returns formatted date in "Monday, 12 February 2025" format
  static String getFormattedDate() {
    return DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
  }

  /// Returns formatted current time in "02:45 PM" format
  static String getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  /// Converts a DateTime object to "02:45 AM/PM" format
  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}
