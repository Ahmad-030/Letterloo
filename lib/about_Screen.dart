import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade300,
              Colors.blue.shade200,
              Colors.lightBlue.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'About Us',
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
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '🎨',
                              style: TextStyle(fontSize: 80),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'ABC Fun Learning',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const Divider(height: 40, thickness: 2),
                            _buildInfoSection(
                              '🎯 Our Mission',
                              'To make learning fun and engaging for kids aged 3-6 years through interactive games and activities.',
                            ),
                            const SizedBox(height: 20),
                            _buildInfoSection(
                              '✨ Features',
                              '• Letter Tracing with visual feedback\n'
                                  '• Matching Games for recognition\n'
                                  '• Sorting Games for alphabetical order\n'
                                  '• Interactive Storybook with animals',
                            ),
                            const SizedBox(height: 20),
                            _buildInfoSection(
                              '👶 Target Audience',
                              'Designed specifically for preschool children (ages 3-6) to develop:\n'
                                  '• Letter recognition\n'
                                  '• Fine motor skills\n'
                                  '• Hand-eye coordination\n'
                                  '• Alphabetical order understanding',
                            ),
                            const SizedBox(height: 20),
                            _buildInfoSection(
                              '🌟 Learning Goals',
                              'Through play-based learning, children will:\n'
                                  '• Master all 26 letters (A-Z)\n'
                                  '• Associate letters with objects\n'
                                  '• Build confidence in early literacy\n'
                                  '• Enjoy the learning process',
                            ),
                            const Divider(height: 40, thickness: 2),
                            const Text(
                              '💝 Thank you for using\nABC Fun Learning!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Made with ❤️ for kids',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: const [
                            Text(
                              '📧 Contact & Support',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Email: support@abcfunlearning.com\n'
                                  'Website: www.abcfunlearning.com\n'
                                  'Privacy Policy: Available on website',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}