String dateTimeFormat(DateTime date) {
  final year = date.year;
  final month = date.month;
  final day = date.day;
  final hour = date.hour;
  final min = date.minute;

  return '$day/$month/$year $hour:$min';
}
