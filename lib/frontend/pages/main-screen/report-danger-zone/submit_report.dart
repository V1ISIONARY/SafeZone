import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/widgets/custom_button.dart';
import 'package:safezone/frontend/widgets/report-danger-zone/text_row.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class ReviewReport extends StatefulWidget {
  const ReviewReport({super.key});

  @override
  State<ReviewReport> createState() => _ReviewReportState();
}

class _ReviewReportState extends State<ReviewReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Review Your Report"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: btnColor, width: 0.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xff95BDA7)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Take a moment to confirm your details. Your report is important for community safety.",
                          style: TextStyle(fontSize: 11, color: textColor),
                        ),
                      ),
                    ],
                  )),
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
              const TextRow(
                  firstText: "Location: ",
                  secondText:
                      "28WV+R2R, Arellano St, Downtown District, Dagupan, 2400 Pangasinan"),
              const SizedBox(
                height: 10,
              ),
              const TextRow(
                  firstText: "Time and Date: ",
                  secondText: "December 17, 2024 || 1:48 pm"),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              const TextRow(
                  firstText: "Description: ",
                  secondText:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut"),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Images:",
                  style: TextStyle(
                      fontSize: 15,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Imagessss",
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              CustomButton(
                  text: "Submit",
                  onPressed: () {
                    context.push('/report-success');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
