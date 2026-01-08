import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';

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
  late AnimationController _successController;
  late AnimationController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSuccessSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/success.mp3'));
    } catch (e) {
      // Sound file not found, continue without sound
    }
  }

  void _onPanUpdate(DragUpdateDetails details, Size canvasSize) {
    setState(() {
      RenderBox box = context.findRenderObject() as RenderBox;
      Offset localPosition = box.globalToLocal(details.globalPosition);

      // Adjust for canvas position
      Offset adjustedPosition = Offset(
        localPosition.dx - (MediaQuery.of(context).size.width - canvasSize.width) / 2,
        localPosition.dy - 200,
      );

      if (adjustedPosition.dx >= 0 && adjustedPosition.dx <= canvasSize.width &&
          adjustedPosition.dy >= 0 && adjustedPosition.dy <= canvasSize.height) {
        drawnPoints.add(adjustedPosition);

        // Calculate tracing progress
        tracingProgress = (drawnPoints.length / 50).clamp(0.0, 1.0);

        if (tracingProgress >= 0.7 && !isTraced) {
          _completeTracing();
        }
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (tracingProgress >= 0.7 && !isTraced) {
      _completeTracing();
    }
  }

  void _completeTracing() {
    setState(() {
      isTraced = true;
    });
    _successController.forward(from: 0);
    _confettiController.forward(from: 0);
    _playSuccessSound();
  }

  void _nextLetter() {
    if (currentLetterIndex < letters.length - 1) {
      setState(() {
        currentLetterIndex++;
        drawnPoints = [];
        isTraced = false;
        tracingProgress = 0.0;
        _successController.reset();
        _confettiController.reset();
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
        _successController.reset();
        _confettiController.reset();
      });
    }
  }

  void _resetTracing() {
    setState(() {
      drawnPoints = [];
      isTraced = false;
      tracingProgress = 0.0;
      _successController.reset();
      _confettiController.reset();
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
              Color(0xFF6C63FF),
              Color(0xFF5A52D5),
              Color(0xFF4840BA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildProgressIndicator(),
              const SizedBox(height: 30),
              Expanded(
                child: _buildTracingCanvas(currentLetter),
              ),
              _buildControls(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
              onPressed: () => Navigator.pop(context),
            ),
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

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Letter ${currentLetterIndex + 1} of ${letters.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                '${(tracingProgress * 100).toInt()}% traced',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (currentLetterIndex + tracingProgress) / letters.length,
              minHeight: 12,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTracingCanvas(String letter) {
    Size canvasSize = const Size(350, 400);

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onPanUpdate: (details) => _onPanUpdate(details, canvasSize),
            onPanEnd: _onPanEnd,
            child: Container(
              width: canvasSize.width,
              height: canvasSize.height,
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
                  children: [
                    // Letter outline
                    Center(
                      child: Opacity(
                        opacity: isTraced ? 0.0 : 0.3,
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 250,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6C63FF),
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 8
                              ..color = const Color(0xFF6C63FF).withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    // Drawing canvas
                    CustomPaint(
                      size: canvasSize,
                      painter: DrawingPainter(drawnPoints),
                    ),
                    // Completed letter
                    if (isTraced)
                      ScaleTransition(
                        scale: _successController,
                        child: Center(
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFFFF6B9D)],
                            ).createShader(bounds),
                            child: Text(
                              letter,
                              style: const TextStyle(
                                fontSize: 250,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Confetti effect
                    if (isTraced)
                      AnimatedBuilder(
                        animation: _confettiController,
                        builder: (context, child) {
                          return CustomPaint(
                            size: canvasSize,
                            painter: ConfettiPainter(_confettiController.value),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Instruction text
          if (!isTraced && drawnPoints.isEmpty)
            Positioned(
              bottom: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '👆 Trace the letter with your finger',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          // Success message
          if (isTraced)
            Positioned(
              bottom: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Amazing Job!',
                      style: TextStyle(
                        fontSize: 20,
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
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.arrow_back,
            label: 'Previous',
            enabled: currentLetterIndex > 0,
            onPressed: _previousLetter,
            color: Colors.blue,
          ),
          _buildControlButton(
            icon: Icons.refresh,
            label: 'Reset',
            enabled: true,
            onPressed: _resetTracing,
            color: Colors.orange,
          ),
          _buildControlButton(
            icon: Icons.arrow_forward,
            label: 'Next',
            enabled: currentLetterIndex < letters.length - 1 && isTraced,
            onPressed: _nextLetter,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool enabled,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color : Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: enabled ? 8 : 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
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
    Paint paint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class ConfettiPainter extends CustomPainter {
  final double animationValue;

  ConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final startY = -20.0;
      final endY = size.height;
      final y = startY + (endY - startY) * animationValue;

      final colors = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.purple,
        Colors.orange,
      ];
      paint.color = colors[random.nextInt(colors.length)].withOpacity(1.0 - animationValue);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(animationValue * math.pi * 4);
      canvas.drawCircle(Offset.zero, 4, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}