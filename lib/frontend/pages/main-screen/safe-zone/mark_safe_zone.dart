import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/widgets/custom_button.dart';
import 'package:safezone/frontend/widgets/text_field_widget.dart';

class MarkSafeZone extends StatefulWidget {
  const MarkSafeZone({super.key});

  @override
  State<MarkSafeZone> createState() => _MarkSafeZoneState();
}

class _MarkSafeZoneState extends State<MarkSafeZone> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _descriptionController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark as Safe Zone"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Pin the location of the safe zone")),
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
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "On scale of 1 to 5, how would you rate the safety of this area?")),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Why did you give this rating?")),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget.buildTextField(
                  controller: _descriptionController,
                  label: "Description",
                  hint: "Enter details about the safe zone",
                  maxLines: 5,
                  minLines: 5),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child:
                      Text("What time of day do you feel this area is safe?")),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("How often do you visit this area?")),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                  text: "Submit",
                  onPressed: () {
                    context.push('/mark-safe-zone-success');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
