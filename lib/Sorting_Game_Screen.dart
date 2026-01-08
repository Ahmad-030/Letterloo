import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class SortingGameScreen extends StatefulWidget {
  const SortingGameScreen({Key? key}) : super(key: key);

  @override
  State<SortingGameScreen> createState() => _SortingGameScreenState();
}

class _SortingGameScreenState extends State<SortingGameScreen> with TickerProviderStateMixin {
  List<String> letters = [];
  List<String> userArrangement = [];
  late AnimationController _confettiController;
  late AnimationController _bounceController;
  bool isCompleted = false;
  int level = 1;
  int score = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _initializeGame();
  }

  void _initializeGame() {
    int letterCount = min(5 + (level - 1), 10);
    List<String> allLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    letters = allLetters.take(letterCount).toList()..shuffle();
    userArrangement = [];
    isCompleted = false;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _bounceController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(bool success) async {
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

  void _checkOrder() {
    if (userArrangement.length != letters.length) {
      _showMessage('Please place all letters first!');
      return;
    }

    List<String> correctOrder = List.from(letters)..sort();
    if (userArrangement.join() == correctOrder.join()) {
      setState(() {
        isCompleted = true;
        score += 50 * level;
      });
      _confettiController.forward(from: 0);
      _playSound(true);
      _showSuccessDialog();
    } else {
      _bounceController.forward(from: 0).then((_) {
        _bounceController.reverse();
      });
      _playSound(false);
      _showMessage('Not quite right! Try again! 🤔');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF6C63FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessDialog() {
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
              colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎊 Perfect Sort! 🎊',
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
                      style: TextStyle(fontSize: 50),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Level $level Complete!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF11998E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total Score: $score',
                      style: const TextStyle(
                        fontSize: 20,
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
                          _initializeGame();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
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
                          color: Color(0xFF11998E),
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
                        backgroundColor: Colors.white.withOpacity(0.3),
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
                          color: Colors.white,
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
              Color(0xFF11998E),
              Color(0xFF38EF7D),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 15),
              _buildScoreBoard(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Drag letters to arrange A → Z',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Column(
                  children: [
                    _buildAvailableLetters(),
                    const SizedBox(height: 25),
                    Expanded(child: _buildSortingArea()),
                  ],
                ),
              ),
              _buildActionButtons(),
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
              '🔤 Sorting Challenge',
              style: TextStyle(
                fontSize: 26,
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
          _buildScoreItem('📝 Letters', '${letters.length}'),
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
            color: Color(0xFF11998E),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableLetters() {
    List<String> availableLetters = letters.where((letter) => !userArrangement.contains(letter)).toList();

    if (availableLetters.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          '✓ All letters placed!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableLetters.length,
        itemBuilder: (context, index) {
          return Draggable<String>(
            data: availableLetters[index],
            feedback: Material(
              color: Colors.transparent,
              child: _buildLetterCard(availableLetters[index], true),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _buildLetterCard(availableLetters[index], false),
            ),
            child: _buildLetterCard(availableLetters[index], false),
          );
        },
      ),
    );
  }

  Widget _buildLetterCard(String letter, bool isDragging) {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade400,
            Colors.deepOrange.shade500,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDragging ? 0.4 : 0.2),
            blurRadius: isDragging ? 20 : 10,
            spreadRadius: isDragging ? 5 : 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSortingArea() {
    return DragTarget<String>(
      onAccept: (letter) {
        setState(() {
          userArrangement.add(letter);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Arrangement:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF11998E),
                    ),
                  ),
                  if (userArrangement.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          userArrangement.clear();
                        });
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.orange,
                      ),
                    ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              Expanded(
                child: userArrangement.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 60,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Drag letters here!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
                    : AnimatedBuilder(
                  animation: _bounceController,
                  builder: (context, child) {
                    double offset = sin(_bounceController.value * pi * 2) * 10;
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: userArrangement.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String letter = entry.value;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            userArrangement.removeAt(idx);
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade400,
                                Colors.teal.shade500,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: userArrangement.length == letters.length ? _checkOrder : null,
              icon: const Icon(Icons.check_circle, size: 24),
              label: const Text(
                'Check Order',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: userArrangement.length == letters.length
                    ? Colors.white
                    : Colors.grey.shade400,
                foregroundColor: const Color(0xFF11998E),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: userArrangement.length == letters.length ? 10 : 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}