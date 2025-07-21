import 'package:flutter/widgets.dart';
import 'package:safezone/backend/properties/import.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "Privacy", color: Colors.black),
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
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 20
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
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Activity status",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400
                                  ),
                                ),
                                Text(
                                "When this is turned on, you and your group friends will see each other's activity status. You will see each other's activity status only when both of you turn this on.",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 9
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isActive = !isActive;
                                  });
                                },
                                child: Container(
                                  height: 15,
                                  width: 35,
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: isActive ? widgetPricolor : widgetSeccolor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: AnimatedAlign(
                                    duration: const Duration(milliseconds: 200),
                                    alignment:
                                        isActive ? Alignment.centerRight : Alignment.centerLeft,
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Location Service",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "Manage the location information Safezone uses to\n personalize your experience",
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
                              child: GestureDetector(
                                child: Container(
                                  height: 15,
                                  width: 15,
                                  margin: const EdgeInsets.only(right: 17),
                                  child: Icon(
                                    Icons.chevron_right_outlined,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),
        )
      )
    );
  }
}