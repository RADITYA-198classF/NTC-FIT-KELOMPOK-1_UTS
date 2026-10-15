import 'package:flutter/foundation.dart';

import 'models.dart';

/// Status sesi sederhana tanpa paket tambahan. Pada tahap integrasi backend,
/// isi dari respons API dan ganti dengan state management pilihan Anda.
class AppSession {
  AppSession._();

  static final AppSession instance = AppSession._();

  String email = 'nama@email.com';
  String firstName = 'Raditya';
  String lastName = 'Ardi Prahasta';
  DateTime? birthDate;
  bool marketingOptIn = false;
  Gender? gender;
  WeeklyFrequency? weeklyFrequency;
  DateTime joinedAt = DateTime.now();

  /// ID latihan yang disimpan (ikon bookmark).
  final ValueNotifier<Set<String>> savedIds = ValueNotifier<Set<String>>(<String>{});

  /// Jumlah latihan selesai (kartu "Selesai" di halaman Latihan).
  final ValueNotifier<int> completedCount = ValueNotifier<int>(0);

  /// Riwayat sesi latihan yang selesai, terbaru di urutan pertama.
  final ValueNotifier<List<WorkoutRecord>> history =
      ValueNotifier<List<WorkoutRecord>>(<WorkoutRecord>[]);

  String get fullName => '$firstName $lastName'.trim();

  void toggleSaved(String id) {
    final Set<String> next = Set<String>.from(savedIds.value);
    if (!next.add(id)) {
      next.remove(id);
    }
    savedIds.value = next;
  }

  void addRecord(WorkoutRecord record) {
    // TODO(api): kirim riwayat latihan ke backend dan tampilkan error jika gagal.
    history.value = <WorkoutRecord>[record, ...history.value];
    completedCount.value = history.value.length;
  }

  void reset() {
    email = 'nama@email.com';
    firstName = 'Raditya';
    lastName = 'Ardi Prahasta';
    birthDate = null;
    marketingOptIn = false;
    gender = null;
    weeklyFrequency = null;
    joinedAt = DateTime.now();
    savedIds.value = <String>{};
    completedCount.value = 0;
    history.value = <WorkoutRecord>[];
  }
}

AppSession get session => AppSession.instance;
