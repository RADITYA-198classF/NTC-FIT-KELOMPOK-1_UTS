import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_colors.dart';
import '../../core/app_config.dart';
import '../../core/app_text_styles.dart';
import '../../core/app_theme.dart';
import '../../data/app_session.dart';
import '../../data/models.dart';
import '../../widgets/app_image.dart';
import '../../widgets/pill_button.dart';
import 'workout_summary_screen.dart';

enum _Phase { rest, exercise }

/// Sesi latihan dengan timer.
///
/// - Fase "Bersiap"/"Istirahat": hitung mundur, menampilkan gerakan berikutnya.
/// - Gerakan berbasis repetisi (mis. 10 repetisi Cat Cow): stopwatch naik yang
///   mengukur berapa lama gerakan dilakukan; tekan "Selesai" bila sudah.
/// - Gerakan berbasis waktu (mis. Plank 40 dtk): hitung mundur otomatis.
/// Layar ini tidak ada di screenshot referensi.
class WorkoutSessionScreen extends StatefulWidget {
  const WorkoutSessionScreen({super.key, required this.workout});

  final Workout workout;

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  Timer? _timer;
  _Phase _phase = _Phase.rest;
  int _index = 0;
  int _seconds = AppConfig.getReadySeconds;
  int _totalSeconds = 0;
  bool _paused = false;

  List<Exercise> get _exercises => widget.workout.exercises;
  Exercise get _exercise => _exercises[_index];
  bool get _isLast => _index == _exercises.length - 1;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---- logika sesi -------------------------------------------------------

  void _tick(Timer timer) {
    if (_paused || !mounted) return;
    bool finished = false;
    setState(() {
      _totalSeconds++;
      if (_phase == _Phase.rest) {
        _seconds--;
        if (_seconds <= 0) _startExercise();
      } else if (_exercise.isTimed) {
        _seconds--;
        if (_seconds <= 0) finished = _completeExercise();
      } else {
        _seconds++;
      }
    });
    if (finished) _finish();
  }

  void _startExercise() {
    _phase = _Phase.exercise;
    _seconds = _exercise.isTimed ? _exercise.seconds! : 0;
  }

  /// Mengembalikan true bila seluruh latihan selesai.
  bool _completeExercise() {
    if (_isLast) return true;
    _index++;
    _phase = _Phase.rest;
    _seconds = AppConfig.restSeconds;
    return false;
  }

  void _onMainPressed() {
    bool finished = false;
    setState(() {
      if (_phase == _Phase.rest) {
        _startExercise();
      } else {
        finished = _completeExercise();
      }
    });
    if (finished) _finish();
  }

  void _finish() {
    _timer?.cancel();
    final Workout workout = widget.workout;
    final int total = _totalSeconds;
    session.addRecord(
      WorkoutRecord(
        workoutId: workout.id,
        title: workout.title,
        completedAt: DateTime.now(),
        seconds: total,
        exerciseCount: _exercises.length,
      ),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => WorkoutSummaryScreen(workout: workout, seconds: total),
      ),
    );
  }

  Future<void> _confirmExit() async {
    final bool wasPaused = _paused;
    setState(() => _paused = true);
    final bool? leave = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hentikan latihan?'),
          content: const Text('Kemajuan latihan ini tidak akan disimpan.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Lanjutkan', style: TextStyle(color: AppColors.textPrimary)),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Keluar', style: TextStyle(color: AppColors.textPrimary)),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    if (leave == true) {
      _timer?.cancel();
      Navigator.of(context).pop();
    } else {
      setState(() => _paused = wasPaused);
    }
  }

  // ---- tampilan ----------------------------------------------------------

  String _format(int totalSeconds) {
    final int m = totalSeconds ~/ 60;
    final int s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get _mainLabel {
    if (_phase == _Phase.rest) return 'Lewati';
    if (_exercise.isTimed) return 'Lewati';
    return _isLast ? 'Selesai Latihan' : 'Selesai';
  }

  Widget _buildProgress() {
    return Row(
      children: <Widget>[
        for (int i = 0; i < _exercises.length; i++)
          Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                color: (i < _index || (i == _index && _phase == _Phase.exercise))
                    ? AppColors.white
                    : AppColors.white35,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    final bool resting = _phase == _Phase.rest;
    final String restTitle = (_index == 0) ? 'Bersiap' : 'Istirahat';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          resting ? restTitle : 'Gerakan ${_index + 1} dari ${_exercises.length}',
          style: const TextStyle(fontSize: 16, color: AppColors.white60),
        ),
        const SizedBox(height: 10),
        Text(
          resting ? 'Berikutnya: ${_exercise.name}' : _exercise.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            height: 1.15,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _exercise.target,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _exercise.cue,
          textAlign: TextAlign.center,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, height: 1.4, color: AppColors.white60),
        ),
        const SizedBox(height: 36),
        Text(
          _format(_seconds),
          style: AppTextStyles.display.copyWith(fontSize: 88),
        ),
        const SizedBox(height: 4),
        Text(
          _paused
              ? 'Dijeda'
              : resting
                  ? 'Hitung mundur'
                  : (_exercise.isTimed ? 'Sisa waktu' : 'Waktu gerakan'),
          style: const TextStyle(fontSize: 14, color: AppColors.white60),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) _confirmExit();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppTheme.immersiveOverlay,
        child: Scaffold(
          backgroundColor: AppColors.black,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              AppImage(
                widget.workout.image,
                alignment: Alignment.topCenter,
                fallbackColor: const Color(0xFF2B2B2B),
              ),
              const ColoredBox(color: AppColors.black90),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            icon: const Icon(Icons.close, color: AppColors.white),
                            onPressed: _confirmExit,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: _buildProgress()),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(child: _buildBody()),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(
                              side: BorderSide(color: AppColors.white, width: 1),
                            ),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => setState(() => _paused = !_paused),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(
                                  _paused ? Icons.play_arrow : Icons.pause,
                                  color: AppColors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: PillButton(
                              label: _mainLabel,
                              style: PillButtonStyle.filledWhite,
                              height: 56,
                              onPressed: _paused ? null : _onMainPressed,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
