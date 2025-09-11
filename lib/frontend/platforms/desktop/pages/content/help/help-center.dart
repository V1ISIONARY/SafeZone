import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safezone/backend/properties/import.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/buttons/settings_btn.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/fade.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => HelpCenterState();
}

class HelpCenterState extends State<HelpCenter>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'Recommended',
    'Accessability',
    'Emergency',
    'General',
  ]
      .map((category) => category[0].toUpperCase() + category.substring(1))
      .toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        body: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Stack(
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          height: 300,
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: CustomPaint(
                              painter: WhiteBackgroundPainter(
                                  height: 0.3,
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  flip: true),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                              ),
                            )),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Hello, How can I help you",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 40,
                                    margin: const EdgeInsets.only(
                                        top: 30, bottom: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  Container(
                                      width: double.infinity,
                                      height: 30,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 229, 232, 209),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.volume_up_outlined,
                                            color: widgetPricolor,
                                            size: 11,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Safezone new features announcements",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: widgetPricolor,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.chevron_right_outlined,
                                            color: widgetPricolor,
                                            size: 11,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: double.infinity,
                                    height: 90,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Safezone Support Tools",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            height: 40,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                width: 0.5,
                                                color: Colors.black26,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "lib/resource/svg/safety-files.svg",
                                                  color: widgetPricolor,
                                                  height: 18,
                                                  width: 18,
                                                ),
                                                const SizedBox(width: 10),
                                                const Text(
                                                  "Safety Tips & Resources",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: double.infinity,
                                      height: 500,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 5),
                                              child: Text(
                                                "Quick Answer",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            TabBar(
                                              controller: _tabController,
                                              indicatorColor: btnColor,
                                              labelColor: Colors.black,
                                              labelStyle:
                                                  const TextStyle(fontSize: 10),
                                              tabs: _categories
                                                  .map((category) => SizedBox(
                                                        height: 35,
                                                        child:
                                                            Tab(text: category),
                                                      ))
                                                  .toList(),
                                              dividerColor: Colors.black12,
                                            ),
                                            Expanded(
                                              child: TabBarView(
                                                controller: _tabController,
                                                children: _categories
                                                    .map((category) =>
                                                        _buildCategoryPage(
                                                            category))
                                                    .toList(),
                                              ),
                                            ),
                                            Center(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        children: [
                                                          const TextSpan(
                                                              text:
                                                                  'Still have questions? View the '),
                                                          TextSpan(
                                                            text:
                                                                'Help Center Articles',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  widgetPricolor, // Optional: change link color
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                            ),
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    print(
                                                                        'Navigating to Help Center Articles...');
                                                                  },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]))
                                          ])),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            "Do You Have Any Other Question?",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Settingsbtn(
                                          title: 'Chat Support',
                                          svgIcon:
                                              'lib/resource/svg/support-agent.svg',
                                          navigateTo: 'about',
                                          description:
                                              'Powered by our support agent.',
                                          onTap: () {},
                                        ),
                                        const Divider(
                                          color: Colors.black26,
                                          height: 0.2,
                                        ),
                                        Settingsbtn(
                                          title: 'Live Chat Support',
                                          svgIcon:
                                              'lib/resource/svg/support-agent.svg',
                                          navigateTo: 'about',
                                          description:
                                              'Get real-time help from our support team.',
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    )))));
  }

  final List<String> recommend = [
    "[Troubleshoot] What should I do if alerts aren’t sent or if I have connectivity issues?",
    "[Privacy & Security] Is my location tracked all the time?",
    "[Troubleshoot] Why can’t I check in, or why is my location not detected accurately?",
    "[Accessability] Are there alternatives if I cannot use the app due to accessibility reasons?"
        "[Emergency] How quickly will I get a response if I send an alert?"
  ];

  final List<String> accessability = [
    "Is SafeZone accessible for users with disabilities or vision impairments?",
    "Are there alternatives if I cannot use the app due to accessibility reasons?",
  ];

  final List<String> emergency = [
    "What should I do in a real emergency?",
    "How quickly will I get a response if I send an alert?",
    "What happens if I raise a false alert or press a button by mistake?",
    "Who receives my alert, and how will they contact me?",
  ];

  final List<String> general = [
    "How do I update my SafeZone profile?",
    "What are the app’s privacy settings?",
  ];

  Widget _buildCategoryPage(String status) {
    List<String> selectedList;

    switch (status.toLowerCase()) {
      case 'accessability':
        selectedList = accessability;
        break;
      case 'emergency':
        selectedList = emergency;
        break;
      case 'general':
        selectedList = general;
        break;
      default:
        selectedList = recommend;
    }

    return Container(
      width: double.infinity,
      height: 400,
      color: Colors.transparent,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.builder(
          itemCount: selectedList.length,
          itemBuilder: (context, index) {
            final text = selectedList[index];

            return LayoutBuilder(
              builder: (context, constraints) {
                final textSpan = TextSpan(
                  text: text,
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                );

                final textPainter = TextPainter(
                  text: textSpan,
                  textDirection: TextDirection.ltr,
                  maxLines: null,
                );

                textPainter.layout(maxWidth: constraints.maxWidth - 30);
                final lineCount = textPainter.computeLineMetrics().length;

                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black12),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: lineCount == 1
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}",
                        style: TextStyle(
                          fontSize: 13,
                          color: index == 0
                              ? Colors.red
                              : index == 1
                                  ? Colors.green
                                  : index == 2
                                      ? Colors.blue
                                      : Colors.black45,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
