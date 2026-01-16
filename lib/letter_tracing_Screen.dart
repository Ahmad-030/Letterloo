import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LetterTracingScreen extends StatefulWidget {
  const LetterTracingScreen({Key? key}) : super(key: key);

  @override
  State<LetterTracingScreen> createState() => _LetterTracingScreenState();
}

class _LetterTracingScreenState extends State<LetterTracingScreen> with TickerProviderStateMixin {
  final GlobalKey _traceKey = GlobalKey();

  int currentLetterIndex = 0;
  final List<String> letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

  // Path-based state with proper coverage tracking
  Path letterPath = Path();
  List<PathSegment> pathSegments = [];
  Map<int, Set<int>> segmentCoverage = {}; // segment -> covered point indices

  double traceProgress = 0.0;
  bool isTraced = false;

  late AnimationController _celebrationController;
  List<Offset> stars = [];
  late AudioPlayer _audioPlayer;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadProgress();
  }

  // Load saved progress
  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex = prefs.getInt('currentLetterIndex') ?? 0;

      setState(() {
        currentLetterIndex = savedIndex;
        _initializeLetterPath();
      });
    } catch (e) {
      debugPrint('Error loading progress: $e');
      _initializeLetterPath();
    }
  }

  // Save progress
  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentLetterIndex', currentLetterIndex);
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  // Clear progress (when restarting)
  Future<void> _clearProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentLetterIndex');
    } catch (e) {
      debugPrint('Error clearing progress: $e');
    }
  }

  void _initializeLetterPath() {
    const size = Size(320, 380);
    letterPath = _getLetterPath(letters[currentLetterIndex], size);
    pathSegments = _extractPathSegments(letterPath);

    // Initialize coverage map
    segmentCoverage.clear();
    for (int i = 0; i < pathSegments.length; i++) {
      segmentCoverage[i] = {};
    }

    traceProgress = 0.0;
    isTraced = false;
  }

  // Extract individual segments from path with optimized sampling
  List<PathSegment> _extractPathSegments(Path path) {
    List<PathSegment> segments = [];

    for (final metric in path.computeMetrics()) {
      List<Offset> points = [];
      // Optimized: sample every 8 pixels instead of 6 for better performance
      for (double i = 0; i < metric.length; i += 8) {
        final pos = metric.getTangentForOffset(i);
        if (pos != null) points.add(pos.position);
      }
      if (points.isNotEmpty) {
        segments.add(PathSegment(points: points));
      }
    }

    return segments;
  }

  Path _getLetterPath(String letter, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    switch (letter) {
      case 'A':
      // Left stroke
        path.moveTo(w * 0.5, h * 0.15);
        path.lineTo(w * 0.2, h * 0.85);
        // Right stroke
        path.moveTo(w * 0.5, h * 0.15);
        path.lineTo(w * 0.8, h * 0.85);
        // Horizontal bar
        path.moveTo(w * 0.32, h * 0.55);
        path.lineTo(w * 0.68, h * 0.55);
        break;

      case 'B':
      // Vertical line
        path.moveTo(w * 0.25, h * 0.15);
        path.lineTo(w * 0.25, h * 0.85);
        // Top bump
        path.moveTo(w * 0.25, h * 0.15);
        path.quadraticBezierTo(w * 0.65, h * 0.15, w * 0.65, h * 0.35);
        path.quadraticBezierTo(w * 0.65, h * 0.5, w * 0.25, h * 0.5);
        // Bottom bump
        path.moveTo(w * 0.25, h * 0.5);
        path.quadraticBezierTo(w * 0.7, h * 0.5, w * 0.7, h * 0.7);
        path.quadraticBezierTo(w * 0.7, h * 0.85, w * 0.25, h * 0.85);
        break;

      case 'C':
        path.addArc(
          Rect.fromLTWH(w * 0.2, h * 0.15, w * 0.6, h * 0.7),
          math.pi * 0.3,
          math.pi * 1.4,
        );
        break;

      case 'D':
      // Vertical line
        path.moveTo(w * 0.25, h * 0.15);
        path.lineTo(w * 0.25, h * 0.85);
        // Curve
        path.moveTo(w * 0.25, h * 0.15);
        path.quadraticBezierTo(w * 0.75, h * 0.15, w * 0.75, h * 0.5);
        path.quadraticBezierTo(w * 0.75, h * 0.85, w * 0.25, h * 0.85);
        break;

      case 'E':
      // Top horizontal
        path.moveTo(w * 0.7, h * 0.15);
        path.lineTo(w * 0.25, h * 0.15);
        // Vertical
        path.lineTo(w * 0.25, h * 0.85);
        // Bottom horizontal
        path.lineTo(w * 0.7, h * 0.85);
        // Middle horizontal
        path.moveTo(w * 0.25, h * 0.5);
        path.lineTo(w * 0.65, h * 0.5);
        break;

      case 'F':
      // Vertical
        path.moveTo(w * 0.25, h * 0.85);
        path.lineTo(w * 0.25, h * 0.15);
        // Top horizontal
        path.lineTo(w * 0.7, h * 0.15);
        // Middle horizontal
        path.moveTo(w * 0.25, h * 0.5);
        path.lineTo(w * 0.65, h * 0.5);
        break;

      case 'G':
      // C curve
        path.addArc(
          Rect.fromLTWH(w * 0.2, h * 0.15, w * 0.6, h * 0.7),
          math.pi * 0.3,
          math.pi * 1.4,
        );
        // Horizontal bar
        path.moveTo(w * 0.8, h * 0.5);
        path.lineTo(w * 0.5, h * 0.5);
        break;

      case 'H':
      // Left vertical
        path.moveTo(w * 0.25, h * 0.15);
        path.lineTo(w * 0.25, h * 0.85);
        // Right vertical
        path.moveTo(w * 0.75, h * 0.15);
        path.lineTo(w * 0.75, h * 0.85);
        // Horizontal bar
        path.moveTo(w * 0.25, h * 0.5);
        path.lineTo(w * 0.75, h * 0.5);
        break;

      case 'I':
      // Top horizontal
        path.moveTo(w * 0.35, h * 0.15);
        path.lineTo(w * 0.65, h * 0.15);
        // Vertical
        path.moveTo(w * 0.5, h * 0.15);
        path.lineTo(w * 0.5, h * 0.85);
        // Bottom horizontal
        path.moveTo(w * 0.35, h * 0.85);
        path.lineTo(w * 0.65, h * 0.85);
        break;

      case 'J':
      // Vertical with curve
        path.moveTo(w * 0.6, h * 0.15);
        path.lineTo(w * 0.6, h * 0.7);
        path.quadraticBezierTo(w * 0.6, h * 0.85, w * 0.4, h * 0.85);
        path.quadraticBezierTo(w * 0.25, h * 0.85, w * 0.25, h * 0.7);
        break;

      case 'K':
      // Vertical
        path.moveTo(w * 0.25, h * 0.15);
        path.lineTo(w * 0.25, h * 0.85);
        // Top diagonal
        path.moveTo(w * 0.75, h * 0.15);
        path.lineTo(w * 0.25, h * 0.5);
        // Bottom diagonal
        path.lineTo(w * 0.75, h * 0.85);
        break;

      case 'L':
      // Vertical
        path.moveTo(w * 0.25, h * 0.15);
        path.lineTo(w * 0.25, h * 0.85);
        // Bottom horizontal
        path.lineTo(w * 0.7, h * 0.85);
        break;

      case 'M':
      // Left vertical
        path.moveTo(w * 0.2, h * 0.85);
        path.lineTo(w * 0.2, h * 0.15);
        // Peak
        path.lineTo(w * 0.5, h * 0.4);
        path.lineTo(w * 0.8, h * 0.15);
        // Right vertical
        path.lineTo(w * 0.8, h * 0.85);
        break;

      case 'N':
      // Left vertical
        path.moveTo(w * 0.2, h * 0.85);
        path.lineTo(w * 0.2, h * 0.15);
        // Diagonal
        path.lineTo(w * 0.8, h * 0.85);
        // Right vertical
        path.lineTo(w * 0.8, h * 0.15);
        break;

      case 'O':
        path.addOval(Rect.fromLTWH(w * 0.2, h * 0.15, w * 0.6, h * 0.7));
        break;

      case 'P':
      // Vertical
        path.moveTo(w * 0.25, h * 0.85);
        path.lineTo(w * 0.25, h * 0.15);
        // Top bump
        path.quadraticBezierTo(w * 0.7, h * 0.15, w * 0.7, h * 0.35);
        path.quadraticBezierTo(w * 0.7, h * 0.5, w * 0.25, h * 0.5);
        break;

      case 'Q':
      // Circle
        path.addOval(Rect.fromLTWH(w * 0.2, h * 0.15, w * 0.6, h * 0.6));
        // Tail
        path.moveTo(w * 0.6, h * 0.6);
        path.lineTo(w * 0.8, h * 0.85);
        break;

      case 'R':
      // Vertical
        path.moveTo(w * 0.25, h * 0.85);
        path.lineTo(w * 0.25, h * 0.15);
        // Top bump
        path.quadraticBezierTo(w * 0.7, h * 0.15, w * 0.7, h * 0.35);
        path.quadraticBezierTo(w * 0.7, h * 0.5, w * 0.25, h * 0.5);
        // Diagonal leg
        path.moveTo(w * 0.25, h * 0.5);
        path.lineTo(w * 0.75, h * 0.85);
        break;

      case 'S':
        path.moveTo(w * 0.7, h * 0.25);
        path.quadraticBezierTo(w * 0.7, h * 0.15, w * 0.5, h * 0.15);
        path.quadraticBezierTo(w * 0.3, h * 0.15, w * 0.3, h * 0.3);
        path.quadraticBezierTo(w * 0.3, h * 0.45, w * 0.5, h * 0.5);
        path.quadraticBezierTo(w * 0.7, h * 0.55, w * 0.7, h * 0.7);
        path.quadraticBezierTo(w * 0.7, h * 0.85, w * 0.5, h * 0.85);
        path.quadraticBezierTo(w * 0.3, h * 0.85, w * 0.3, h * 0.75);
        break;

      case 'T':
      // Top horizontal
        path.moveTo(w * 0.2, h * 0.15);
        path.lineTo(w * 0.8, h * 0.15);
        // Vertical
        path.moveTo(w * 0.5, h * 0.15);
        path.lineTo(w * 0.5, h * 0.85);
        break;

      case 'U':
        path.moveTo(w * 0.25, h * 0.15);
        path.lineTo(w * 0.25, h * 0.7);
        path.quadraticBezierTo(w * 0.25, h * 0.85, w * 0.5, h * 0.85);
        path.quadraticBezierTo(w * 0.75, h * 0.85, w * 0.75, h * 0.7);
        path.lineTo(w * 0.75, h * 0.15);
        break;

      case 'V':
        path.moveTo(w * 0.2, h * 0.15);
        path.lineTo(w * 0.5, h * 0.85);
        path.lineTo(w * 0.8, h * 0.15);
        break;

      case 'W':
        path.moveTo(w * 0.15, h * 0.15);
        path.lineTo(w * 0.3, h * 0.85);
        path.lineTo(w * 0.5, h * 0.5);
        path.lineTo(w * 0.7, h * 0.85);
        path.lineTo(w * 0.85, h * 0.15);
        break;

      case 'X':
      // Top-left to bottom-right
        path.moveTo(w * 0.2, h * 0.15);
        path.lineTo(w * 0.8, h * 0.85);
        // Top-right to bottom-left
        path.moveTo(w * 0.8, h * 0.15);
        path.lineTo(w * 0.2, h * 0.85);
        break;

      case 'Y':
      // Top-left to center
        path.moveTo(w * 0.2, h * 0.15);
        path.lineTo(w * 0.5, h * 0.5);
        // Top-right to center
        path.moveTo(w * 0.8, h * 0.15);
        path.lineTo(w * 0.5, h * 0.5);
        // Center to bottom
        path.lineTo(w * 0.5, h * 0.85);
        break;

      case 'Z':
      // Top horizontal
        path.moveTo(w * 0.25, h * 0.15);
        path.lineTo(w * 0.75, h * 0.15);
        // Diagonal
        path.lineTo(w * 0.25, h * 0.85);
        // Bottom horizontal
        path.lineTo(w * 0.75, h * 0.85);
        break;

      default:
      // Fallback to A shape
        path.moveTo(w * 0.5, h * 0.15);
        path.lineTo(w * 0.2, h * 0.85);
        path.moveTo(w * 0.5, h * 0.15);
        path.lineTo(w * 0.8, h * 0.85);
        path.moveTo(w * 0.32, h * 0.55);
        path.lineTo(w * 0.68, h * 0.55);
    }

    return path;
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSuccessSound() async {
    if (isMuted) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/succes.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
  }

  void _onFingerMove(Offset finger) {
    if (isTraced) return;

    bool anyChange = false;

    // Check ALL segments and mark covered points
    for (int segIdx = 0; segIdx < pathSegments.length; segIdx++) {
      final segment = pathSegments[segIdx];

      for (int pointIdx = 0; pointIdx < segment.points.length; pointIdx++) {
        // Skip already covered points
        if (segmentCoverage[segIdx]!.contains(pointIdx)) continue;

        final point = segment.points[pointIdx];

        // If finger is close enough, mark this point as covered
        if ((point - finger).distance < 25) {
          segmentCoverage[segIdx]!.add(pointIdx);
          anyChange = true;
        }
      }
    }

    if (anyChange) {
      setState(() {
        _calculateProgress();

        if (traceProgress >= 1.0 && !isTraced) {
          _onLetterCompleted();
        }
      });
    }
  }

  void _calculateProgress() {
    int totalPoints = 0;
    int coveredPoints = 0;

    for (int i = 0; i < pathSegments.length; i++) {
      totalPoints += pathSegments[i].points.length;
      coveredPoints += segmentCoverage[i]!.length;
    }

    traceProgress = totalPoints > 0 ? (coveredPoints / totalPoints).clamp(0.0, 1.0) : 0.0;
  }

  void _onLetterCompleted() {
    setState(() {
      isTraced = true;
      stars = List.generate(
        30,
            (index) => Offset(
          40 + math.Random().nextDouble() * 240,
          40 + math.Random().nextDouble() * 300,
        ),
      );
    });

    _celebrationController.forward(from: 0);
    _playSuccessSound();

    // Show completion dialog after the last letter (Z)
    if (currentLetterIndex == letters.length - 1) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        _showCompletionDialog();
      });
    }
  }

  void _nextLetter() {
    if (currentLetterIndex < letters.length - 1) {
      setState(() {
        currentLetterIndex++;
        _saveProgress();
        _initializeLetterPath();
        stars = [];
        _celebrationController.reset();
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFF093FB)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 20),
              const Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'You\'ve traced all 26 letters!\nAmazing work! ⭐',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearProgress();
                        setState(() {
                          currentLetterIndex = 0;
                          _initializeLetterPath();
                          stars = [];
                          _celebrationController.reset();
                        });
                      },
                      icon: const Icon(Icons.replay, color: Color(0xFF667eea)),
                      label: const Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF667eea),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _clearProgress();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.home, color: Color(0xFF667eea)),
                      label: const Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF667eea),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _previousLetter() {
    if (currentLetterIndex > 0) {
      setState(() {
        currentLetterIndex--;
        _saveProgress();
        _initializeLetterPath();
        stars = [];
        _celebrationController.reset();
      });
    }
  }

  void _resetCurrentLetter() {
    setState(() {
      _initializeLetterPath();
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
            onPressed: () {
              _saveProgress();
              Navigator.pop(context);
            },
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
          IconButton(
            icon: Icon(
              isMuted ? Icons.volume_off : Icons.volume_up,
              color: Color(0xFF6C63FF),
              size: 24,
            ),
            onPressed: _toggleMute,
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
              child: Stack(
                children: [
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: traceProgress,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(traceProgress * 100).toInt()}% Complete',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
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
          RenderBox box = _traceKey.currentContext!.findRenderObject() as RenderBox;
          Offset localPosition = box.globalToLocal(details.globalPosition);
          _onFingerMove(localPosition);
        }
      },
      onPanUpdate: (details) {
        if (!isTraced) {
          RenderBox box = _traceKey.currentContext!.findRenderObject() as RenderBox;
          Offset localPosition = box.globalToLocal(details.globalPosition);
          _onFingerMove(localPosition);
        }
      },
      child: Container(
        key: _traceKey,
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
              // Path-based tracing canvas
              CustomPaint(
                size: const Size(320, 380),
                painter: LetterPathPainter(
                  pathSegments: pathSegments,
                  segmentCoverage: segmentCoverage,
                  progress: traceProgress,
                  completed: isTraced,
                ),
              ),

              // Instructions
              if (traceProgress < 0.05)
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
                            'Trace over the letter path',
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
                ? const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)])
                : null,
          ),
          _buildNavButton(
            icon: Icons.arrow_forward,
            label: 'Next',
            onPressed: currentLetterIndex < letters.length - 1 ? _nextLetter : null,
            gradient: currentLetterIndex < letters.length - 1
                ? const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)])
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
            gradient: gradient ?? LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade500]),
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

