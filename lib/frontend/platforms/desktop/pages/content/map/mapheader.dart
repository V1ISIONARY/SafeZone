import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safezone/backend/properties/properties.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';

class MapHeader extends StatefulWidget {
  const MapHeader({super.key});

  @override
  State<MapHeader> createState() => _MapHeaderState();
}

class _MapHeaderState extends State<MapHeader> {
  bool isMapSelected = true;
  final sharedController = SharedProperties(); // your singleton or controller

  final TextEditingController searchController = TextEditingController();

  void toggleSwitch() {
    setState(() {
      isMapSelected = !isMapSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 250, 250, 250),
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: sharedController.isSidebarCollapsed,
                builder: (context, value, child) {
                  return value 
                    ? Container(
                        margin: const EdgeInsets.only(left: 10, right: 15),
                        child: Tooltip(
                          message: 'Open sidebar',
                          preferBelow: false,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              hoverColor: Colors.grey.shade300,
                              onTap: () {
                                sharedController.isSidebarCollapsed.value = !sharedController.isSidebarCollapsed.value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: SvgPicture.asset(
                                  'lib/resource/svg/open_sidebar.svg',
                                  color: Colors.black45,
                                  height: 18,
                                  width: 19,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(width: 10);
                }
              ),
              Row(
                children: [
                  Image.asset(
                    'lib/resource/image/logo/safezone.png',
                    height: 20,
                    width: 18,
                  ),
                  const SizedBox(width: 5),
                  const CategoryText(text: 'Safezone'),
                ],
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double maxMargin = 150;
                    double minMargin = 0;
                    double screenWidth = constraints.maxWidth;

                    // You can adjust the formula below to control how quickly margin shrinks
                    double margin = (screenWidth / 10).clamp(minMargin, maxMargin);

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: margin),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Container(
                              height: 35,
                              margin: const EdgeInsets.only(right: 10),
                              child: TextField(
                                controller: searchController,
                                cursorColor: labelFormFieldColor,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w100,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Search | Dagupan City > Pantal East > Sagur",
                                  hintStyle: TextStyle(
                                    fontSize: 10,
                                    color: labelFormFieldColor,
                                    fontWeight: FontWeight.w100,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: Colors.black12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: Colors.black12, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: widgetPricolor, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: GestureDetector(
                                      onTap: () {
                                        print("Search tapped");
                                      },
                                      child: Container(
                                        width: 70,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: btnColor,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Search',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              height: 33,
                              width: 33,
                              decoration: BoxDecoration(
                                color: btnColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.mic,
                                size: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: 130,
                height: 30,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      alignment: isMapSelected
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          color: btnColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (!isMapSelected) toggleSwitch();
                            },
                            child: Container(
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                'Map',
                                style: TextStyle(
                                  color: isMapSelected ? Colors.white : Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (isMapSelected) toggleSwitch();
                            },
                            child: Container(
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                'Satellite',
                                style: TextStyle(
                                  color: isMapSelected ? Colors.grey : Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.layers_outlined, size: 15, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        'Layers',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
