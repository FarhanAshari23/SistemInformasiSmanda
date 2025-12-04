DateTime parseTimeSchedule(String jam) {
  final parts = jam.split(" - "); // ["07:00", "08:00"]
  final start = parts[0]; // "07:00"

  final hm = start.split(":"); // ["07", "00"]
  final hour = int.parse(hm[0]);
  final minute = int.parse(hm[1]);

  return DateTime(0, 1, 1, hour, minute);
}
