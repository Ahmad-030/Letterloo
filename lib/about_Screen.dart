import 'package:flutter/material.dart';
import 'Privacy_Policy_Screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildAppInfoCard(),
                      const SizedBox(height: 20),
                      _buildMissionCard(),
                      const SizedBox(height: 20),
                      _buildFeaturesCard(),
                      const SizedBox(height: 20),
                      _buildDevelopersCard(),
                      const SizedBox(height: 20),
                      _buildContactCard(),
                      const SizedBox(height: 30),
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
            offset: Offset(0, 5),
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
              'About Us',
              style: TextStyle(
                fontSize: 24,
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

  Widget _buildAppInfoCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667eea).withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.school,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'ABC Fun Learning',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C63FF),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6C63FF),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Empowering Young Minds Through Interactive Learning',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFF6B6B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.rocket_launch, color: Color(0xFFFF6B6B), size: 28),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  'Our Mission',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'We are dedicated to transforming early childhood education through innovative, engaging, and interactive learning experiences. Our mission is to make learning the alphabet fun and memorable for children aged 3-6 years, building a strong foundation for lifelong literacy and learning success.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.stars, color: Color(0xFF4CAF50), size: 28),
              ),
              SizedBox(width: 15),
              Text(
                'Key Features',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFeatureItem(
            Icons.draw,
            'Interactive Letter Tracing',
            'Advanced tracing system with real-time feedback and progress tracking',
          ),
          _buildFeatureItem(
            Icons.extension,
            'Engaging Matching Games',
            'Connect letters with objects to build strong letter-sound associations',
          ),
          _buildFeatureItem(
            Icons.sort_by_alpha,
            'Alphabetical Sorting',
            'Fun drag-and-drop activities to master letter sequences',
          ),
          _buildFeatureItem(
            Icons.menu_book,
            'Interactive Storybook',
            'Explore the alphabet through captivating animal adventure stories',
          ),
          _buildFeatureItem(
            Icons.child_care,
            'Child-Friendly Design',
            'Intuitive interface with colorful, age-appropriate visuals',
          ),
          _buildFeatureItem(
            Icons.offline_bolt,
            'Complete Offline Access',
            'Learn anywhere, anytime without internet connectivity',
          ),
          _buildFeatureItem(
            Icons.security,
            'Privacy-First Approach',
            'No data collection, no ads, completely safe for children',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Color(0xFF6C63FF), size: 20),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevelopersCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFF6B6B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.code, color: Color(0xFFFF6B6B), size: 28),
              ),
              SizedBox(width: 15),
              Text(
                'Development Team',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF6C63FF).withOpacity(0.2),
            child: Icon(Icons.person, size: 60, color: Color(0xFF6C63FF)),
          ),
          SizedBox(height: 15),
          Text(
            'Your Name',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C63FF),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Lead Developer & Designer',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Flutter & Mobile App Specialist',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          Divider(height: 30, thickness: 1),
          Text(
            'Passionate about creating educational technology that transforms learning into an engaging adventure. Committed to developing apps that make a positive impact on children\'s education worldwide.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.contact_support, color: Color(0xFF4CAF50), size: 28),
              ),
              SizedBox(width: 15),
              Text(
                'Contact & Support',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildContactItem(Icons.email, 'Email Support', 'support@abcfunlearning.com'),
          _buildContactItem(Icons.language, 'Website', 'www.abcfunlearning.com'),
          _buildContactItem(Icons.feedback, 'Feedback', 'feedback@abcfunlearning.com'),
          const SizedBox(height: 20),
          Divider(thickness: 1),
          const SizedBox(height: 15),
          Text(
            'Made with ❤️ for young learners everywhere',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6C63FF),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '© 2024 ABC Fun Learning. All rights reserved.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF6C63FF), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}