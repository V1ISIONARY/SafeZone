import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../backend/architecture/cubic/analytics.dart';
import '../../../../../backend/properties/import.dart';

class MainAnalytics extends StatefulWidget {
  final int initialPage;
  const MainAnalytics({super.key, required this.initialPage});

  @override
  State<MainAnalytics> createState() => _MainAnalyticsState();
}

class _MainAnalyticsState extends State<MainAnalytics>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late PageController pageController;
  late List<Widget> topLevelPages;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: widget.initialPage);
    topLevelPages = [
      const AdminInitialScreen(),
      const AdminReportsUsers(),
      const AdminSafezones(),
      const AdminDangerzones(),
      const AdminReports(),
    ];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
        }
      });

    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_controller);
  }

  void onPageChanged(int page) {
    BlocProvider.of<AnalyticsCubic>(context).changeSelectedIndex(page);
  }

  Widget _mainWrapperBody() {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: topLevelPages,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  Widget _bodyNavigator(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _bottomAppBarItem("Overview", 0),
        _bottomAppBarItem("Users", 1),
        _bottomAppBarItem("Safezone", 2),
        _bottomAppBarItem("Dangerzone", 3),
        _bottomAppBarItem("Incidents", 4),
      ]),
    );
  }

  Widget _bottomAppBarItem(String indicator, int page) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          pageController.jumpToPage(page);
          onPageChanged(page);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: BlocBuilder<AnalyticsCubic, int>(
            builder: (context, selectedIndex) {
              final isSelected = selectedIndex == page;
              return Column(
                children: [
                  Text(
                    indicator,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.black : Colors.black38,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: 4,
                        width: double.infinity,
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: 0.5,
                            color: Colors.black38,
                            child: isSelected
                                ? Container(
                                    width: double.infinity,
                                    height: 5.0,
                                    color: widgetPricolor,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ))
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const CategoryText(text: "Reports Analytics"),
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
              child:
                  const Icon(Icons.arrow_back, color: Colors.black, size: 10),
            ),
          ),
        ),
        body: Column(
          children: [
            _bodyNavigator(context),
            Expanded(child: _mainWrapperBody()),
          ],
        ),
      ),
    ]);
  }
}
