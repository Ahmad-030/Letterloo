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
  late AnimationController _celebrationController;
  late AnimationController _hintController;
  List<Offset> stars = [];

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _hintController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  void _onDrawUpdate(Offset point) {
    if (isTraced) return;

    setState(() {
      drawnPoints.add(point);
      _calculateProgress();
    });

    if (tracingProgress >= 0.75 && !isTraced) {
      _onLetterCompleted();
    }
  }

  void _calculateProgress() {
    if (drawnPoints.isEmpty) {
      tracingProgress = 0.0;
      return;
    }

    // Simple progress calculation based on coverage
    Set<String> coveredAreas = {};
    for (var point in drawnPoints) {
      int gridX = (point.dx / 30).floor();
      int gridY = (point.dy / 30).floor();
      coveredAreas.add('$gridX,$gridY');
    }

    // Estimate based on letter complexity - more lenient calculation
    double expectedCoverage = 12 + (letters[currentLetterIndex].codeUnitAt(0) % 8);
    tracingProgress = (coveredAreas.length / expectedCoverage).clamp(0.0, 1.0);
  }

  void _onLetterCompleted() {
    if (isTraced) return;

    setState(() {
      isTraced = true;
      stars = List.generate(
        25,
            (index) => Offset(
          40 + math.Random().nextDouble() * 240,
          40 + math.Random().nextDouble() * 300,
        ),
      );
    });

    _celebrationController.forward(from: 0);
  }

  void _nextLetter() {
    if (currentLetterIndex < letters.length - 1) {
      setState(() {
        currentLetterIndex++;
        drawnPoints = [];
        isTraced = false;
        tracingProgress = 0.0;
        stars = [];
        _celebrationController.reset();
      });
    }
  }

  void _previousLetter() {
    if (currentLetterIndex > 0) {
      setState(() {
        currentLetterIndex--;
        drawnPoints = [];
        isTraced = false;
        tracingProgress = 0.0;
        stars = [];
        _celebrationController.reset();
      });
    }
  }

  void _resetCurrentLetter() {
    setState(() {
      drawnPoints = [];
      isTraced = false;
      tracingProgress = 0.0;
      stars = [];
      _celebrationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentLetter = letters[currentLetterIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFF093FB),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 15),
              _buildProgressBar(),
              const SizedBox(height: 25),
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildTracingArea(currentLetter),
                      if (isTraced) _buildCelebrationAnimation(),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF6C63FF), size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              '✏️ Trace Letters',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C63FF),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF6C63FF), size: 24),
            onPressed: _resetCurrentLetter,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Letter ${currentLetterIndex + 1}/${letters.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  letters[currentLetterIndex],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: tracingProgress,
                minHeight: 12,
                backgroundColor: Colors.white.withOpacity(0.5),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTracingArea(String letter) {
    return GestureDetector(
      onPanStart: (details) {
        if (!isTraced) {
          RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            Offset localPosition = box.globalToLocal(details.globalPosition);
            _onDrawUpdate(localPosition);
          }
        }
      },
      onPanUpdate: (details) {
        if (!isTraced) {
          RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            Offset localPosition = box.globalToLocal(details.globalPosition);
            _onDrawUpdate(localPosition);
          }
        }
      },
      onPanEnd: (_) {
        if (!isTraced) {
          setState(() {
            drawnPoints.add(Offset.infinite); // Add break point
          });
        }
      },
      child: Container(
        width: 320,
        height: 380,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              // Guide letter with animated hint
              Center(
                child: AnimatedBuilder(
                  animation: _hintController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: isTraced ? 0 : (0.15 + (_hintController.value * 0.05)),
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: 240,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade300,
                          height: 1.0,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // User's drawing
              CustomPaint(
                size: const Size(320, 380),
                painter: DrawingPainter(points: drawnPoints),
              ),

              // Completed letter
              if (isTraced)
                Center(
                  child: ScaleTransition(
                    scale: _celebrationController,
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 240,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [
                              Color(0xFF667eea),
                              Color(0xFF764ba2),
                              Color(0xFFF093FB),
                            ],
                          ).createShader(const Rect.fromLTWH(0, 0, 240, 240)),
                      ),
                    ),
                  ),
                ),

              // Instructions
              if (!isTraced && drawnPoints.isEmpty)
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.gesture, color: Colors.white, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'Trace the letter with your finger',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Success message
              if (isTraced)
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Excellent! Well Done! 🎉',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationAnimation() {
    return AnimatedBuilder(
      animation: _celebrationController,
      builder: (context, child) {
        return Stack(
          children: stars.map((star) {
            return Positioned(
              left: star.dx,
              top: star.dy - (_celebrationController.value * 120),
              child: Opacity(
                opacity: 1 - _celebrationController.value,
                child: Transform.rotate(
                  angle: _celebrationController.value * 2 * math.pi,
                  child: const Text(
                    '⭐',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton(
            icon: Icons.arrow_back,
            label: 'Previous',
            onPressed: currentLetterIndex > 0 ? _previousLetter : null,
            gradient: currentLetterIndex > 0
                ? const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            )
                : null,
          ),
          _buildNavButton(
            icon: Icons.arrow_forward,
            label: 'Next',
            onPressed: currentLetterIndex < letters.length - 1 ? _nextLetter : null,
            gradient: currentLetterIndex < letters.length - 1
                ? const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    Gradient? gradient,
  }) {
    return Opacity(
      opacity: onPressed != null ? 1.0 : 0.4,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: gradient ??
                LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade500],
                ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon == Icons.arrow_back) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (icon == Icons.arrow_forward) ...[
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF667eea)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].isFinite && points[i + 1].isFinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }

    // Draw circles at points for a smoother look
    final circlePaint = Paint()
      ..color = const Color(0xFF667eea)
      ..style = PaintingStyle.fill;

    for (var point in points) {
      if (point.isFinite) {
        canvas.drawCircle(point, 4, circlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.points.length != points.length;
  }
}