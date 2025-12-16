import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Smart Student Study Planner',
      'description': 'Your smart companion for academic success. Manage courses, tasks, and schedules all in one place.',
      'image': 'assets/images/onboarding_welcome.png' 
    },
    {
      'title': 'Organize Your Courses',
      'description': 'Keep all your courses organized with instructor details, course codes, and schedules in one central location.',
      'image': 'assets/images/onboarding_courses.png' 
    },
    {
      'title': 'Smart Task Management',
      'description': 'Create tasks with priority levels 1-10. Our intelligent system helps you focus on what matters most.',
      'image': 'assets/images/onboarding_tasks_v2.png' 
    },
    {
      'title': 'Interactive Calendar',
      'description': 'Visualize your schedule with month, week, and day views. Color-coded tasks make planning effortless.',
      'image': 'assets/images/onboarding_calendar_v2.png' 
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      child: Text('Skip', style: AppTextStyles.bodyMedium),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              // Image
                               Container(
                                constraints: BoxConstraints(
                                  maxHeight: constraints.maxHeight * 0.55, 
                                  minHeight: 250,
                                ),
                                child: Image.asset(
                                  _pages[index]['image']!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      color: Colors.grey[200],
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image, size: 80, color: Colors.grey),
                                          SizedBox(height: 8),
                                          Text("Image missing", style: TextStyle(color: Colors.grey)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 32),
                              Text(
                                _pages[index]['title']!,
                                style: AppTextStyles.heading2,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              Text(
                                _pages[index]['description']!,
                                style: AppTextStyles.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      SmoothPageIndicator(
                        controller: _controller,
                        count: _pages.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: AppColors.primary,
                          dotColor: AppColors.grey,
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 4,
                          spacing: 8,
                        ),
                      ),
                      SizedBox(height: 32),
                      CustomButton(
                        text: _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
                        onPressed: () {
                          if (_currentIndex == _pages.length - 1) {
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                          } else {
                            _controller.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
