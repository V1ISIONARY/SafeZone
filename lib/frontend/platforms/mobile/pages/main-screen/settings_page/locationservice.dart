import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';

class Locationservice extends StatefulWidget {
  const Locationservice({super.key});

  @override
  State<Locationservice> createState() => _LocationserviceState();
}

class _LocationserviceState extends State<Locationservice> {

  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "Location Service", color: Colors.black),
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
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
          ),
          child: ListView(
            children: [
              Text(
                "Permission settings",
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 11
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 10
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 30, right: 10, left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
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
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedOption = value;
                                  });
                                },
                                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return widgetPricolor;
                                  }
                                  return Colors.black45;
                                })
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 30, right: 10, left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Never",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.black45,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: "We'll estimate your approximate location based on your system, carrier information and IP address. ",
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
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedOption = value;
                                  });
                                },
                                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return widgetPricolor;
                                  }
                                  return Colors.black45;
                                })
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: Text(
                            "Open device settings",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            )
                          )
                        )
                      ),
                    )
                  ]
                )
              ),
              SizedBox(height: 10),
              Text(
                "Location history",
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 11
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 10
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  "Delete certain location data",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black45,
                  ),
                  children: [
                    const TextSpan(
                      text: "To learn more about how Safezone uses your location information, please read the ",
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
            ]
          )
        )
      )
    );
  }
}