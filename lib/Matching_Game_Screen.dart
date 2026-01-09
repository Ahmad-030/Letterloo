import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({Key? key}) : super(key: key);

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> with TickerProviderStateMixin {
  final Map<String, List<String>> letterObjects = {
    'A': ['🍎 Apple', '🐜 Ant', '✈️ Airplane', '🎨 Art'],
    'B': ['🏀 Ball', '🦇 Bat', '🐝 Bee', '🎈 Balloon'],
    'C': ['🐱 Cat', '🚗 Car', '☕ Cup', '🍪 Cookie'],
    'D': ['🐕 Dog', '🦆 Duck', '🥁 Drum', '🚪 Door'],
    'E': ['🐘 Elephant', '🥚 Egg', '✉️ Envelope', '👁️ Eye'],
    'F': ['🐸 Frog', '🌸 Flower', '🍟 Fries', '🔥 Fire'],
    'G': ['🦒 Giraffe', '🍇 Grapes', '🎸 Guitar', '🎁 Gift'],
    'H': ['🐴 Horse', '🏠 House', '🎩 Hat', '❤️ Heart'],
    'I': ['🍦 Ice Cream', '🏝️ Island', '💡 Idea', '🦔 Iguana'],
    'J': ['🕹️ Joystick', '🧃 Juice', '🤹 Juggle', '🃏 Joker'],
  };

  late List<String> currentLetters;
  late List<String> currentObjects;
  String? selectedLetter;
  String? selectedObject;
  Set<String> matchedPairs = {};
  int score = 0;
  int level = 1;
  late AnimationController _shakeController;
  late AnimationController _successController;
  late AnimationController _pulseController;
  bool showingFeedback = false;
  bool isMuted = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _initializeGame();
  }

  void _initializeGame() {
    int pairCount = min(4 + level, 6);
    List<String> letters = letterObjects.keys.toList()..shuffle();
    currentLetters = letters.take(pairCount).toList();
    currentObjects = currentLetters.map((letter) {
      return letterObjects[letter]![Random().nextInt(letterObjects[letter]!.length)];
    }).toList()..shuffle();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _successController.dispose();
    _pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(bool success) async {
    if (isMuted) return;
    try {
      if (success) {
        await _audioPlayer.play(AssetSource('audio/success.mp3'));
      } else {
        await _audioPlayer.play(AssetSource('audio/error.mp3'));
      }
    } catch (e) {
      // Sound files not found
    }
  }

  void _checkMatch() {
    if (selectedLetter == null || selectedObject == null) return;

    String objectLetter = selectedObject![selectedObject!.indexOf(' ') + 1];

    setState(() {
      showingFeedback = true;
    });

    if (selectedLetter == objectLetter) {
      _successController.forward(from: 0);
      _playSound(true);
      setState(() {
        matchedPairs.add(selectedLetter!);
        matchedPairs.add(selectedObject!);
        score += 10 * level;
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          selectedLetter = null;
          selectedObject = null;
          showingFeedback = false;

          if (matchedPairs.length == currentLetters.length * 2) {
            _showCompletionDialog();
          }
        });
      });
    } else {
      _shakeController.forward(from: 0);
      _playSound(false);
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          selectedLetter = null;
          selectedObject = null;
          showingFeedback = false;
        });
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
              colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉 Level Complete! 🎉',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      '⭐⭐⭐',
                      style: TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Level $level',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Score: $score points',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          level++;
                          matchedPairs.clear();
                          selectedLetter = null;
                          selectedObject = null;
                          _initializeGame();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Next Level',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 15),
              _buildScoreBoard(),
              const SizedBox(height: 25),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildLetterColumn()),
                    Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.5),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: _buildObjectColumn()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '👆 Tap a letter, then tap the matching object!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
              '🎯 Matching Game',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              icon: Icon(
                isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                setState(() {
                  isMuted = !isMuted;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreItem('🏆 Level', '$level'),
          Container(width: 2, height: 30, color: Colors.grey.shade300),
          _buildScoreItem('⭐ Score', '$score'),
          Container(width: 2, height: 30, color: Colors.grey.shade300),
          _buildScoreItem('✅ Matched', '${matchedPairs.length ~/ 2}/${currentLetters.length}'),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF667EEA),
          ),
        ),
      ],
    );
  }

  Widget _buildLetterColumn() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: currentLetters.length,
      itemBuilder: (context, index) {
        String letter = currentLetters[index];
        bool isMatched = matchedPairs.contains(letter);
        bool isSelected = selectedLetter == letter;

        return AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            double shake = 0;
            if (isSelected && showingFeedback && !isMatched) {
              shake = sin(_shakeController.value * pi * 4) * 10;
            }
            return Transform.translate(
              offset: Offset(shake, 0),
              child: child,
            );
          },
          child: GestureDetector(
            onTap: isMatched ? null : () {
              setState(() {
                selectedLetter = letter;
                _checkMatch();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isMatched
                      ? [Colors.green.shade400, Colors.green.shade600]
                      : isSelected
                      ? [Colors.orange.shade400, Colors.orange.shade600]
                      : [Colors.white, Colors.grey.shade50],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isMatched ? Colors.green : isSelected ? Colors.orange : Colors.grey)
                        .withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: isMatched || isSelected ? Colors.white : const Color(0xFF667EEA),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildObjectColumn() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: currentObjects.length,
      itemBuilder: (context, index) {
        String object = currentObjects[index];
        bool isMatched = matchedPairs.contains(object);
        bool isSelected = selectedObject == object;

        return AnimatedBuilder(
          animation: _successController,
          builder: (context, child) {
            double scale = 1.0;
            if (isMatched && _successController.isAnimating) {
              scale = 1.0 + (sin(_successController.value * pi) * 0.2);
            }
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: GestureDetector(
            onTap: isMatched ? null : () {
              setState(() {
                selectedObject = object;
                _checkMatch();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isMatched
                      ? [Colors.green.shade400, Colors.green.shade600]
                      : isSelected
                      ? [Colors.blue.shade400, Colors.blue.shade600]
                      : [Colors.white, Colors.grey.shade50],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isMatched ? Colors.green : isSelected ? Colors.blue : Colors.grey)
                        .withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  object,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isMatched || isSelected ? Colors.white : const Color(0xFF667EEA),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}