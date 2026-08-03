import 'dart:async';

import 'package:arise_and_shine/components/dot_indicators.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderCarousel extends StatefulWidget {
  const SliderCarousel({super.key});

  @override
  State<SliderCarousel> createState() => _SliderCarouselState();
}

class _SliderCarouselState extends State<SliderCarousel> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // Local slider images
  final List<String> sliderImages = [
    'assets/images/slider1.jpg',
    'assets/images/slider2.jpg',
    'assets/images/slider3.jpg',
  ];

  int _selectedIndex = 0;
  bool _autoPlayEnabled = true; // Control auto-play state
  Timer? _resumeTimer; // Timer to resume auto-play after manual interaction

  @override
  void dispose() {
    _resumeTimer?.cancel();
    super.dispose();
  }

  void _handleManualInteraction() {
    // Pause auto-play when user manually swipes
    if (_autoPlayEnabled) {
      setState(() {
        _autoPlayEnabled = false;
      });
    }

    // Cancel existing timer
    _resumeTimer?.cancel();

    // Resume auto-play after 3 seconds of no interaction
    _resumeTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _autoPlayEnabled = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate height as approximately 40% of screen height
        final double screenHeight = MediaQuery.of(context).size.height;
        final double statusBarHeight = MediaQuery.of(context).padding.top;
        final double carouselHeight = (screenHeight - statusBarHeight) * 0.4;

        return SizedBox(
          height: carouselHeight,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main carousel slider - no GestureDetector wrapper needed
              Positioned.fill(
                child: CarouselSlider(
                  items: sliderImages.map((imagePath) {
                    return _buildSlideItem(imagePath);
                  }).toList(),
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: carouselHeight,
                    viewportFraction: 1.0,
                    // Auto-play controlled by state
                    autoPlay: _autoPlayEnabled,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: false,
                    padEnds: false,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.easeInOut,
                    // Enable manual scrolling with physics for smooth feel
                    scrollPhysics: const BouncingScrollPhysics(),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _selectedIndex = index;
                      });

                      // Detect manual swipe and pause auto-play
                      if (reason == CarouselPageChangedReason.manual) {
                        _handleManualInteraction();
                      }
                    },
                  ),
                ),
              ),

              // Gradient overlay for better dot visibility (ignore pointer to allow touches through)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.5),
                        ],
                        stops: const [0.6, 0.85, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // Dot indicators at the bottom
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    sliderImages.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: DotIndicator(
                          isActive: index == _selectedIndex,
                          activeColor: Colors.white,
                          inActiveColor: Colors.white.withValues(alpha: 0.4),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlideItem(String imagePath) {
    // Use FittedBox to prevent cropping while maintaining aspect ratio
    // This ensures full image visibility without distortion
    return Container(
      color: Colors.black, // Background for letterboxing if needed
      child: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain, // Shows full image, may add letterboxing
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
