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
  List<Offset> drawnPoints = [];
  bool isTraced = false;
  double tracingProgress = 0.0;
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

  void _onPanUpdate(DragUpdateDetails details) {
    if (isTraced) return;

    setState(() {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      Offset localPosition = renderBox.globalToLocal(details.globalPosition);
      drawnPoints.add(localPosition);

      // Calculate tracing progress based on number of points drawn
      tracingProgress = (drawnPoints.length / 80).clamp(0.0, 1.0);

      // If enough tracing is done, mark as complete
      if (tracingProgress >= 0.8) {
        _completeTracing();
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    // Add a null point to separate stroke segments
    if (!isTraced) {
      setState(() {
        drawnPoints.add(Offset.infinite);
      });
    }
  }

  void _completeTracing() {
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

    // Auto advance to next letter after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && currentLetterIndex < letters.length - 1) {
        _nextLetter();
      }
    });
  }

  void _nextLetter() {
    if (currentLetterIndex < letters.length - 1) {
      setState(() {
        currentLetterIndex++;
        isTraced = false;
        drawnPoints.clear();
        tracingProgress = 0.0;
        stars = [];
        _starController.reset();
        _letterController.forward(from: 0);
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _previousLetter() {
    if (currentLetterIndex > 0) {
      setState(() {
        currentLetterIndex--;
        isTraced = false;
        drawnPoints.clear();
        tracingProgress = 0.0;
        stars = [];
        _starController.reset();
        _letterController.forward(from: 0);
      });
    }
  }

  void _resetTracing() {
    setState(() {
      drawnPoints.clear();
      tracingProgress = 0.0;
      isTraced = false;
      stars = [];
      _starController.reset();
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text(
          '🎉 Amazing Work! 🎉',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '⭐⭐⭐',
              style: TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 20),
            const Text(
              'You traced all letters!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentLetterIndex = 0;
                _resetTracing();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              'Start Over',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              'Back to Home',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
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
              const SizedBox(height: 10),
              _buildTracingProgressBar(),
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
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white, size: 30),
            onPressed: _resetTracing,
          ),
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

  Widget _buildTracingProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            'Tracing Progress: ${(tracingProgress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: tracingProgress,
              minHeight: 12,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                tracingProgress >= 0.8 ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTracingArea(String letter) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background letter (guide)
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

              // Completed letter with gradient
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

              // Custom paint for drawn path
              CustomPaint(
                size: Size(300, 350),
                painter: TracingPainter(drawnPoints),
              ),

              // Instructions
              if (!isTraced && drawnPoints.isEmpty)
                const Positioned(
                  bottom: 30,
                  child: Text(
                    'Draw over the letter!',
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
            'Skip →',
            currentLetterIndex < letters.length - 1,
            _nextLetter,
            Colors.orange,
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

// Custom painter to draw the tracing path
class TracingPainter extends CustomPainter {
  final List<Offset> points;

  TracingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].isFinite && points[i + 1].isFinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(TracingPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}