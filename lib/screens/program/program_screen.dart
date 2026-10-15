import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/app_image.dart';

/// Halaman "Program" (layar 14): kartu program di latar gelap.
class ProgramScreen extends StatelessWidget {
  const ProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.darkAppBar,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
        itemCount: dummyPrograms.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
        itemBuilder: (BuildContext context, int index) {
          return _ProgramCard(program: dummyPrograms[index]);
        },
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.program});

  final TrainingProgram program;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Material(
        color: AppColors.darkCard,
        child: InkWell(
          // TODO: detail program belum ada di referensi.
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    AppImage(program.image, fallbackColor: const Color(0xFF555555)),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[Color(0x00000000), AppColors.black60],
                          stops: <double>[0.45, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 22,
                      child: Text(
                        program.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          height: 1.18,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      program.description,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      program.meta,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA6A6A6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
