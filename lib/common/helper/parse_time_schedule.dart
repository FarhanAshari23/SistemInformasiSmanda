DateTime parseTimeSchedule(String jam) {
  final parts = jam.split(" - ");
  final start = parts[0];

  final hm = start.split(":");
  final hour = int.parse(hm[0]);
  final minute = int.parse(hm[1]);

  return DateTime(0, 1, 1, hour, minute);
}
