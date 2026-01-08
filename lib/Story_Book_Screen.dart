import 'package:flutter/material.dart';
import 'dart:math' as math;

class StorybookScreen extends StatefulWidget {
  const StorybookScreen({Key? key}) : super(key: key);

  @override
  State<StorybookScreen> createState() => _StorybookScreenState();
}

class _StorybookScreenState extends State<StorybookScreen> with TickerProviderStateMixin {
  int currentPage = 0;
  late AnimationController _pageController;
  late AnimationController _sparkleController;
  late Animation<double> _pageAnimation;

  final List<Map<String, String>> pages = [
    {'letter': 'A', 'emoji': '🍎', 'name': 'Apple', 'description': 'A is for Apple!\nCrunchy and sweet!'},
    {'letter': 'B', 'emoji': '🦇', 'name': 'Bat', 'description': 'B is for Bat!\nFlying in the night!'},
    {'letter': 'C', 'emoji': '🐱', 'name': 'Cat', 'description': 'C is for Cat!\nSoft and cuddly!'},
    {'letter': 'D', 'emoji': '🐕', 'name': 'Dog', 'description': 'D is for Dog!\nFriendly and playful!'},
    {'letter': 'E', 'emoji': '🐘', 'name': 'Elephant', 'description': 'E is for Elephant!\nBig and strong!'},
    {'letter': 'F', 'emoji': '🐸', 'name': 'Frog', 'description': 'F is for Frog!\nJumping and hopping!'},
    {'letter': 'G', 'emoji': '🦒', 'name': 'Giraffe', 'description': 'G is for Giraffe!\nTall and graceful!'},
    {'letter': 'H', 'emoji': '🐴', 'name': 'Horse', 'description': 'H is for Horse!\nFast and beautiful!'},
    {'letter': 'I', 'emoji': '🍦', 'name': 'Ice Cream', 'description': 'I is for Ice Cream!\nCold and yummy!'},
    {'letter': 'J', 'emoji': '🕹️', 'name': 'Joystick', 'description': 'J is for Joystick!\nFun to play with!'},
    {'letter': 'K', 'emoji': '🔑', 'name': 'Key', 'description': 'K is for Key!\nUnlocks doors!'},
    {'letter': 'L', 'emoji': '🦁', 'name': 'Lion', 'description': 'L is for Lion!\nKing of the jungle!'},
    {'letter': 'M', 'emoji': '🌙', 'name': 'Moon', 'description': 'M is for Moon!\nShines at night!'},
    {'letter': 'N', 'emoji': '🪺', 'name': 'Nest', 'description': 'N is for Nest!\nBird\'s cozy home!'},
    {'letter': 'O', 'emoji': '🐙', 'name': 'Octopus', 'description': 'O is for Octopus!\nEight long arms!'},
    {'letter': 'P', 'emoji': '🐧', 'name': 'Penguin', 'description': 'P is for Penguin!\nLoves to swim!'},
    {'letter': 'Q', 'emoji': '👑', 'name': 'Queen', 'description': 'Q is for Queen!\nWears a crown!'},
    {'letter': 'R', 'emoji': '🌈', 'name': 'Rainbow', 'description': 'R is for Rainbow!\nColorful and bright!'},
    {'letter': 'S', 'emoji': '⭐', 'name': 'Star', 'description': 'S is for Star!\nTwinkles above!'},
    {'letter': 'T', 'emoji': '🐢', 'name': 'Turtle', 'description': 'T is for Turtle!\nSlow and steady!'},
    {'letter': 'U', 'emoji': '☂️', 'name': 'Umbrella', 'description': 'U is for Umbrella!\nKeeps you dry!'},
    {'letter': 'V', 'emoji': '🌋', 'name': 'Volcano', 'description': 'V is for Volcano!\nHot and fiery!'},
    {'letter': 'W', 'emoji': '🐋', 'name': 'Whale', 'description': 'W is for Whale!\nLives in the ocean!'},
    {'letter': 'X', 'emoji': '🎸', 'name': 'Xylophone', 'description': 'X is for Xylophone!\nMakes music!'},
    {'letter': 'Y', 'emoji': '🧶', 'name': 'Yarn', 'description': 'Y is for Yarn!\nSoft and fuzzy!'},
    {'letter': 'Z', 'emoji': '🦓', 'name': 'Zebra', 'description': 'Z is for Zebra!\nBlack and white stripes!'},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pageAnimation = CurvedAnimation(
      parent: _pageController,
      curve: Curves.easeInOut,
    );

    _pageController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage < pages.length - 1) {
      setState(() {
        currentPage++;
        _pageController.forward(from: 0);
      });
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        _pageController.forward(from: 0);
      });
    }
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
              Colors.purple.shade200,
              Colors.pink.shade200,
              Colors.orange.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              _buildPageIndicator(),
              const SizedBox(height: 20),
              Expanded(
                child: _buildStoryPage(),
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
              '📚 ABC Storybook',
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

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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
      child: Text(
        'Page ${currentPage + 1} of ${pages.length}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildStoryPage() {
    Map<String, String> page = pages[currentPage];

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _nextPage();
        } else if (details.primaryVelocity! > 0) {
          _previousPage();
        }
      },
      child: AnimatedBuilder(
        animation: _pageAnimation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_pageAnimation.value * math.pi / 12),
            alignment: Alignment.center,
            child: Opacity(
              opacity: _pageAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _sparkleController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (math.sin(_sparkleController.value * 2 * math.pi) * 0.1),
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.purple.shade100,
                        Colors.pink.shade100,
                        Colors.orange.shade100,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Text(
                    page['letter']!,
                    style: const TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                page['emoji']!,
                style: const TextStyle(fontSize: 100),
              ),
              const SizedBox(height: 30),
              Text(
                page['name']!,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  page['description']!,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '⬅️ Swipe to turn pages ➡️',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavButton(
            Icons.arrow_back,
            'Previous',
            currentPage > 0,
            _previousPage,
            Colors.blue,
          ),
          _buildNavButton(
            Icons.arrow_forward,
            'Next',
            currentPage < pages.length - 1,
            _nextPage,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
      IconData icon,
      String text,
      bool enabled,
      VoidCallback onPressed,
      Color color,
      ) {
    return ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? color : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 10,
      ),
    );
  }
}