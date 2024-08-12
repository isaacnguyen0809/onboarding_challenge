import 'package:flutter/material.dart';
import 'package:onboarding_challenge/circle_painter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<Offset> _animationOuter;
  late Animation<Offset> _animationInner;
  int _currentPage = 0;

  final List<Offset> positionOuter = [
    const Offset(0, 0),
    const Offset(10, -40),
    const Offset(-20, -10),
    const Offset(10, 10),
  ];

  final List<Offset> positionInner = [
    const Offset(0, 0),
    const Offset(-60, -90),
    const Offset(-20, -120),
    const Offset(0, 0),
  ];

  final List<(Color, Color)> colors = [
    (const Color(0xff93cdc4), const Color(0xff89cbbf)),
    (const Color(0xfc93cdaa), const Color(0xff90cb89)),
    (const Color(0xffcdbd93), const Color(0xffcbb689)),
    (const Color(0xffc193cd), const Color(0xffbd89cb)),
  ];

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animationOuter = Tween<Offset>(
      begin: positionOuter[0],
      end: positionOuter[1],
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    ));

    _animationInner = Tween<Offset>(
      begin: positionInner[0],
      end: positionInner[1],
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 200),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, left: 40),
                child: CustomPaint(
                  painter: CirclePainter(
                    innerColor: colors[_currentPage].$1,
                    animation: _animationInner,
                    initialSweepAngle: 220,
                  ),
                  child: const SizedBox(
                    width: 260,
                    height: 260,
                  ),
                ),
              ),
              CustomPaint(
                painter: CirclePainter(
                  innerColor: colors[_currentPage].$2,
                  animation: _animationOuter,
                ),
                child: const SizedBox(
                  width: 300,
                  height: 300,
                ),
              ),

              // Add more circles or animations here
            ],
          ),
          Flexible(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _animationOuter = Tween<Offset>(
                    begin: positionOuter[_currentPage],
                    end: positionOuter[page],
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.decelerate,
                  ));

                  _animationInner = Tween<Offset>(
                    begin: positionInner[_currentPage],
                    end: positionInner[page],
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.decelerate,
                  ));

                  _currentPage = page;

                  // Chạy animation
                  _animationController.forward(from: 0);
                });
              },
              children: [
                buildPage(
                  context,
                  "Discover a Vast Library",
                  "With a rich and diverse library, you’ll never run out of new books to explore. From timeless classics to the latest bestsellers, everything is at your fingertips.",
                ),
                buildPage(
                  context,
                  "Personalize Your Reading Experience",
                  "We understand that everyone has unique tastes. Our app automatically recommends books that match your interests based on your reading history and personal ratings.",
                ),
                buildPage(
                  context,
                  "Read Anytime, Anywhere",
                  "Whether you’re on a business trip, commuting, or relaxing at home, your digital library is always ready. Download books to read offline and enjoy an unlimited reading experience.",
                ),
                buildPage(
                  context,
                  "Join a Thriving Book Community",
                  "Connect with fellow book lovers, share reviews and ratings, and participate in discussions and book clubs. Let’s spread the love of reading together!",
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors[_currentPage].$1,
        onPressed: () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.decelerate,
          );
        },
        child: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildPage(
    BuildContext context,
    String title,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
