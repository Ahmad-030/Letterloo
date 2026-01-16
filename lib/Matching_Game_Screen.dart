import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    'I': ['🍦 Ice Cream', '🏝️ Island', '💡 Idea', '🦎 Iguana'],
    'J': ['🕹️ Joystick', '🧃 Juice', '🤹 Juggle', '🃏 Joker'],
    'K': ['🔑 Key', '🦘 Kangaroo', '🪁 Kite', '👑 King'],
    'L': ['🦁 Lion', '🍋 Lemon', '🔒 Lock', '💡 Lamp'],
    'M': ['🐵 Monkey', '🌙 Moon', '🍄 Mushroom', '🎵 Music'],
    'N': ['🪺 Nest', '🔔 Notification', '📰 Newspaper', '🥜 Nut'],
    'O': ['🐙 Octopus', '🍊 Orange', '🦉 Owl', '🌊 Ocean'],
    'P': ['🐧 Penguin', '🍕 Pizza', '🎹 Piano', '🥞 Pancake'],
    'Q': ['👸 Queen', '❓ Question', '🔕 Quiet', '🪙 Quarter'],
    'R': ['🌈 Rainbow', '🐇 Rabbit', '🚀 Rocket', '🤖 Robot'],
    'S': ['⭐ Star', '🐍 Snake', '☀️ Sun', '🦈 Shark'],
    'T': ['🐢 Turtle', '🎺 Trumpet', '🌮 Taco', '🎾 Tennis'],
    'U': ['☂️ Umbrella', '🦄 Unicorn', '⬆️ Up', '🔓 Unlock'],
    'V': ['🌋 Volcano', '🎻 Violin', '🎮 Video', '🚐 Van'],
    'W': ['🐋 Whale', '🍉 Watermelon', '⌚ Watch', '🌊 Wave'],
    'X': ['🎸 Xylophone', '❌ X-mark', '📦 Xbox', '🩻 X-ray'],
    'Y': ['🧶 Yarn', '🍋 Yellow', '⚡ Yell', '🧘 Yoga'],
    'Z': ['🦓 Zebra', '⚡ Zap', '🤐 Zipper', '0️⃣ Zero'],
  };

  // Level configurations - 20 unique levels
  final List<Map<String, dynamic>> levelConfigs = [
    {'pairs': 3, 'letters': ['A', 'B', 'C']},
    {'pairs': 3, 'letters': ['D', 'E', 'F']},
    {'pairs': 4, 'letters': ['G', 'H', 'I', 'J']},
    {'pairs': 4, 'letters': ['K', 'L', 'M', 'N']},
    {'pairs': 4, 'letters': ['O', 'P', 'Q', 'R']},
    {'pairs': 5, 'letters': ['S', 'T', 'U', 'V', 'W']},
    {'pairs': 5, 'letters': ['A', 'E', 'I', 'O', 'U']},
    {'pairs': 5, 'letters': ['B', 'C', 'D', 'F', 'G']},
    {'pairs': 6, 'letters': ['H', 'J', 'K', 'L', 'M', 'N']},
    {'pairs': 6, 'letters': ['P', 'Q', 'R', 'S', 'T', 'U']},
    {'pairs': 6, 'letters': ['A', 'B', 'C', 'D', 'E', 'F']},
    {'pairs': 5, 'letters': ['V', 'W', 'X', 'Y', 'Z']},
    {'pairs': 6, 'letters': ['G', 'H', 'I', 'J', 'K', 'L']},
    {'pairs': 6, 'letters': ['M', 'N', 'O', 'P', 'Q', 'R']},
    {'pairs': 6, 'letters': ['S', 'T', 'U', 'V', 'W', 'X']},
    {'pairs': 5, 'letters': ['A', 'C', 'E', 'G', 'I']},
    {'pairs': 5, 'letters': ['B', 'D', 'F', 'H', 'J']},
    {'pairs': 6, 'letters': ['K', 'M', 'O', 'Q', 'S', 'U']},
    {'pairs': 6, 'letters': ['L', 'N', 'P', 'R', 'T', 'V']},
    {'pairs': 6, 'letters': ['W', 'X', 'Y', 'Z', 'A', 'B']},
  ];

  late List<String> currentLetters;
  late List<String> currentObjects;
  String? selectedLetter;
  String? selectedObject;
  Set<String> matchedPairs = {};
  int score = 0;
  int currentLevel = 1; // Current level (1-20)
  late AnimationController _shakeController;
  late AnimationController _successController;
  late AnimationController _pulseController;
  late AnimationController _dialogController;
  bool showingFeedback = false;
  bool isMuted = false;
  bool isLoading = true;
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
    _dialogController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentLevel = prefs.getInt('matching_game_level') ?? 1;
      score = prefs.getInt('matching_game_score') ?? 0;
      isMuted = prefs.getBool('matching_game_muted') ?? false;
      isLoading = false;
    });
    _initializeGame();
  }

  Future<void> _saveProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('matching_game_level', currentLevel);
    await prefs.setInt('matching_game_score', score);
    await prefs.setBool('matching_game_muted', isMuted);
  }

  Future<void> _resetProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('matching_game_level', 1);
    await prefs.setInt('matching_game_score', 0);
    setState(() {
      currentLevel = 1;
      score = 0;
      matchedPairs.clear();
      selectedLetter = null;
      selectedObject = null;
    });
    _initializeGame();
  }

  void _initializeGame() {
    // Ensure level is within bounds
    if (currentLevel > levelConfigs.length) {
      currentLevel = 1;
      _resetProgress();
    }

    // Load level configuration
    Map<String, dynamic> levelConfig = levelConfigs[currentLevel - 1];
    List<String> levelLetters = List<String>.from(levelConfig['letters']);
    levelLetters.shuffle();

    currentLetters = levelLetters;
    currentObjects = currentLetters.map((letter) {
      List<String> objects = letterObjects[letter] ?? ['❓ Unknown'];
      return objects[Random().nextInt(objects.length)];
    }).toList()..shuffle();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _successController.dispose();
    _pulseController.dispose();
    _dialogController.dispose();
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667EEA),
                      Color(0xFF764BA2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '⚙️',
                      style: TextStyle(fontSize: 60),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Sound Toggle
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isMuted ? Icons.volume_off : Icons.volume_up,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Sound',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: !isMuted,
                            onChanged: (value) {
                              setState(() {
                                isMuted = !value;
                              });
                              setDialogState(() {});
                              _saveProgress();
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.shade200,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Start from Level 1
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _resetProgress();
                      },
                      icon: const Icon(Icons.first_page, color: Color(0xFF667EEA)),
                      label: const Text(
                        'Start from Level 1',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF667EEA),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Close Button
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
        score += 10 * currentLevel;
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
    _dialogController.forward(from: 0);

    // Check if all levels are completed
    bool allLevelsCompleted = currentLevel >= levelConfigs.length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ScaleTransition(
        scale: CurvedAnimation(
          parent: _dialogController,
          curve: Curves.elasticOut,
        ),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: allLevelsCompleted
                    ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
                    : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    allLevelsCompleted ? '🏆' : '🎉',
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  allLevelsCompleted
                      ? 'All Levels Complete!'
                      : 'Level $currentLevel Complete!',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    allLevelsCompleted
                        ? 'Amazing! You completed all 20 levels! 🌟'
                        : 'Excellent Work! 🌟',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        allLevelsCompleted ? '🏆🏆🏆' : '⭐⭐⭐',
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDialogStat(
                              'Level',
                              '$currentLevel',
                              const Color(0xFF667EEA)
                          ),
                          Container(
                            width: 2,
                            height: 50,
                            color: Colors.grey.shade300,
                          ),
                          _buildDialogStat('Score', '$score', Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.home, size: 22),
                        label: const Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: allLevelsCompleted
                              ? const Color(0xFFFFA500)
                              : const Color(0xFF667EEA),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            if (allLevelsCompleted) {
                              // Reset to level 1 and start over
                              currentLevel = 1;
                              _resetProgress();
                            } else {
                              // Move to next level
                              currentLevel++;
                              _saveProgress();
                            }
                            matchedPairs.clear();
                            selectedLetter = null;
                            selectedObject = null;
                            _initializeGame();
                          });
                        },
                        icon: Icon(
                            allLevelsCompleted ? Icons.replay : Icons.arrow_forward,
                            size: 22
                        ),
                        label: Text(
                          allLevelsCompleted ? 'Restart' : 'Next',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: allLevelsCompleted
                              ? Colors.purpleAccent.shade400
                              : Colors.greenAccent.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          shadowColor: allLevelsCompleted
                              ? Colors.purpleAccent.withOpacity(0.5)
                              : Colors.greenAccent.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

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
              onPressed: () {
                _saveProgress();
                Navigator.pop(context);
              },
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
              icon: const Icon(
                Icons.pause_circle,
                color: Colors.white,
                size: 24,
              ),
              onPressed: _showSettingsDialog,
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
          _buildScoreItem('🏆 Level', '$currentLevel'),
          Container(width: 2, height: 30, color: Colors.grey.shade300),
          _buildScoreItem('⭐ Score', '$score'),
          Container(width: 2, height: 30, color: Colors.grey.shade300),
          _buildScoreItem('✅ Matched', '${matchedPairs.length ~/ 2}/${currentLetters.length}'),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value) {
    return Flexible(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF667EEA),
              ),
            ),
          ),
        ],
      ),
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