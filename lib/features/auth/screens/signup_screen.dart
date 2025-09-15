import 'package:fcs_flutter/common/widgets/custom_textfield.dart';
import 'package:fcs_flutter/features/auth/screens/login_screen.dart';
import 'package:fcs_flutter/features/auth/services/auth_service.dart';
import 'package:fcs_flutter/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup-screen';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _signUpFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPwController.dispose();
  } 

  void signUpUser() {
    authService.signUpUser(
      context: context, 
      username: _usernameController.text, 
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsetsGeometry.all(56.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [Text('Sign Up', style: Theme.of(context).textTheme.headlineLarge,)],
                  ),
                            
                  const SizedBox(height: TSizes.spaceBtwSections),
                            
                  Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        CustomTextfield(
                          controller: _usernameController, 
                          hintText: 'Username',
                          preIcon: Icon(Iconsax.direct_right),
                        ),

                        const SizedBox(height: TSizes.spaceBtwSections),
                        TextFormField(
                          controller: _emailController,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Iconsax.direct_right),
                            labelText: 'Email',
                            alignLabelWithHint: true,
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter your email';
                            }
                            return null;
                          },
                          maxLines: 1,
                        ),
  
                        const SizedBox(height: TSizes.spaceBtwSections),
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Iconsax.direct_right),
                            labelText: 'Password',
                            suffixIcon: Icon(Iconsax.eye_slash),
                            alignLabelWithHint: true,
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter your password';
                            }
                            return null;
                          },
                          maxLines: 1,
                        ),

                        const SizedBox(height: TSizes.spaceBtwSections),
                        TextFormField(
                          obscureText: true,
                          controller: _confirmPwController,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(Iconsax.direct_right),
                            labelText: 'Confirm Password',
                            suffixIcon: Icon(Iconsax.eye_slash),
                            alignLabelWithHint: true,
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Confirm your password';
                            } else if (_confirmPwController.text != _passwordController.text) {
                              return 'Re-enter your password again';
                            }
                            return null;
                          },
                          maxLines: 1,
                        ),
                        
                        const SizedBox(height: TSizes.spaceBtwSections),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_signUpFormKey.currentState!.validate()) {
                                signUpUser();
                              }
                            }, 
                            child: const Text('Sign Up')
                          ),
                        ),                   
                      ],
                    )
                  ),
                            
                  const SizedBox(height: TSizes.spaceBtwSections),
                            
                  Row(
                    children: [
                      Flexible(child: Divider(thickness: 1, indent: 50, color: Colors.grey.withValues(alpha: 0.3), endIndent: 10,)),
                      Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context, 
                            LoginScreen.routeName, 
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Sign in here",
                          style: TextStyle(decoration: TextDecoration.underline),
                        )
                      ),
                      Flexible(child: Divider(thickness: 1, indent: 50, color: Colors.grey.withValues(alpha: 0.3), endIndent: 10,)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}