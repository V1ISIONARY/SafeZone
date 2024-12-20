import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/widgets/custom_button.dart';
import 'package:safezone/frontend/widgets/report-danger-zone/multiple_images.dart';
import 'package:safezone/frontend/widgets/text_field_widget.dart';

class CreateReport extends StatefulWidget {
  const CreateReport({super.key});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  List<File> selectedImages = [];
  @override
  Widget build(BuildContext context) {
    final TextEditingController _descriptionController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report an Incident"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Image.asset(
                      "lib/resources/svg/alert.png",
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Help others stay safe by providing details about the incident and location.',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Pin the location of the incident")),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 215,
                width: 350,
                color: const Color.fromARGB(54, 96, 125, 139),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldWidget.buildTextField(
                  controller: _descriptionController,
                  label: "Description",
                  hint: "Enter description",
                  maxLines: 5,
                  minLines: 5),
              const SizedBox(
                height: 30,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Upload images to provide more context about the incident (optional)")),
              const SizedBox(
                height: 10,
              ),
              MultipleImages(
                onImagesSelected: (images) {
                  setState(() {
                    selectedImages = images;
                  });
                },
              ),
              CustomButton(
                text: "Continue",
                onPressed: () {
                  context.push('/review-report');
                })
            ],
          ),
        ),
      ),
    );
  }
}
