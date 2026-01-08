import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> pages = [
    {'letter': 'A', 'emoji': '🍎', 'name': 'Apple', 'story': 'Annie the ant found a big red apple under the apple tree!'},
    {'letter': 'B', 'emoji': '🦋', 'name': 'Butterfly', 'story': 'Bella the butterfly dances beautifully in the bright blue sky!'},
    {'letter': 'C', 'emoji': '🐱', 'name': 'Cat', 'story': 'Charlie the cat loves to chase colorful balls and cuddle!'},
    {'letter': 'D', 'emoji': '🦕', 'name': 'Dinosaur', 'story': 'Danny the dinosaur discovers delicious berries in the jungle!'},
    {'letter': 'E', 'emoji': '🐘', 'name': 'Elephant', 'story': 'Emma the elephant enjoys eating fresh leaves every day!'},
    {'letter': 'F', 'emoji': '🦊', 'name': 'Fox', 'story': 'Freddy the fox finds friends in the fantastic forest!'},
    {'letter': 'G', 'emoji': '🦒', 'name': 'Giraffe', 'story': 'Gina the giraffe gracefully reaches the tallest trees!'},
    {'letter': 'H', 'emoji': '🐴', 'name': 'Horse', 'story': 'Harry the horse happily gallops through the green hills!'},
    {'letter': 'I', 'emoji': '🍦', 'name': 'Ice Cream', 'story': 'Izzy loves incredible ice cream on hot summer days!'},
    {'letter': 'J', 'emoji': '🤹', 'name': 'Juggler', 'story': 'Joey the juggler juggles joyfully at the big circus!'},
    {'letter': 'K', 'emoji': '🪁', 'name': 'Kite', 'story': 'Katie flies her colorful kite high in the sky!'},
    {'letter': 'L', 'emoji': '🦁', 'name': 'Lion', 'story': 'Leo the lion is the brave leader of the jungle!'},
    {'letter': 'M', 'emoji': '🐵', 'name': 'Monkey', 'story': 'Molly the monkey swings merrily from tree to tree!'},
    {'letter': 'N', 'emoji': '🌙', 'name': 'Night', 'story': 'The night sky is full of twinkling stars and the moon!'},
    {'letter': 'O', 'emoji': '🐙', 'name': 'Octopus', 'story': 'Oscar the octopus has eight amazing arms in the ocean!'},
    {'letter': 'P', 'emoji': '🐧', 'name': 'Penguin', 'story': 'Penny the penguin loves to play in the snowy ice!'},
    {'letter': 'Q', 'emoji': '👑', 'name': 'Queen', 'story': 'Queen Quincy wears a beautiful crown and rules kindly!'},
    {'letter': 'R', 'emoji': '🌈', 'name': 'Rainbow', 'story': 'After the rain, a beautiful rainbow appears in the sky!'},
    {'letter': 'S', 'emoji': '⭐', 'name': 'Star', 'story': 'Sally the star shines brightly in the night sky!'},
    {'letter': 'T', 'emoji': '🐢', 'name': 'Turtle', 'story': 'Tommy the turtle takes his time and wins the race!'},
    {'letter': 'U', 'emoji': '☂️', 'name': 'Umbrella', 'story': 'Umbrella keeps you dry when it rains outside!'},
    {'letter': 'V', 'emoji': '🎻', 'name': 'Violin', 'story': 'Vicky plays beautiful music on her shiny violin!'},
    {'letter': 'W', 'emoji': '🐋', 'name': 'Whale', 'story': 'Wally the whale swims gracefully in the deep blue ocean!'},
    {'letter': 'X', 'emoji': '🎸', 'name': 'Xylophone', 'story': 'The xylophone makes wonderful musical sounds!'},
    {'letter': 'Y', 'emoji': '🧶', 'name': 'Yarn', 'story': 'Grandma uses soft yarn to knit cozy sweaters!'},
    {'letter': 'Z', 'emoji': '🦓', 'name': 'Zebra', 'story': 'Zara the zebra has beautiful black and white stripes!'},
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
    _audioPlayer.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage < pages.length - 1) {
      setState(() {
        currentPage++;
        _pageController.forward(from: 0);
      });
      _playPageTurnSound();
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        _pageController.forward(from: 0);
      });
      _playPageTurnSound();
    }
  }

  void _playPageTurnSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/page_turn.mp3'));
    } catch (e) {
      // Sound file not found
    }
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
              Color(0xFFFF6B6B),
              Color(0xFFFF8E8E),
              Color(0xFFFFB4B4),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 15),
              _buildPageIndicator(),
              const SizedBox(height: 25),
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
              '📚 ABC Storybook',
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

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.menu_book, color: Color(0xFFFF6B6B), size: 20),
          const SizedBox(width: 10),
          Text(
            'Page ${currentPage + 1} of ${pages.length}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B6B),
            ),
          ),
        ],
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
          margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
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
                    scale: 1.0 + (math.sin(_sparkleController.value * 2 * math.pi) * 0.05),
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF6B6B).withOpacity(0.1),
                        const Color(0xFFFFB4B4).withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    page['letter']!,
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                page['emoji']!,
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 25),
              Text(
                page['name']!,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  page['story']!,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade800,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.swipe, color: Colors.grey, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Swipe to turn pages',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
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

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavButton(
            Icons.arrow_back,
            'Previous',
            currentPage > 0,
            _previousPage,
          ),
          _buildNavButton(
            Icons.arrow_forward,
            'Next',
            currentPage < pages.length - 1,
            _nextPage,
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
      ) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? Colors.white.withOpacity(0.3) : Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: enabled ? 8 : 2,
        ),
      ),
    );
  }
}