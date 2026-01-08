import 'package:flutter/material.dart';
import 'dart:math';

class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({Key? key}) : super(key: key);

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> with TickerProviderStateMixin {
  final Map<String, List<String>> letterObjects = {
    'A': ['🍎 Apple', '🐜 Ant', '✈️ Airplane'],
    'B': ['🏀 Ball', '🦇 Bat', '🐝 Bee'],
    'C': ['🐱 Cat', '🚗 Car', '☕ Cup'],
    'D': ['🐕 Dog', '🦆 Duck', '🥁 Drum'],
    'E': ['🐘 Elephant', '🥚 Egg', '✉️ Envelope'],
    'F': ['🐸 Frog', '🌸 Flower', '🍟 Fries'],
    'G': ['🦒 Giraffe', '🍇 Grapes', '🎸 Guitar'],
    'H': ['🐴 Horse', '🏠 House', '🎩 Hat'],
  };

  late List<String> currentLetters;
  late List<String> currentObjects;
  String? selectedLetter;
  String? selectedObject;
  Set<String> matchedPairs = {};
  int score = 0;
  late AnimationController _shakeController;
  late AnimationController _successController;
  bool showingFeedback = false;

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
    _initializeGame();
  }

  void _initializeGame() {
    List<String> letters = letterObjects.keys.toList()..shuffle();
    currentLetters = letters.take(4).toList();
    currentObjects = currentLetters.map((letter) {
      return letterObjects[letter]![Random().nextInt(letterObjects[letter]!.length)];
    }).toList()..shuffle();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _checkMatch() {
    if (selectedLetter == null || selectedObject == null) return;

    String objectLetter = selectedObject![selectedObject!.indexOf(' ') + 1];

    setState(() {
      showingFeedback = true;
    });

    if (selectedLetter == objectLetter) {
      _successController.forward(from: 0);
      setState(() {
        matchedPairs.add(selectedLetter!);
        matchedPairs.add(selectedObject!);
        score += 10;
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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text(
          '🎉 Amazing Job! 🎉',
          style: TextStyle(
            fontSize: 28,
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
              style: TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score points!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                matchedPairs.clear();
                score = 0;
                selectedLetter = null;
                selectedObject = null;
                _initializeGame();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              'Play Again',
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade200,
              Colors.teal.shade200,
              Colors.blue.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildScoreBoard(),
              const SizedBox(height: 30),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildLetterColumn()),
                    Expanded(child: _buildObjectColumn()),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Tap a letter, then tap the matching object!',
                  style: TextStyle(
                    fontSize: 18,
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
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              '🎯 Matching Game',
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

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '⭐ Score: ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterColumn() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
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
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isMatched
                      ? [Colors.green.shade300, Colors.green.shade400]
                      : isSelected
                      ? [Colors.orange.shade300, Colors.orange.shade400]
                      : [Colors.white, Colors.grey.shade100],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
                    color: isMatched ? Colors.white : Colors.deepPurple,
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
      padding: const EdgeInsets.all(20),
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
              scale = 1.0 + (sin(_successController.value * pi) * 0.3);
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
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isMatched
                      ? [Colors.green.shade300, Colors.green.shade400]
                      : isSelected
                      ? [Colors.blue.shade300, Colors.blue.shade400]
                      : [Colors.white, Colors.grey.shade100],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  object,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isMatched ? Colors.white : Colors.deepPurple,
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