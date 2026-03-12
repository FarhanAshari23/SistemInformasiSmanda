import '../../domain/entities/schedule/day.dart';

Map<String, List<DayEntity>> groupSchedules(List<DayEntity> flatList) {
  // 1. Siapkan struktur Map dengan list kosong untuk setiap hari
  final Map<String, List<DayEntity>> grouped = {
    "Senin": [],
    "Selasa": [],
    "Rabu": [],
    "Kamis": [],
    "Jumat": [],
  };

  // 2. Iterasi list dari API/Database
  for (var entity in flatList) {
    // Pastikan day tidak null dan ada di dalam map kita
    if (entity.day != null && grouped.containsKey(entity.day)) {
      // Tambahkan entity ke list hari yang sesuai
      grouped[entity.day]!.add(entity);
    }
  }

  // 3. Opsional: Urutkan jadwal berdasarkan jam mulai agar rapi di UI
  grouped.forEach((day, list) {
    list.sort((a, b) => (a.startTime ?? "").compareTo(b.startTime ?? ""));
  });

  return grouped;
}
