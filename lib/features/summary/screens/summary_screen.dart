import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fcs_flutter/common/widgets/stars.dart';
import 'package:fcs_flutter/common/widgets/styles/spacing_styles.dart';
import 'package:fcs_flutter/features/admin/admin_widgets/feedback_info.dart';
import 'package:fcs_flutter/features/summary/controllers/summary_controller.dart';
import 'package:fcs_flutter/features/summary/services/summary_service.dart';
import 'package:fcs_flutter/models/feedback.dart';
import 'package:fcs_flutter/providers/user_provider.dart';
import 'package:fcs_flutter/utils/constants/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FeedbackSummaryScreen extends StatefulWidget {
  static const String routeName = '/summary-screen';
  final TFeedback feedback;
  const FeedbackSummaryScreen({
    super.key,
    required this.feedback,
  });

  @override
  State<FeedbackSummaryScreen> createState() => _FeedbackSummaryScreenState();
}

class _FeedbackSummaryScreenState extends State<FeedbackSummaryScreen> {

  final commentsController = TextEditingController();
  List<File> images = [];
  final formKey = GlobalKey<FormState>();
  double userRating = 0;

  final SummaryService summaryService = SummaryService();

  void selectImage() async {
    images = await ImagePickerUtil.getImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(SummaryController());
    final bool isUser = Provider.of<UserProvider>(context, listen: false).user.role == 'user';

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Summary'),
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
                      FeedbackInfo(feedback: widget.feedback),
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
                      const SizedBox(height: 8.0),
                      if (widget.feedback.updateComment != '') ...[
                        const SizedBox(height: 16.0),
                        Divider(height: 2.0,),
                        const SizedBox(height: 16.0),
                        Text(
                          'Admin Response: ', 
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
                                widget.feedback.updateComment!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                      ],
                      if (widget.feedback.updateImages!.isNotEmpty) ...[
                        const SizedBox(height: 16.0),
                        Divider(height: 2.0,),
                        const SizedBox(height: 16.0),
                        Text(
                          'Attached Pictures: ', 
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.15,
                          )
                        ),
                        const SizedBox(height: 8.0),
                        CarouselSlider(
                          items: widget.feedback.updateImages!.map(
                            (i) {
                              return Builder(
                                builder: (BuildContext context) => Image.network(
                                  i, 
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              );
                            },
                          ).toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            onPageChanged: (index, _) => controller.updatePageIndicator(index),
                            height: 200,
                          )
                        ),
                        const SizedBox(height: 8.0),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(widget.feedback.updateImages!.length, (i) {
                              return Obx(() => Container(
                                    width: 20,
                                    height: 4,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: controller.carouselCurrentIndex.value == i
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ));
                            }),
                          ),
                        )
                      ],
                      if (widget.feedback.status == 'Resolved') ...[
                        const SizedBox(height: 16.0),
                        Divider(height: 2.0,),
                        const SizedBox(height: 16.0),
                        if (widget.feedback.userRating == 0.0) ... [
                          if (isUser) ... [
                            Text(
                              'How do you feel about it: ', 
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.15,
                              )
                            ),
                            
                            const SizedBox(height: 8.0),
                            Center(
                              child: RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  userRating = rating;
                                },
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  summaryService.rateFeedback(
                                    context: context, 
                                    feedbackId: widget.feedback.id!, 
                                    rating: userRating,
                                    onComplete: () {
                                      Navigator.pop(context);
                                    }
                                  );
                                }, 
                                child: const Text('Rate the response!'),
                              ),
                            ), 
                          ] else ... [
                            Center(
                              child: Text(
                                'User have not rated! ', 
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.15,
                                )
                              ),
                            ),  
                          ]
                        ] else ... [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                isUser ? 'Your rating: ' : 'User\'s rating: ', 
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.15,
                                )
                              ),                          
                              const SizedBox(height: 8.0),
                              Stars(rating: widget.feedback.userRating!),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