// Helper class to store path segments
class PathSegment {
  final List<Offset> points;

  PathSegment({required this.points});
}

class LetterPathPainter extends CustomPainter {
  final List<PathSegment> pathSegments;
  final Map<int, Set<int>> segmentCoverage;
  final double progress;
  final bool completed;

  LetterPathPainter({
    required this.pathSegments,
    required this.segmentCoverage,
    required this.progress,
    required this.completed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw each segment
    for (int segIdx = 0; segIdx < pathSegments.length; segIdx++) {
      final segment = pathSegments[segIdx];
      final coveredPoints = segmentCoverage[segIdx] ?? {};

      // Draw guide path (grey)
      final guidePath = Path();
      if (segment.points.isNotEmpty) {
        guidePath.moveTo(segment.points[0].dx, segment.points[0].dy);
        for (int i = 1; i < segment.points.length; i++) {
          guidePath.lineTo(segment.points[i].dx, segment.points[i].dy);
        }
      }

      final guidePaint = Paint()
        ..color = Colors.grey.shade300
        ..strokeWidth = 14
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(guidePath, guidePaint);

      // Draw traced portions with gradient
      if (coveredPoints.isNotEmpty) {
        // Group consecutive covered points into paths
        List<List<int>> groups = [];
        List<int> currentGroup = [];

        List<int> sortedCovered = coveredPoints.toList()..sort();

        for (int idx in sortedCovered) {
          if (currentGroup.isEmpty || idx == currentGroup.last + 1 || idx == currentGroup.last) {
            if (!currentGroup.contains(idx)) {
              currentGroup.add(idx);
            }
          } else {
            if (currentGroup.isNotEmpty) groups.add(List.from(currentGroup));
            currentGroup = [idx];
          }
        }
        if (currentGroup.isNotEmpty) groups.add(currentGroup);

        // Draw each traced group
        for (var group in groups) {
          if (group.isEmpty) continue;

          final tracedPath = Path();
          tracedPath.moveTo(
            segment.points[group[0]].dx,
            segment.points[group[0]].dy,
          );

          for (int i = 1; i < group.length; i++) {
            final idx = group[i];
            if (idx < segment.points.length) {
              tracedPath.lineTo(
                segment.points[idx].dx,
                segment.points[idx].dy,
              );
            }
          }

          // Glow effect
          final glowPaint = Paint()
            ..shader = const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
            ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
            ..strokeWidth = 20
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

          final tracedPaint = Paint()
            ..shader = const LinearGradient(
              colors: [
                Color(0xFF4CAF50),
                Color(0xFF2196F3),
                Color(0xFF9C27B0),
              ],
            ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
            ..strokeWidth = 16
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;

          canvas.drawPath(tracedPath, glowPaint);
          canvas.drawPath(tracedPath, tracedPaint);
        }
      }
    }

    // Fill entire letter on completion
    if (completed) {
      for (final segment in pathSegments) {
        if (segment.points.isEmpty) continue;

        final fillPath = Path();
        fillPath.moveTo(segment.points[0].dx, segment.points[0].dy);
        for (int i = 1; i < segment.points.length; i++) {
          fillPath.lineTo(segment.points[i].dx, segment.points[i].dy);
        }

        final fillPaint = Paint()
          ..shader = const LinearGradient(
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFF093FB),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..strokeWidth = 18
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        canvas.drawPath(fillPath, fillPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant LetterPathPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.completed != completed ||
        oldDelegate.segmentCoverage != segmentCoverage;
  }
}