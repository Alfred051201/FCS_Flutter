import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fcs_flutter/common/widgets/custom_textfield.dart';
import 'package:fcs_flutter/features/auth/services/auth_service.dart';
import 'package:fcs_flutter/features/form/services/form_service.dart';
import 'package:fcs_flutter/providers/user_provider.dart';
import 'package:fcs_flutter/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  final _feedbackFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final FormService formService = FormService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String? selectedCategory;

  Location _locationController = new Location();

  static const LatLng _pGooglePlex = LatLng(37.7749, -122.4194);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0890);
  LatLng? _currentP = null;

  final List<String> categories = ['Bug Report', 'Feature Request', 'General Inquiry'];

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
  } 

  void submitFeedback() {
    formService.submitFeedback(
      context: context, 
      name: _nameController.text,
      email: _emailController.text,
      category: selectedCategory!,
      message: _messageController.text,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      _nameController.text = user.username;
      _emailController.text = user.email;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('Contact Us', style: Theme.of(context).textTheme.headlineLarge,),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Text('Fill up the form and our team will get back to you as soon as possible', 
                        style: Theme.of(context).textTheme.labelMedium
                      ),
                    ],
                  ),
                            
                  const SizedBox(height: TSizes.spaceBtwSections),
                            
                  Form(
                    key: _feedbackFormKey,
                    child: Column(
                      children: [
                        CustomTextfield(
                          controller: _nameController, 
                          hintText: 'Name',
                          // preIcon: Icon(Iconsax.direct_right),
                        ),
  
                        const SizedBox(height: TSizes.spaceBtwSections),
                        CustomTextfield(
                          controller: _emailController, 
                          hintText: 'Email',
                        ),

                        const SizedBox(height: TSizes.spaceBtwSections),

                        DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          hint: const Text('Select category', style: TextStyle(fontSize: 14)),
                          items: categories.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(), 
                          validator: (value) => value == null ? 'Please select a category' : null,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                          onSaved: (value) {
                            selectedCategory = value;
                          },
                          iconStyleData: const IconStyleData(
                            icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                            iconSize: 24
                          ),
                        ),
                        // DropdownMenu(
                        //   label: const Text("Category"),
                        //   width: 300.0,
                        //   helperText: 'Choose your feedback category',
                        //   onSelected: (String value) {
                        //     _categoryController.text = value;
                        //   },
                        //   dropdownMenuEntries: <DropdownMenuEntry<String>>[
                        //     DropdownMenuEntry(value: "Category", label: 'Category')
                        //   ],
                        // ),
                        
                        const SizedBox(height: TSizes.spaceBtwSections),
                        CustomTextfield(
                          controller: _messageController, 
                          hintText: 'Message',
                          maxLines: 10,
                        ),
                        
                        const SizedBox(height: TSizes.spaceBtwSections),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_feedbackFormKey.currentState!.validate()) {
                                submitFeedback();
                              }
                            }, 
                            child: const Text('Send your feedback')
                          ),
                        ),   

                        const SizedBox(height: TSizes.spaceBtwSections),
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _pGooglePlex, 
                              zoom: 13,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId("_currentLocation"),
                                icon: BitmapDescriptor.defaultMarker, 
                                position: _pGooglePlex
                              ),
                              Marker(
                                markerId: MarkerId("_sourceLocation"),
                                icon: BitmapDescriptor.defaultMarker, 
                                position: _pApplePark
                              ),
                            },
                          )
                          ,
                        )
                      ],
                    )
                  ),
                            
                  const SizedBox(height: TSizes.spaceBtwSections),
                            
                ],
              ),
            ),
          ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return ;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        print(_currentP);
      }
    }); 
  }
}