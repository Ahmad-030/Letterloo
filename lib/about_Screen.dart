import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'LetterLoo',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Fun Learning for Young Minds',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C63FF),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'LetterLoo is an interactive educational application designed to help children aged 3-6 learn the alphabet through engaging games and activities. Our mission is to make early learning fun, accessible, and effective.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 20),
                        _buildFeatureSection(),
                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 20),
                        _buildContactSection(context),
                        const SizedBox(height: 30),
                        _buildDeveloperInfo(),
                        const SizedBox(height: 20),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
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
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'ℹ️ About',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C63FF),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildFeatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
        const SizedBox(height: 15),
        _buildFeatureItem(
          Icons.draw,
          'Letter Tracing',
          'Practice writing letters with guided tracing',
          Color(0xFFFF6B6B),
        ),
        _buildFeatureItem(
          Icons.extension,
          'Matching Game',
          'Match letters with corresponding objects',
          Color(0xFF4CAF50),
        ),
        _buildFeatureItem(
          Icons.sort_by_alpha,
          'Sorting Challenge',
          'Arrange letters in alphabetical order',
          Color(0xFF2196F3),
        ),
        _buildFeatureItem(
          Icons.menu_book,
          'ABC Storybook',
          'Learn letters through interactive stories',
          Color(0xFF9C27B0),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Contact & Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6C63FF).withOpacity(0.1),
                const Color(0xFF764ba2).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF6C63FF).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.email_outlined,
                size: 40,
                color: Color(0xFF6C63FF),
              ),
              const SizedBox(height: 12),
              const Text(
                'We\'d love to hear from you!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6C63FF),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'For support, feedback, or inquiries:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [

                    Icon(Icons.mail, color: Colors.white, size: 15),
                    SizedBox(width: 10),
                    Text(
                      'Matthewstewartok22@gmail.com',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.code, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                'Developed with ❤️',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '© 2025 LetterLoo. All rights reserved.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Made for young learners everywhere',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}