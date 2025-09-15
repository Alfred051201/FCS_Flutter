import 'package:fcs_flutter/common/widgets/custom_textfield.dart';
import 'package:fcs_flutter/features/auth/screens/signup_screen.dart';
import 'package:fcs_flutter/features/auth/services/auth_service.dart';
import 'package:fcs_flutter/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  } 

  void signInUser() {
    authService.signInUser(
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
                    children: [Text('Sign In', style: Theme.of(context).textTheme.headlineLarge,)],
                  ),
            
                  const SizedBox(height: TSizes.spaceBtwSections),
            
                  Form(
                    key: _signInFormKey,
                    child: Column(
                      children: [
                        CustomTextfield(
                          controller: _usernameController, 
                          hintText: 'Username',
                          preIcon: Icon(Iconsax.direct_right),
                        ),

                        const SizedBox(height: TSizes.spaceBtwSections),
                        CustomTextfield(
                          controller: _emailController, 
                          hintText: 'Email',
                          preIcon: Icon(Iconsax.direct_right),
                        ),
  
                        const SizedBox(height: TSizes.spaceBtwSections),
                        CustomTextfield(
                          obscure: true,
                          controller: _passwordController, 
                          hintText: 'Password',
                          preIcon: Icon(Iconsax.password_check),
                          suffIcon: Icon(Iconsax.eye_slash),
                        ),

                        const SizedBox(height: TSizes.spaceBtwSections),

                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_signInFormKey.currentState!.validate()) {
                                signInUser();
                              }
                            }, 
                            child: const Text('Sign In')
                          ),
                        ),                   
                      ],
                    )
                  ),
            
                  const SizedBox(height: TSizes.spaceBtwSections),
            
                  Row(
                    children: [
                      Flexible(child: Divider(thickness: 1, indent: 50, color: Colors.grey.withValues(alpha: 0.3), endIndent: 10,)),
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context, 
                            SignupScreen.routeName, 
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Sign up here",
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