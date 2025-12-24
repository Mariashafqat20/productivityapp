import 'dart:io'; // Import required for File type
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_textfield.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = userProvider.name;
    _emailController.text = userProvider.email;
  }

  // Function to show options
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: Text('Gallery', style: AppTextStyles.bodyMedium),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_camera, color: AppColors.primary),
              title: Text('Camera', style: AppTextStyles.bodyMedium),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to pick image
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        // Update provider with the new path
        Provider.of<UserProvider>(context, listen: false).updateProfile(
          profilePicPath: pickedFile.path,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  void _handleLogout() async {
    await Provider.of<UserProvider>(context, listen: false).signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textDark, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("My Profile", style: AppTextStyles.heading2.copyWith(fontSize: 20.sp)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.redAccent, size: 24.sp),
            onPressed: _handleLogout,
            tooltip: "Log Out",
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              // Determine which ImageProvider to use
              ImageProvider? imageProvider;
              if (userProvider.profilePicPath != null && userProvider.profilePicPath!.isNotEmpty) {
                // Use FileImage for locally picked files
                imageProvider = FileImage(File(userProvider.profilePicPath!));
              } else {
                // Fallback to AssetImage for the default placeholder
                imageProvider = AssetImage("assets/images/profile.jpg");
              }

              return Column(
                children: [
                  SizedBox(height: 20.h),
                  Center(
                    child: GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Stack(
                        children: [
                          Container(
                            width: 120.w,
                            height: 120.w, // Keep it square/circle
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                              border: Border.all(color: AppColors.primary, width: 3.w),
                              image: DecorationImage(
                                // FIX: Use the correctly determined provider
                                image: imageProvider,
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {
                                  // Fallback if FileImage fails to load
                                  print("Error loading image: $exception");
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.w),
                              ),
                              child: Icon(Icons.camera_alt, color: Colors.white, size: 20.sp),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),

                  Align(alignment: Alignment.centerLeft, child: Text("Full Name", style: AppTextStyles.bodyMedium.copyWith(fontSize: 14.sp))),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    hintText: "Enter your name",
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                  ),
                  SizedBox(height: 24.h),

                  Align(alignment: Alignment.centerLeft, child: Text("Email Address", style: AppTextStyles.bodyMedium.copyWith(fontSize: 14.sp))),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    hintText: "Enter your email",
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    readOnly: true,
                  ),

                  SizedBox(height: 48.h),

                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        userProvider.updateProfile(
                          name: _nameController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully!")));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                        elevation: 0,
                      ),
                      child: Text("Save Changes", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  TextButton.icon(
                    onPressed: _handleLogout,
                    icon: Icon(Icons.exit_to_app, color: Colors.redAccent, size: 20.sp),
                    label: Text("Log Out", style: TextStyle(color: Colors.redAccent, fontSize: 16.sp)),
                  )
                ],
              );
            }
        ),
      ),
    );
  }
}