import 'package:flutter/material.dart';
import 'Matching_Game_Screen.dart';
import 'Sorting_Game_Screen.dart';
import 'Story_Book_Screen.dart';
import 'letter_tracing_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      4,
          (index) => AnimationController(
        duration: Duration(milliseconds: 500 + (index * 100)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    }).toList();

    for (var controller in _controllers) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
              Colors.blue.shade200,
              Colors.purple.shade200,
              Colors.pink.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  '🎓 ABC Fun Learning 🎓',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center, // FIXED: Added text alignment
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Choose an activity!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(20),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildGameCard(
                      context,
                      'Trace Letters',
                      '✏️',
                      Colors.orange,
                      Colors.deepOrange,
                      0,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LetterTracingScreen(),
                        ),
                      ),
                    ),
                    _buildGameCard(
                      context,
                      'Matching Game',
                      '🎯',
                      Colors.green,
                      Colors.lightGreen,
                      1,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MatchingGameScreen(),
                        ),
                      ),
                    ),
                    _buildGameCard(
                      context,
                      'Sorting Game',
                      '🔤',
                      Colors.blue,
                      Colors.lightBlue,
                      2,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SortingGameScreen(),
                        ),
                      ),
                    ),
                    _buildGameCard(
                      context,
                      'Storybook',
                      '📚',
                      Colors.purple,
                      Colors.purpleAccent,
                      3,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StorybookScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(
      BuildContext context,
      String title,
      String emoji,
      Color color1,
      Color color2,
      int index,
      VoidCallback onTap,
      ) {
    return ScaleTransition(
      scale: _animations[index],
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color1, color2],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: color1.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 3,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding( // FIXED: Use Padding instead of fixed constraints
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible( // FIXED: Make emoji flexible
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Flexible( // FIXED: Make text flexible
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}