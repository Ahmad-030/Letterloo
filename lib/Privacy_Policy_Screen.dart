import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

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
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(25),
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color(0xFF6C63FF).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.shield_outlined,
                                  size: 60,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Last Updated: January 2024',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildSection(
                          '1. Introduction',
                          'ABC Fun Learning ("we", "our", or "us") is committed to protecting the privacy of children and their families. This Privacy Policy explains how we handle information in our mobile application designed for children aged 3-6 years.',
                        ),
                        _buildSection(
                          '2. Information We Collect',
                          'ABC Fun Learning is designed with privacy in mind:\n\n'
                              '• NO Personal Information: We do not collect any personal information such as names, email addresses, phone numbers, or photos.\n\n'
                              '• NO User Accounts: The app does not require user registration or login.\n\n'
                              '• Local Data Only: All game progress and settings are stored locally on your device and are never transmitted to external servers.\n\n'
                              '• NO Tracking: We do not track user behavior or usage patterns.',
                        ),
                        _buildSection(
                          '3. Data Storage',
                          'All data generated while using ABC Fun Learning is stored locally on your device:\n\n'
                              '• Game progress and scores\n'
                              '• User preferences and settings\n'
                              '• Completed activities\n\n'
                              'This data remains on your device and is never shared with us or any third parties.',
                        ),
                        _buildSection(
                          '4. Third-Party Services',
                          'ABC Fun Learning does not:\n\n'
                              '• Use third-party analytics services\n'
                              '• Display advertisements\n'
                              '• Integrate with social media platforms\n'
                              '• Connect to external servers\n'
                              '• Share data with any third parties',
                        ),
                        _buildSection(
                          '5. Internet Connection',
                          'ABC Fun Learning is fully functional offline and does not require an internet connection to operate. The app does not transmit any data over the internet.',
                        ),
                        _buildSection(
                          '6. Children\'s Privacy (COPPA Compliance)',
                          'We are committed to complying with the Children\'s Online Privacy Protection Act (COPPA). Our app:\n\n'
                              '• Does not collect personal information from children\n'
                              '• Does not enable children to publicly post or distribute personal information\n'
                              '• Does not entice children with games or contests that require disclosure of personal information',
                        ),
                        _buildSection(
                          '7. Parental Control',
                          'Since we do not collect any personal information, there is no need for parental consent or access to personal data. Parents have complete control over the app through device settings.',
                        ),
                        _buildSection(
                          '8. Data Security',
                          'All data is stored securely on your device using standard device security measures. We recommend:\n\n'
                              '• Keeping your device\'s operating system updated\n'
                              '• Using device lock features\n'
                              '• Being cautious with device permissions',
                        ),
                        _buildSection(
                          '9. Data Deletion',
                          'To delete all app data:\n\n'
                              '• Uninstall the ABC Fun Learning app from your device\n'
                              '• This will permanently remove all locally stored game progress and settings',
                        ),
                        _buildSection(
                          '10. Changes to Privacy Policy',
                          'We may update this Privacy Policy from time to time. Any changes will be reflected in the app and on our website. Continued use of the app after changes indicates acceptance of the updated policy.',
                        ),
                        _buildSection(
                          '11. App Permissions',
                          'ABC Fun Learning requests minimal permissions:\n\n'
                              '• Storage: To save game progress locally on your device\n\n'
                              'We do NOT request:\n'
                              '• Camera access\n'
                              '• Microphone access\n'
                              '• Location access\n'
                              '• Contact access\n'
                              '• Network/Internet access (optional for updates only)',
                        ),
                        _buildSection(
                          '12. International Users',
                          'ABC Fun Learning can be used worldwide. All data remains on the user\'s device regardless of location. No cross-border data transfers occur.',
                        ),
                        _buildSection(
                          '13. Contact Us',
                          'If you have questions or concerns about this Privacy Policy, please contact us:\n\n'
                              'Email: privacy@abcfunlearning.com\n'
                              'Website: www.abcfunlearning.com\n\n'
                              'We will respond to all inquiries within 48 hours.',
                        ),
                        SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C63FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.verified_user,
                                color: Color(0xFF4CAF50),
                                size: 40,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Privacy-First Design',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Your child\'s privacy and safety are our top priorities. ABC Fun Learning is designed to be completely safe, with zero data collection and no internet requirements.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
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
              '🔒 Privacy Policy',
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

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C63FF),
            ),
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}