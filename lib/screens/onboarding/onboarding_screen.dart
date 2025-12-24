import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  // FIXED: Updated image paths to match your actual assets
  final List<Map<String, String>> _pages = [
    {
      'title': 'Smart Student Study Planner',
      'description': 'Your smart companion for academic success. Manage courses, tasks, and schedules all in one place.',
      'image': 'assets/images/front.png' // Matches your file
    },
    {
      'title': 'Organize Your Courses',
      'description': 'Keep all your courses organized with instructor details, course codes, and schedules in one central location.',
      'image': 'assets/images/second.png' // Matches your file
    },
    {
      'title': 'Smart Task Management',
      'description': 'Create tasks with priority levels 1-10. Our intelligent system helps you focus on what matters most.',
      'image': 'assets/images/third.png' // Matches your file
    },
    {
      'title': 'Interactive Calendar',
      'description': 'Visualize your schedule with month, week, and day views. Color-coded tasks make planning effortless.',
      'image': 'assets/images/fourth.png' // Matches your file
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
                      padding: EdgeInsets.only(right: 16.w, top: 8.h),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                        },
                        child: Text('Skip', style: AppTextStyles.bodyMedium.copyWith(fontSize: 14.sp)),
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
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20.h),
                                // Image Container with Error Handling
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: constraints.maxHeight * 0.55,
                                    minHeight: 250.h,
                                  ),
                                  child: Image.asset(
                                    _pages[index]['image']!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 200.h,
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.broken_image, size: 80.sp, color: Colors.grey),
                                            SizedBox(height: 8.h),
                                            Text(
                                              "Image not found:\n${_pages[index]['image']}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 32.h),
                                Text(
                                  _pages[index]['title']!,
                                  style: AppTextStyles.heading2.copyWith(fontSize: 24.sp),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  _pages[index]['description']!,
                                  style: AppTextStyles.bodyLarge.copyWith(fontSize: 16.sp),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      children: [
                        SmoothPageIndicator(
                          controller: _controller,
                          count: _pages.length,
                          effect: ExpandingDotsEffect(
                            activeDotColor: AppColors.primary,
                            dotColor: AppColors.grey,
                            dotHeight: 8.h,
                            dotWidth: 8.w,
                            expansionFactor: 4,
                            spacing: 8.w,
                          ),
                        ),
                        SizedBox(height: 32.h),
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