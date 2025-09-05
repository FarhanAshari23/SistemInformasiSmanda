class DayEntity {
  final String jam;
  final String kegiatan;
  final String pelaksana;

  DayEntity({
    required this.jam,
    required this.kegiatan,
    required this.pelaksana,
  });

  Map<String, dynamic> toMap() {
    return {
      "jam": jam,
      "kegiatan": kegiatan,
      "pelaksana": pelaksana,
    };
  }
}
