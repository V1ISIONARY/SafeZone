import 'package:flutter/widgets.dart';
import 'package:safezone/backend/properties/import.dart';

class Freespace extends StatefulWidget {
  const Freespace({super.key});

  @override
  State<Freespace> createState() => _FreespaceState();
}

class _FreespaceState extends State<Freespace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "Free up space", color: Colors.black),
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
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: ListView(
                children: [
                  const Text(
                    'Safezone data',
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                  const Text(
                    '2.91GB',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 40),
                  ),
                  const Text(
                    "Occupies 2% of device's storage",
                    style: TextStyle(color: Colors.black38, fontSize: 11),
                  ),
                  Container(
                    height: 20,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: widgetPricolor),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 124, 138, 164)),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "Safezone",
                            style: TextStyle(color: Colors.black, fontSize: 8),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 79, 187, 111)),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "Other apps",
                            style: TextStyle(color: Colors.black, fontSize: 8),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 114, 116, 114)),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "Free",
                            style: TextStyle(color: Colors.black, fontSize: 8),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 40),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Cache: 536.7MB",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "Clear your cache to free up\nspace. This won't affect your Tiktok experience",
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 9),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                child: Container(
                                  width: 80,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 240, 240, 240),
                                      border: Border.all(
                                          color: Colors.black, width: 0.5),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Center(
                                      child: Text("Clear",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400))),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Downloads: 3.2MB",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "Download may include effects,\nfilters, zones offline map,and informations downloaded\nin your app. You'll beable to download them again if you need them.",
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 9),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                child: Container(
                                  width: 80,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 240, 240, 240),
                                      border: Border.all(
                                          color: Colors.black, width: 0.5),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Center(
                                      child: Text("Clear",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400))),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Safezpme data also includes system files that help the app run smoothly\nand can't be cleared.",
                    style: TextStyle(color: Colors.black38, fontSize: 11),
                  ),
                ],
              ))),
    );
  }
}
