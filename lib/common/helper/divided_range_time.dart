class DividedRangeTime {
  final String start;
  final String end;

  DividedRangeTime({required this.start, required this.end});

  factory DividedRangeTime.fromString(String value) {
    final parts = value.split(" - ");
    if (parts.length != 2) {
      throw const FormatException("Format tidak sesuai: harus 'HH:mm - HH:mm'");
    }
    return DividedRangeTime(start: parts[0], end: parts[1]);
  }

  @override
  String toString() => "$start - $end";
}
