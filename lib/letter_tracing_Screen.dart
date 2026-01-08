import 'package:flutter/material.dart';
import 'dart:math' as math;

class LetterTracingScreen extends StatefulWidget {
  const LetterTracingScreen({Key? key}) : super(key: key);

  @override
  State<LetterTracingScreen> createState() => _LetterTracingScreenState();
}

class _LetterTracingScreenState extends State<LetterTracingScreen> with TickerProviderStateMixin {
  int currentLetterIndex = 0;
  final List<String> letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  bool isTraced = false;
  List<Offset> stars = [];
  late AnimationController _starController;
  late AnimationController _letterController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _letterController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _letterController.forward();
  }

  @override
  void dispose() {
    _starController.dispose();
    _letterController.dispose();
    super.dispose();
  }

  void _onLetterTraced() {
    if (isTraced) return;

    setState(() {
      isTraced = true;
      stars = List.generate(
        10,
            (index) => Offset(
          100 + math.Random().nextDouble() * 200,
          100 + math.Random().nextDouble() * 200,
        ),
      );
    });

    _starController.forward(from: 0);
  }

  void _nextLetter() {
    if (currentLetterIndex < letters.length - 1) {
      setState(() {
        currentLetterIndex++;
        isTraced = false;
        stars = [];
        _starController.reset();
        _letterController.forward(from: 0);
      });
    }
  }

  void _previousLetter() {
    if (currentLetterIndex > 0) {
      setState(() {
        currentLetterIndex--;
        isTraced = false;
        stars = [];
        _starController.reset();
        _letterController.forward(from: 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLetter = letters[currentLetterIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade200,
              Colors.yellow.shade200,
              Colors.pink.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildProgressBar(),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildTracingArea(currentLetter),
                      if (isTraced) _buildStarAnimation(),
                    ],
                  ),
                ),
              ),
              _buildNavigationButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              '✏️ Trace Letters',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            'Letter ${currentLetterIndex + 1} of ${letters.length}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (currentLetterIndex + 1) / letters.length,
              minHeight: 15,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTracingArea(String letter) {
    return GestureDetector(
      onPanUpdate: (details) => _onLetterTraced(),
      onTap: () => _onLetterTraced(),
      child: Container(
        width: 300,
        height: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!isTraced)
              ScaleTransition(
                scale: _letterController,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 200,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade300,
                    shadows: const [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black12,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
            if (isTraced)
              ScaleTransition(
                scale: _starController,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 200,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Colors.purple, Colors.pink, Colors.orange],
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 200)),
                  ),
                ),
              ),
            if (!isTraced)
              const Positioned(
                bottom: 30,
                child: Text(
                  'Tap or trace the letter!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (isTraced)
              const Positioned(
                bottom: 30,
                child: Text(
                  '🌟 Great Job! 🌟',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarAnimation() {
    return Stack(
      children: stars.map((position) {
        return AnimatedBuilder(
          animation: _starController,
          builder: (context, child) {
            return Positioned(
              left: position.dx,
              top: position.dy - (_starController.value * 50),
              child: Opacity(
                opacity: 1.0 - _starController.value,
                child: Transform.rotate(
                  angle: _starController.value * 2 * math.pi,
                  child: const Text(
                    '⭐',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavButton(
            '← Previous',
            currentLetterIndex > 0,
            _previousLetter,
            Colors.blue,
          ),
          _buildNavButton(
            'Next →',
            currentLetterIndex < letters.length - 1,
            _nextLetter,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String text, bool enabled, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? color : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}