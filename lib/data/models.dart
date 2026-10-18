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

class Exercise {
  const Exercise(this.name, {this.reps, this.seconds, required this.cue})
    : assert(reps != null || seconds != null);
  final String name;
  final int? reps;
  final int? seconds;
  final String cue;
  bool get isTimed => reps == null && seconds != null;
  String get target => reps != null ? '$reps repetisi' : '$seconds dtk';

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    json['name'] as String,
    reps: json['reps'] == null ? null : (json['reps'] as num).toInt(),
    seconds: json['seconds'] == null ? null : (json['seconds'] as num).toInt(),
    cue: json['cue'] as String? ?? '',
  );
}

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

  factory WorkoutRecord.fromJson(Map<String, dynamic> json) => WorkoutRecord(
    workoutId: json['workout_id'] as String,
    title: json['title'] as String,
    completedAt: DateTime.parse(
      (json['completed_at'] as String).replaceFirst(' ', 'T'),
    ),
    seconds: (json['seconds'] as num).toInt(),
    exerciseCount: (json['exercise_count'] as num).toInt(),
  );
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
  final List<String> categories;
  String get meta => '$level · $equipment · $focus';
  String get duration => '$minutes mnt';

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    id: json['id'] as String,
    title: json['title'] as String,
    level: json['level'] as String,
    equipment: json['equipment'] as String,
    focus: json['focus'] as String,
    minutes: (json['minutes'] as num).toInt(),
    image: json['image'] as String,
    description: json['description'] as String? ?? '',
    isNew: json['is_new'] == true || json['is_new'] == 1,
    categories: (json['categories'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    exercises: (json['exercises'] as List<dynamic>? ?? const [])
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
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
