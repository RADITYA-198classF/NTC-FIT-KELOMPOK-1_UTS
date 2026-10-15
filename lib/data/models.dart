import 'package:flutter/material.dart';

enum Gender { female, male }

extension GenderLabel on Gender {
  String get label => this == Gender.female ? 'Wanita' : 'Pria';
}

enum WeeklyFrequency { low, medium, high }

const List<String> _frequencyTitles = <String>[
  '0-1 Latihan',
  '2-4 Latihan',
  '5+ Latihan',
];

const List<String> _frequencySubtitles = <String>[
  'Saya belum terlatih',
  'Saya rutin berlatih',
  'Saya siap untuk apa pun',
];

extension WeeklyFrequencyText on WeeklyFrequency {
  String get title => _frequencyTitles[index];
  String get subtitle => _frequencySubtitles[index];
}

/// Satu gerakan dalam sebuah latihan. Berbasis repetisi (stopwatch naik,
/// pengguna menekan "Selesai") atau berbasis waktu (hitung mundur otomatis).
class Exercise {
  const Exercise(
    this.name, {
    this.reps,
    this.seconds,
    required this.cue,
  }) : assert(reps != null || seconds != null);

  final String name;
  final int? reps;
  final int? seconds;

  /// Petunjuk singkat cara melakukan gerakan.
  final String cue;

  bool get isTimed => reps == null && seconds != null;

  String get target => reps != null ? '$reps repetisi' : '$seconds dtk';
}

/// Catatan satu sesi latihan yang selesai (tampil di Aktivitas > Riwayat).
class WorkoutRecord {
  const WorkoutRecord({
    required this.workoutId,
    required this.title,
    required this.completedAt,
    required this.seconds,
    required this.exerciseCount,
  });

  final String workoutId;
  final String title;
  final DateTime completedAt;
  final int seconds;
  final int exerciseCount;
}

class Workout {
  const Workout({
    required this.id,
    required this.title,
    required this.level,
    required this.equipment,
    required this.focus,
    required this.minutes,
    required this.image,
    required this.description,
    required this.exercises,
    this.isNew = false,
    this.categories = const <String>[],
  });

  final String id;
  final String title;
  final String level;
  final String equipment;
  final String focus;
  final int minutes;
  final String image;
  final bool isNew;
  final String description;
  final List<Exercise> exercises;

  /// Nama kategori (HIIT, Kekuatan, Yoga, Siap untuk Gym, Pilates).
  final List<String> categories;

  String get meta => '$level · $equipment · $focus';
  String get duration => '$minutes mnt';
}

class WorkoutCategory {
  const WorkoutCategory({
    required this.name,
    required this.image,
    required this.fallbackColor,
  });

  final String name;
  final String image;
  final Color fallbackColor;
}

class TrainingProgram {
  const TrainingProgram({
    required this.title,
    required this.description,
    required this.meta,
    required this.image,
  });

  final String title;
  final String description;
  final String meta;
  final String image;
}

class HeroSlide {
  const HeroSlide({
    required this.label,
    required this.headline,
    required this.image,
  });

  final String label;
  final String headline;
  final String image;
}

enum TrophyShape { diamond, circle }

class Trophy {
  const Trophy({
    required this.name,
    required this.icon,
    this.shape = TrophyShape.circle,
  });

  final String name;
  final IconData icon;
  final TrophyShape shape;
}
