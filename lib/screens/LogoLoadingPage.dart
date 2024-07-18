import 'package:flutter/material.dart';
import 'package:sandiwapp/components/texts.dart';

class LogoLoadingPage extends StatefulWidget {
  const LogoLoadingPage({super.key});

  @override
  _LogoLoadingPageState createState() => _LogoLoadingPageState();
}

class _LogoLoadingPageState extends State<LogoLoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _imageAnimation;
  late List<Animation<Offset>> _textAnimations;

  final String _loadingText = "Nagloload....";

  @override
  void initState() {
    super.initState();

    // Animation controller for the image and text
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Tween for up and down movement of the image
    _imageAnimation = Tween<Offset>(
      begin: Offset(0, -0.05),
      end: Offset(0, 0.05),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Create a list of animations for each letter in the text
    _textAnimations = List.generate(_loadingText.length, (index) {
      double start = index * 0.1 / _loadingText.length;
      double end =
          start + 0.8 / _loadingText.length; // Adjusted to avoid exceeding 1.0
      return Tween<Offset>(
        begin: Offset(0, 0),
        end: Offset(0, -0.5),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          start,
          end <= 1.0 ? end : 1.0, // Ensure end is within the range
          curve: Curves.easeInOut,
        ),
      ));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _imageAnimation,
                child: Image.asset(
                  'assets/icons/sandiwa_logo.png',
                  width: 350,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_loadingText.length, (index) {
                  return SlideTransition(
                    position: _textAnimations[index],
                    child: PatrickHandSC(
                      text: _loadingText[index],
                      fontSize: 20,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
