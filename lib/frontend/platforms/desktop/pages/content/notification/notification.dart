import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/architecture/cubic/notification.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/reports/reports_history.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/safezone/safe_zone_history.dart';
import 'package:safezone/frontend/platforms/desktop/widget/button/horizontalBtn.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/all.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/read.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/unread.dart';
import 'package:safezone/backend/properties/import.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';

class NotificationDT extends StatefulWidget {
  final VoidCallback? onClose;
  final String UserToken;
  final int initialPage;
  final ValueNotifier<String?>? selectedPage;

  const NotificationDT({
    super.key,
    this.onClose,
    this.selectedPage,
    required this.UserToken,
    required this.initialPage,
  });

  @override
  State<NotificationDT> createState() => _NotificationDTState();
}

class _NotificationDTState extends State<NotificationDT> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late PageController pageController;
  late List<Widget> topLevelPages;

  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'Read',
    'Unread',
  ].map((category) => category[0].toUpperCase() + category.substring(1))
  .toList();

  Widget _mainWrapperBody(String category) {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: getTopLevelPagesForCategory(category),
    );
  }

  List<Widget> getTopLevelPagesForCategory(String category) {
    switch (category) {
      case 'Read':
        return [Read(userToken: widget.UserToken)];
      case 'Unread':
        return [Unread(userToken: widget.UserToken)];
      case 'All':
      default:
        return [All(userToken: widget.UserToken)];
    }
  }

  String? selectedInternalPage;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _categories.length, vsync: this);
    pageController = PageController(initialPage: widget.initialPage);

    if (widget.selectedPage != null) {
      widget.selectedPage!.addListener(_handlePageSelection);
    }

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

  void _handlePageSelection() {
    final page = widget.selectedPage!.value;
    print("ito: $page");

    if (!mounted) return;

    setState(() {
      selectedInternalPage = null;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        selectedInternalPage = page;
      });
    });
  }


  void onPageChanged(int page) {
    BlocProvider.of<NotificationCubit>(context).changeSelectedIndex(page);
  }

  void _startShake() {
    _controller.forward();
  }

  Widget _bodyNavigator(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomAppBarItem("All", 0),
          _bottomAppBarItem("Read", 1),
          _bottomAppBarItem("Unread", 2),
        ],
      ),
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
          child: BlocBuilder<NotificationCubit, int>(
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
                    child: Container(
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
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _getPageForNavigation(String? page) {
    switch (page) {
      case "Reports":
        return ReportsHistoryDT(
          onBack: () {
            setState(() {
              selectedInternalPage = null;
            });
          },
        );
      case "Safezone":
        return SafezoneHistoryDT(
          onBack: () {
            setState(() {
              selectedInternalPage = null;
            });
          },
        );
      default:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: CategoryText(text: "Notification"),
            actions: [
              GestureDetector(
               onTap: () {
                  if (widget.onClose != null) {
                    widget.onClose!();
                  }
                },
                child: const Icon(
                  Icons.cancel_outlined,
                  size: 20,
                  color: Colors.black38,
                ),
              ),
              const SizedBox(width: 15)
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: HorizontalBtn(
                  title: "My Incident Reports",
                  svgIcon: "lib/resource/svg/report_notif.svg",
                  navigateTo: "Reports",
                  description: "Check the status and details of your submitted reports",
                  onTap: (page) {
                    setState(() {
                      selectedInternalPage = page;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: HorizontalBtn(
                  title: "My Safe Zones",
                  svgIcon: "lib/resource/svg/safe.png",
                  navigateTo: "Safezone",
                  description: "Check the status and details of your submitted safe zones",
                  onTap: (page) {
                    setState(() {
                      selectedInternalPage = page;
                    });
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: widgetPricolor,
                labelColor: Colors.black,
                labelStyle: TextStyle(fontSize: 10),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                tabs: _categories.map((category) => SizedBox(
                  height: 35,
                  child: Tab(text: category),
                )).toList(),
                dividerColor: Colors.black12,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _categories
                    .map((category) => _mainWrapperBody(category))
                    .toList(),
                ),
              ),
            ],
          )
        );
    }
  }

  @override
  void dispose() {
    widget.selectedPage?.removeListener(_handlePageSelection);
    _tabController.dispose();
    pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("REBUILD: selectedInternalPage = $selectedInternalPage");
    return Stack(
      children: [
        _getPageForNavigation(selectedInternalPage),
        widget.UserToken == 'guest'
          ? GestureDetector(
              onTap: _startShake,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black38,
                child: Center(
                  child: Container(
                    width: 200,
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_animation.value, 0),
                              child: SizedBox(
                                width: 130,
                                height: 110,
                                child: Image.asset(
                                  'lib/resource/image/png/lock.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                        const Text(
                          'Lock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          'You need to sign in to your account to access all features.',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 9,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox(),
      ],
    );
  }
}