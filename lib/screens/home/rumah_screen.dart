import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../data/dummy_data.dart';
import '../../data/models.dart';
import '../../widgets/app_image.dart';
import '../../widgets/ntc_logo.dart';
import '../../widgets/pill_button.dart';

/// Halaman "Rumah" (layar 15): carousel hero, indikator, ajakan menjelajah.
class RumahScreen extends StatefulWidget {
  const RumahScreen({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  State<RumahScreen> createState() => _RumahScreenState();
}

class _RumahScreenState extends State<RumahScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLatihan() => widget.onNavigate(0);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.homeBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 426,
            child: PageView.builder(
              controller: _pageController,
              itemCount: dummyHeroSlides.length,
              onPageChanged: (int i) => setState(() => _page = i),
              itemBuilder: (BuildContext context, int index) {
                return _HeroSlideView(slide: dummyHeroSlides[index], onExplore: _goToLatihan);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < dummyHeroSlides.length; i++)
                  Container(
                    width: 11,
                    height: 2.5,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    color: i == _page ? AppColors.black : AppColors.divider,
                  ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 56, 24, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: NikeSwoosh(width: 46),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Text(
              'Mencari yang lainnya?\nAyo latihan!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                height: 1.45,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Align(
              alignment: Alignment.centerLeft,
              child: PillButton(
                label: 'Jelajahi Latihan',
                height: 52,
                onPressed: _goToLatihan,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSlideView extends StatelessWidget {
  const _HeroSlideView({required this.slide, required this.onExplore});

  final HeroSlide slide;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        AppImage(
          slide.image,
          alignment: Alignment.topCenter,
          fallbackColor: const Color(0xFF3B3B3B),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0x00000000), AppColors.black40],
              stops: <double>[0.4, 1.0],
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 34,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                slide.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                slide.headline,
                style: AppTextStyles.display.copyWith(fontSize: 40),
              ),
              const SizedBox(height: 16),
              PillButton(
                label: 'Explore',
                style: PillButtonStyle.filledWhite,
                height: 34,
                fontSize: 15,
                horizontalPadding: 18,
                onPressed: onExplore,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
