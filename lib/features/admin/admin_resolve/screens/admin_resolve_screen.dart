import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:fcs_flutter/common/widgets/custom_textfield.dart';
import 'package:fcs_flutter/common/widgets/styles/spacing_styles.dart';
import 'package:fcs_flutter/features/admin/admin_resolve/services/resolve_service.dart';
import 'package:fcs_flutter/features/admin/admin_widgets/feedback_info.dart';
import 'package:fcs_flutter/models/feedback.dart';
import 'package:fcs_flutter/providers/feedback_provider.dart';
import 'package:fcs_flutter/utils/constants/pick_image.dart';
import 'package:fcs_flutter/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AdminResolveScreen extends StatefulWidget {
  static const String routeName = '/admin-resolve-screen';
  final TFeedback feedback;
  const AdminResolveScreen({
    super.key,
    required this.feedback,
  });

  @override
  State<AdminResolveScreen> createState() => _AdminResolveScreenState();
}

class _AdminResolveScreenState extends State<AdminResolveScreen> {

  final ResolveService resolveService = ResolveService();

  final TextEditingController commentsController = TextEditingController();
  List<File> images = [];
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void selectImage() async {
    images = await ImagePickerUtil.getImages();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    commentsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedback = Provider.of<FeedbackListProvider>(context).getFeedbackById(widget.feedback.id!) ?? widget.feedback;
    return Scaffold(
      appBar: AppBar(
        title: Text('Resolve Feedback'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              Card(
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FeedbackInfo(
                        feedback: feedback
                      ),
                      const SizedBox(height: 8.0),
                      Divider(height: 2.0,),
                      const SizedBox(height: 8.0),
                      Text(
                        'Feedback: ', 
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.15,
                        )
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade100,
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.feedback.message,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      if (feedback.status == 'In Progress') ...[
                        Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: TSizes.spaceBtwSections - 10.0),
                              Divider(height: 2.0,),
                              const SizedBox(height: 12.0),
                               Text(
                                'Update feedback: ', 
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.15,
                                )
                              ),
                              const SizedBox(height: 4.0),
                              Text('Comment on feedback'),   
                              const SizedBox(height: 8.0),
                              CustomTextfield(
                                controller: commentsController, 
                                hintText: 'Comments',
                                maxLines: 10,
                              ),
                              const SizedBox(height: 12.0),
                              Text('Attach relevant pictures'),  
                              images.isNotEmpty ?
                                GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: images.length + 1,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), 
                                  itemBuilder: (BuildContext context, int index) {
                                    if (index == images.length) {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              List<File> newImages = await ImagePickerUtil.getImages();
                                              images.addAll(newImages);
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Container(
                                                height: 75,
                                                width: 75,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.black),
                                                ),
                                                child: const Icon(
                                                  CupertinoIcons.add,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.only(
                                              top: 10.0,
                                              right: 10.0,                         
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.file(
                                                images[index],
                                                height: 75,
                                                width: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(right: 2,
                                            top: 3,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  images.removeAt(index);
                                                });
                                              },
                                              child: Icon(
                                                CupertinoIcons.clear_circled,
                                                color: Colors.red.shade400,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                )
                                : GestureDetector(
                                onTap: () {
                                  selectImage();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: TSizes.spaceBtwSections,
                                    top: TSizes.spaceBtwItems - 4,
                                  ),
                                  child: DottedBorder(
                                    options: RoundedRectDottedBorderOptions(radius: Radius.circular(10), dashPattern: [10, 4],strokeCap: StrokeCap.round),
                                    child: SizedBox(
                                      height: 100,
                                      width: double.infinity,
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.folder_open,
                                            size: 40,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Upload Photos',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              feedback.status == 'Waiting to resolve'
              ? SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      resolveService.startResolve(context: context, feedback: widget.feedback);
                      setState(() {});
                    }, 
                    child: const Text('Start Resolve')
                  ),
                )
              : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      resolveService.finishResolve(
                        context: context, 
                        feedbackId: widget.feedback.id!, 
                        userId: widget.feedback.userId, 
                        comment: commentsController.text, 
                        images: images,
                        onComplete: () {
                          if (!mounted) return;
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        }
                      );
                    }
                  }, 
                  child: isLoading 
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Processing...'),
                      ],
                    )
                  : const Text('Finish Resolve'),
                ),
              ), 
            ],
          ),
        ),
      ),
    );
  }
}