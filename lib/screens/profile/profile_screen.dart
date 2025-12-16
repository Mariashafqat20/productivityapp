import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = userProvider.name;
    _emailController.text = userProvider.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("My Profile", style: AppTextStyles.heading2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: AssetImage("assets/images/profile.jpg"), // Fallback/Placeholder
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: AppColors.primary, width: 3),
                    ),
                    child: Icon(Icons.person, size: 60, color: Colors.grey[400]), // If image fails
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 40),
            
            Align(alignment: Alignment.centerLeft, child: Text("Full Name", style: AppTextStyles.bodyMedium)),
            SizedBox(height: 8),
            CustomTextField(
              hintText: "Enter your name",
              controller: _nameController,
              prefixIcon: Icons.person_outline,
            ),
            SizedBox(height: 24),
            
            Align(alignment: Alignment.centerLeft, child: Text("Email Address", style: AppTextStyles.bodyMedium)),
            SizedBox(height: 8),
            CustomTextField(
              hintText: "Enter your email",
              controller: _emailController,
              prefixIcon: Icons.email_outlined,
            ),
            
            SizedBox(height: 48),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                    Provider.of<UserProvider>(context, listen: false).updateProfile(
                      name: _nameController.text,
                      email: _emailController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully!")));
                    Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
