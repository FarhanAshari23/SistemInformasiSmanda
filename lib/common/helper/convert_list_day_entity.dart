import '../../domain/entities/schedule/day.dart';

Map<String, List<DayEntity>> groupSchedules(List<DayEntity> flatList) {
  final Map<String, List<DayEntity>> grouped = {
    "Senin": [],
    "Selasa": [],
    "Rabu": [],
    "Kamis": [],
    "Jumat": [],
  };

  for (var entity in flatList) {
    if (entity.day != null && grouped.containsKey(entity.day)) {
      grouped[entity.day]!.add(entity);
    }
  }

  grouped.forEach((day, list) {
    list.sort((a, b) => (a.startTime ?? "").compareTo(b.startTime ?? ""));
  });

  return grouped;
}
