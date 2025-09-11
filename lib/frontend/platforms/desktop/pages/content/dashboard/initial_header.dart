import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safezone/backend/properties/properties.dart';
import 'package:safezone/resource/schema/texts.dart';

class InitialHeader extends StatefulWidget {
  const InitialHeader({super.key});

  @override
  State<InitialHeader> createState() => _InitialHeaderState();
}

class _InitialHeaderState extends State<InitialHeader> {
  final sharedController = SharedProperties();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: const Color.fromARGB(255, 250, 250, 250),
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
      child: Row(
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
                                    sharedController.isSidebarCollapsed.value =
                                        !sharedController
                                            .isSidebarCollapsed.value;
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
                        : ValueListenableBuilder(
                            valueListenable: sharedController.isSidebarTab,
                            builder: (context, tabvalue, child) {
                              return tabvalue
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 15),
                                      child: Tooltip(
                                        message: 'Open tab',
                                        preferBelow: false,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            hoverColor: Colors.grey.shade300,
                                            onTap: () {
                                              sharedController
                                                      .isSidebarTabUi.value =
                                                  !sharedController
                                                      .isSidebarTabUi.value;
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: SvgPicture.asset(
                                                'lib/resource/svg/navigation_tab.svg',
                                                color: Colors.black45,
                                                height: 18,
                                                width: 19,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(left: 10),
                                    );
                            });
                  }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dashboard Overview',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Last updated: ${DateTime.now().toString()}',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Spacer(),
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
        ],
      ),
    );
  }
}