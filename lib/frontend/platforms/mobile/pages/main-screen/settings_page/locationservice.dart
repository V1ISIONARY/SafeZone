import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';
import 'package:permission_handler/permission_handler.dart';

class Locationservice extends StatefulWidget {
  const Locationservice({super.key});

  @override
  State<Locationservice> createState() => _LocationserviceState();
}

class _LocationserviceState extends State<Locationservice> {
  int? selectedOption; // 0 = While using, 1 = Never
  bool locationEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    setState(() {
      locationEnabled = status.isGranted;
      selectedOption = status.isGranted ? 0 : 1;
    });
  }

  Future<void> _toggleLocationSharing(int? value) async {
    if (value == 0) {
      final status = await Permission.location.request();
      if (status.isGranted) {
        setState(() {
          selectedOption = 0;
          locationEnabled = true;
        });
      }
    } else if (value == 1) {
      setState(() {
        selectedOption = 1;
        locationEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 250, 250),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:
            const CategoryText(text: "Location Service", color: Colors.black),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 10),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView(
            children: [
              const Text(
                "Permission settings",
                style: TextStyle(color: Colors.black38, fontSize: 11),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "While using"
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          bottom: 30, right: 10, left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "While using",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "We'll use your device's location to improve live interaction with other users.",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Radio<int>(
                                value: 0,
                                groupValue: selectedOption,
                                onChanged: _toggleLocationSharing,
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return widgetPricolor;
                                    }
                                    return Colors.black45;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // "Never"
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          bottom: 30, right: 10, left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Never",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.black45,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "We'll estimate your approximate location based on your system, carrier information and IP address. ",
                                      ),
                                      TextSpan(
                                        text: "Learn more",
                                        style: TextStyle(
                                          color: widgetPricolor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Radio<int>(
                                value: 1,
                                groupValue: selectedOption,
                                onChanged: _toggleLocationSharing,
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return widgetPricolor;
                                    }
                                    return Colors.black45;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Open device settings
                    GestureDetector(
                      onTap: () async {
                        await openAppSettings();
                      },
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Center(
                          child: Text(
                            "Open device settings",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Location history",
                style: TextStyle(color: Colors.black38, fontSize: 11),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Delete certain location data",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black45,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "To learn more about how Safezone uses your location information, please read the ",
                    ),
                    TextSpan(
                      text: "Help Center article.",
                      style: TextStyle(
                        color: widgetPricolor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
