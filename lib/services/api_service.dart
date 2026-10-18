import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/app_config.dart';
import '../data/models.dart';

class ApiException implements Exception {
  ApiException(this.message, [this.statusCode]);
  final String message;
  final int? statusCode;
  @override
  String toString() => message;
}

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  String? token;

  Map<String, String> get _headers => <String, String>{
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final Uri uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    late http.Response response;
    final String? encoded = body == null ? null : jsonEncode(body);
    switch (method) {
      case 'GET':
        response = await http.get(uri, headers: _headers);
        break;
      case 'POST':
        response = await http.post(uri, headers: _headers, body: encoded);
        break;
      case 'PUT':
        response = await http.put(uri, headers: _headers, body: encoded);
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: _headers, body: encoded);
        break;
      default:
        throw ApiException('HTTP method tidak didukung.');
    }
    final dynamic decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);
    final Map<String, dynamic> data = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{'data': decoded};
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        data['message']?.toString() ?? 'Request API gagal.',
        response.statusCode,
      );
    }
    return data;
  }

  Future<Map<String, dynamic>> requestCode(String email) => _request(
    'POST',
    '/auth/request-code',
    body: <String, dynamic>{'email': email},
  );
  Future<Map<String, dynamic>> register(Map<String, dynamic> body) =>
      _request('POST', '/auth/register', body: body);
  Future<Map<String, dynamic>> login(String email, String code) => _request(
    'POST',
    '/auth/login',
    body: <String, dynamic>{'email': email, 'code': code},
  );
  Future<void> logout() async {
    await _request('POST', '/logout');
  }

  Future<void> deleteAccount() async {
    await _request('DELETE', '/me');
  }

  Future<Map<String, dynamic>> updatePreferences({
    String? gender,
    String? frequency,
  }) {
    final Map<String, dynamic> body = <String, dynamic>{};
    if (gender != null) body['gender'] = gender;
    if (frequency != null) body['weekly_frequency'] = frequency;
    return _request('PUT', '/me/preferences', body: body);
  }

  Future<List<Workout>> getWorkouts() async {
    final r = await _request('GET', '/workouts');
    return (r['data'] as List<dynamic>)
        .map((e) => Workout.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Set<String>> getSaved() async {
    final r = await _request('GET', '/saved');
    return (r['data'] as List<dynamic>).map((e) => e.toString()).toSet();
  }

  Future<void> saveWorkout(String id) async {
    await _request('POST', '/saved/$id');
  }

  Future<void> unsaveWorkout(String id) async {
    await _request('DELETE', '/saved/$id');
  }

  Future<List<WorkoutRecord>> getHistory() async {
    final r = await _request('GET', '/history');
    return (r['data'] as List<dynamic>)
        .map((e) => WorkoutRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addHistory(WorkoutRecord record) async {
    await _request(
      'POST',
      '/history',
      body: <String, dynamic>{
        'workout_id': record.workoutId,
        'seconds': record.seconds,
        'exercise_count': record.exerciseCount,
        'completed_at': record.completedAt
            .toIso8601String()
            .replaceFirst('T', ' ')
            .split('.')
            .first,
      },
    );
  }
}
