import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/frontend/widgets/buttons/custom_radio_button.dart';
import 'package:safezone/frontend/widgets/text_field_widget.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class MarkSafeZone extends StatefulWidget {
  const MarkSafeZone({super.key});

  @override
  State<MarkSafeZone> createState() => _MarkSafeZoneState();
}

class _MarkSafeZoneState extends State<MarkSafeZone> {
  final TextEditingController _descriptionController = TextEditingController();
  int selectedRating = 0;
  String selectedTime = "Daytime";
  String selectedOften = "Daily";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Mark as Safe Zone"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Pin the location of the safe zone")),
              const SizedBox(height: 10),
              Container(
                height: 215,
                width: 350,
                color: const Color.fromARGB(54, 96, 125, 139),
              ),
              const SizedBox(height: 30),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "On a scale of 1 to 5, how would you rate the safety of this area?")),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  int ratingValue = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRating = ratingValue;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        color: selectedRating == ratingValue
                            ? btnColor.withOpacity(0.1)
                            : bgColor,
                        border: Border.all(
                          color: selectedRating == ratingValue
                              ? btnColor
                              : const Color(0xff707070).withOpacity(0.5),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          ratingValue.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Why did you give this rating?")),
              const SizedBox(height: 20),
              TextFieldWidget.buildTextField(
                  controller: _descriptionController,
                  label: "Description",
                  hint: "Enter details about the safe zone",
                  maxLines: 5,
                  minLines: 5),
              const SizedBox(height: 20),
              const Align(
                  alignment: Alignment.centerLeft,
                  child:
                      Text("What time of day do you feel this area is safe?")),
              const SizedBox(height: 10),
              Column(
                children: [
                  CustomRadioButton(
                    value: "Daytime",
                    groupValue: selectedTime,
                    label: "Daytime",
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value!;
                      });
                    },
                  ),
                  CustomRadioButton(
                    value: "Nighttime",
                    groupValue: selectedTime,
                    label: "Nighttime",
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value!;
                      });
                    },
                  ),
                  CustomRadioButton(
                    value: "Both",
                    groupValue: selectedTime,
                    label: "Both",
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("How often do you visit this area?")),
              const SizedBox(height: 10),
              Column(
                children: [
                  CustomRadioButton(
                    value: "Daily",
                    groupValue: selectedOften,
                    label: "Daily",
                    onChanged: (value) {
                      setState(() {
                        selectedOften = value!;
                      });
                    },
                  ),
                  CustomRadioButton(
                    value: "Weekly",
                    groupValue: selectedOften,
                    label: "Weekly",
                    onChanged: (value) {
                      setState(() {
                        selectedOften = value!;
                      });
                    },
                  ),
                  CustomRadioButton(
                    value: "Occasionally",
                    groupValue: selectedOften,
                    label: "Occasionally",
                    onChanged: (value) {
                      setState(() {
                        selectedOften = value!;
                      });
                    },
                  ),
                  CustomRadioButton(
                    value: "Rarely",
                    groupValue: selectedOften,
                    label: "Rarely",
                    onChanged: (value) {
                      setState(() {
                        selectedOften = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CustomButton(
                  text: "Submit",
                  onPressed: () {
                    context.push('/mark-safe-zone-success');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
