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
        duration: Duration(milliseconds: 600 + (index * 100)),
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final padding = size.width * 0.05;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
              SizedBox(height: size.height * 0.02),
              _buildHeader(context),
              SizedBox(height: size.height * 0.01),
              _buildSubtitle(context),
              SizedBox(height: size.height * 0.02),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(padding),
                  mainAxisSpacing: padding,
                  crossAxisSpacing: padding,
                  childAspectRatio: isSmallScreen ? 0.75 : 0.7,
                  physics: BouncingScrollPhysics(),
                  children: [
                    _buildGameCard(
                      context,
                      'Trace Letters',
                      Icons.draw,
                      [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
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
                      Icons.extension,
                      [Color(0xFF4CAF50), Color(0xFF81C784)],
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
                      Icons.sort_by_alpha,
                      [Color(0xFF2196F3), Color(0xFF64B5F6)],
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
                      Icons.menu_book,
                      [Color(0xFF9C27B0), Color(0xFFBA68C8)],
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

  Widget _buildHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isSmallScreen ? 45 : 55,
            height: isSmallScreen ? 45 : 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'LetterLoo',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Learn • Play • Grow',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.015,
      ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app,
            color: Color(0xFF6C63FF),
            size: isSmallScreen ? 18 : 22,
          ),
          SizedBox(width: size.width * 0.02),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Choose Your Activity',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(
      BuildContext context,
      String title,
      IconData icon,
      List<Color> colors,
      int index,
      VoidCallback onTap,
      ) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return ScaleTransition(
      scale: _animations[index],
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colors[0].withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: isSmallScreen ? 35 : 45,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                        vertical: size.height * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: isSmallScreen ? 14 : 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Play',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}