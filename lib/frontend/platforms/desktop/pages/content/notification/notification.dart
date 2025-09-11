import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/architecture/cubic/notification.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/center/all.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/center/read.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/center/soshistory.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/center/unread.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/reports/reports_history.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/safezone/safe_zone_history.dart';
import 'package:safezone/frontend/platforms/desktop/widget/button/horizontalBtn.dart';
import 'package:safezone/backend/properties/import.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart' as user_notif;
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/center/notification_details.dart';

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

class _NotificationDTState extends State<NotificationDT>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late PageController pageController;
  late TabController _tabController;
  final List<String> _categories = ['All', 'Read', 'Unread', 'SOS History'];
  String? selectedInternalPage;
  late user_notif.NotificationModel notificationModel;

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

  List<Widget> getTopLevelPagesForCategory(String category) {
    switch (category) {
      case 'Read':
        return [
          Read(
            userToken: widget.UserToken,
            onOpenNotification: (notif) {
              setState(() {
                selectedInternalPage = "Notifications";
                notificationModel = notif;
              });
            },
          )
        ];
      case 'Unread':
        return [
          Unread(
            userToken: widget.UserToken,
            onOpenNotification: (notif) {
              setState(() {
                selectedInternalPage = "Notifications";
                notificationModel = notif;
              });
            },
          )
        ];
      case 'SOS History':
        return [
          Soshistory(
            userToken: widget.UserToken,
            onOpenNotification: (notif) {
              setState(() {
                selectedInternalPage = "Notifications";
                notificationModel = notif;
              });
            },
          )
        ];
      case 'All':
      default:
        return [
          All(
            userToken: widget.UserToken,
            onOpenNotification: (notif) {
              setState(() {
                selectedInternalPage = "Notifications";
                notificationModel = notif;
              });
            },
          )
        ];
    }
  }

  Widget _mainWrapperBody(String category) {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: getTopLevelPagesForCategory(category),
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
      case "Notifications":
        return NotificationDetails(
          onBack: () {
            setState(() {
              selectedInternalPage = null;
            });
          },
          notificationModel: notificationModel,
        );
      default:
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: const CategoryText(text: "Notification"),
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
                HorizontalBtn(
                  title: "My Incident Reports",
                  svgIcon: "lib/resource/svg/report_notif.svg",
                  navigateTo: "Reports",
                  description:
                      "Check the status and details of your submitted reports",
                  onTap: (page) {
                    setState(() {
                      selectedInternalPage = page;
                    });
                  },
                ),
                HorizontalBtn(
                  title: "My Safe Zones",
                  svgIcon: "lib/resource/svg/safe.png",
                  navigateTo: "Safezone",
                  description:
                      "Check the status and details of your submitted safe zones",
                  onTap: (page) {
                    setState(() {
                      selectedInternalPage = page;
                    });
                  },
                ),
                TabBar(
                  controller: _tabController,
                  indicatorColor: widgetPricolor,
                  labelColor: Colors.black,
                  labelStyle: const TextStyle(fontSize: 10),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: _categories
                      .map((category) => SizedBox(
                            height: 35,
                            child: Tab(text: category),
                          ))
                      .toList(),
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
            ));
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