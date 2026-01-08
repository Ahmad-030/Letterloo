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
  List<Offset> drawnPoints = [];
  List<Offset> stars = [];
  late AnimationController _starController;
  late AnimationController _letterController;
  double tracedPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _letterController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
        15,
            (index) => Offset(
          50 + math.Random().nextDouble() * 200,
          50 + math.Random().nextDouble() * 250,
        ),
      );
    });

    _starController.forward(from: 0);
  }

  void _checkTracingProgress() {
    if (drawnPoints.length > 50 && !isTraced) {
      _onLetterTraced();
    }
  }

  void _nextLetter() {
    if (currentLetterIndex < letters.length - 1) {
      setState(() {
        currentLetterIndex++;
        isTraced = false;
        drawnPoints = [];
        stars = [];
        tracedPercentage = 0.0;
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
        drawnPoints = [];
        stars = [];
        tracedPercentage = 0.0;
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
              Color(0xFFFF9A9E),
              Color(0xFFFAD0C4),
              Color(0xFFFBC2EB),
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
            offset: Offset(0, 5),
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
          const SizedBox(width: 40),
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
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  letters[currentLetterIndex],
                  style: TextStyle(
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
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (currentLetterIndex + 1) / letters.length,
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
        setState(() {
          drawnPoints = [];
        });
      },
      onPanUpdate: (details) {
        setState(() {
          RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            Offset point = box.globalToLocal(details.globalPosition);
            drawnPoints.add(point);
            tracedPercentage = (drawnPoints.length / 50).clamp(0.0, 1.0);
            _checkTracingProgress();
          }
        });
      },
      onPanEnd: (details) {
        _checkTracingProgress();
      },
      child: Container(
        width: 320,
        height: 380,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6C63FF).withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 5,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Progress indicator
            if (!isTraced && drawnPoints.isNotEmpty)
              Positioned(
                top: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF6C63FF).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(tracedPercentage * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Letter outline
            if (!isTraced)
              ScaleTransition(
                scale: _letterController,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 220,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 8
                      ..color = Colors.grey.shade300,
                  ),
                ),
              ),

            // Traced letter (colored)
            if (isTraced)
              ScaleTransition(
                scale: _starController,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 220,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Color(0xFF667eea),
                          Color(0xFF764ba2),
                          Color(0xFFF093FB),
                        ],
                      ).createShader(const Rect.fromLTWH(0, 0, 220, 220)),
                  ),
                ),
              ),

            // Custom drawing path
            if (!isTraced)
              CustomPaint(
                size: Size(320, 380),
                painter: DrawingPainter(drawnPoints),
              ),

            // Instructions
            if (!isTraced && drawnPoints.isEmpty)
              Positioned(
                bottom: 40,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF6C63FF).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Trace the letter!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Success message
            if (isTraced)
              Positioned(
                bottom: 40,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4CAF50).withOpacity(0.4),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Excellent Work!',
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
              top: position.dy - (_starController.value * 80),
              child: Opacity(
                opacity: 1.0 - _starController.value,
                child: Transform.scale(
                  scale: 1.0 + (_starController.value * 0.5),
                  child: Transform.rotate(
                    angle: _starController.value * 4 * math.pi,
                    child: const Text(
                      '⭐',
                      style: TextStyle(fontSize: 32),
                    ),
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
            icon: Icons.arrow_back_ios,
            enabled: currentLetterIndex > 0,
            onPressed: _previousLetter,
            color: Color(0xFF6C63FF),
          ),
          _buildNavButton(
            icon: Icons.arrow_forward_ios,
            enabled: currentLetterIndex < letters.length - 1,
            onPressed: _nextLetter,
            color: Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: enabled
            ? LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: enabled ? null : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        boxShadow: enabled
            ? [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF6C63FF)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}