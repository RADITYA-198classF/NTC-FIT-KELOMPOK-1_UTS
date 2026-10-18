import 'package:flutter/foundation.dart';

import '../services/api_service.dart';
import 'dummy_data.dart';
import 'models.dart';

class AppSession {
  AppSession._();
  static final AppSession instance = AppSession._();
  final ApiService api = ApiService.instance;

  String email = 'nama@email.com';
  String firstName = 'Raditya';
  String lastName = 'Ardi Prahasta';
  DateTime? birthDate;
  bool marketingOptIn = false;
  Gender? gender;
  WeeklyFrequency? weeklyFrequency;
  DateTime joinedAt = DateTime.now();
  bool emailExists = false;
  String? token;

  final ValueNotifier<List<Workout>> workouts = ValueNotifier<List<Workout>>(
    List<Workout>.from(dummyWorkouts),
  );
  final ValueNotifier<Set<String>> savedIds = ValueNotifier<Set<String>>(
    <String>{},
  );
  final ValueNotifier<int> completedCount = ValueNotifier<int>(0);
  final ValueNotifier<List<WorkoutRecord>> history =
      ValueNotifier<List<WorkoutRecord>>(<WorkoutRecord>[]);

  String get fullName => '$firstName $lastName'.trim();

  Future<String?> requestVerificationCode(String value) async {
    email = value.trim();
    final Map<String, dynamic> r = await api.requestCode(email);
    emailExists = r['exists'] == true;
    return r['demo_code']?.toString();
  }

  Future<void> register({
    required String code,
    required String firstNameValue,
    required String lastNameValue,
    required DateTime birth,
    required bool marketing,
  }) async {
    final r = await api.register(<String, dynamic>{
      'email': email,
      'code': code,
      'first_name': firstNameValue,
      'last_name': lastNameValue,
      'birth_date':
          '${birth.year.toString().padLeft(4, '0')}-${birth.month.toString().padLeft(2, '0')}-${birth.day.toString().padLeft(2, '0')}',
      'marketing_opt_in': marketing,
    });
    _applyAuthResponse(r);
  }

  Future<void> login(String code) async {
    final r = await api.login(email, code);
    _applyAuthResponse(r);
  }

  void _applyAuthResponse(Map<String, dynamic> r) {
    token = r['token']?.toString();
    api.token = token;
    final user = r['user'] as Map<String, dynamic>;
    email = user['email']?.toString() ?? email;
    firstName = user['first_name']?.toString() ?? '';
    lastName = user['last_name']?.toString() ?? '';
    final birth = user['birth_date']?.toString();
    birthDate = birth == null ? null : DateTime.tryParse(birth);
    marketingOptIn =
        user['marketing_opt_in'] == true || user['marketing_opt_in'] == 1;
    gender = switch (user['gender']) {
      'female' => Gender.female,
      'male' => Gender.male,
      _ => null,
    };
    weeklyFrequency = switch (user['weekly_frequency']) {
      'low' => WeeklyFrequency.low,
      'medium' => WeeklyFrequency.medium,
      'high' => WeeklyFrequency.high,
      _ => null,
    };
    joinedAt =
        DateTime.tryParse(user['joined_at']?.toString() ?? '') ??
        DateTime.now();
  }

  Future<void> saveGender(Gender value) async {
    gender = value;
    if (token != null) await api.updatePreferences(gender: value.name);
  }

  Future<void> saveFrequency(WeeklyFrequency value) async {
    weeklyFrequency = value;
    if (token != null) await api.updatePreferences(frequency: value.name);
  }

  Future<void> loadRemoteData() async {
    try {
      workouts.value = await api.getWorkouts();
    } catch (_) {
      /* fallback dummy */
    }
    if (token == null) return;
    try {
      savedIds.value = await api.getSaved();
    } catch (_) {}
    try {
      history.value = await api.getHistory();
      completedCount.value = history.value.length;
    } catch (_) {}
  }

  Future<void> toggleSaved(String id) async {
    final next = Set<String>.from(savedIds.value);
    final bool added = next.add(id);
    if (!added) next.remove(id);
    savedIds.value = next;
    if (token == null) return;
    try {
      if (added) {
        await api.saveWorkout(id);
      } else {
        await api.unsaveWorkout(id);
      }
    } catch (_) {
      final rollback = Set<String>.from(savedIds.value);
      if (added) {
        rollback.remove(id);
      } else {
        rollback.add(id);
      }
      savedIds.value = rollback;
      rethrow;
    }
  }

  Future<void> addRecord(WorkoutRecord record) async {
    history.value = <WorkoutRecord>[record, ...history.value];
    completedCount.value = history.value.length;
    if (token != null) {
      try {
        await api.addHistory(record);
      } catch (_) {}
    }
  }

  Future<void> logout() async {
    if (token != null) {
      try {
        await api.logout();
      } catch (_) {}
    }
    reset();
  }

  Future<void> deleteAccount() async {
    if (token != null) await api.deleteAccount();
    reset();
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
    emailExists = false;
    token = null;
    api.token = null;
    savedIds.value = <String>{};
    completedCount.value = 0;
    history.value = <WorkoutRecord>[];
    workouts.value = List<Workout>.from(dummyWorkouts);
  }
}

AppSession get session => AppSession.instance;
