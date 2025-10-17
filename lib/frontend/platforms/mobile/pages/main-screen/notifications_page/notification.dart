import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/architecture/cubic/notification.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/all.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/read.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/soshistory.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/unread.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/buttons/notification_btn.dart';
import 'package:safezone/resource/schema/colors.dart';

class Notif extends StatefulWidget {
  final String UserToken;
  final int initialPage;

  const Notif({
    super.key,
    required this.UserToken,
    required this.initialPage,
  });

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late PageController pageController;
  late List<Widget> topLevelPages;

  late TabController _tabController;
  // final List<String> _categories = ['All', 'Read', 'Unread', 'SOS History']
  //     .map((category) => category[0].toUpperCase() + category.substring(1))
  //     .toList();

  final List<String> _categories = ['All', 'Read', 'Unread']
      .map((category) => category[0].toUpperCase() + category.substring(1))
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
      // case 'SOS History':
      //   return [Soshistory(userToken: widget.UserToken)];
      case 'All':
      default:
        return [All(userToken: widget.UserToken)];
    }
  }

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: widget.initialPage);
    _tabController = TabController(length: _categories.length, vsync: this);

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
    BlocProvider.of<NotificationCubit>(context).changeSelectedIndex(page);
  }

  void _startShake() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: const Text(
              "Notification",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          body: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: Column(
              children: [
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(children: [
                        NotificationBtn(
                          title: "My Incident Reports",
                          svgIcon: "lib/resource/svg/report_notif.svg",
                          navigateTo: "Reports",
                          description:
                              "Check the status and details of your submitted reports",
                        ),
                        NotificationBtn(
                          title: "My Safe Zones",
                          svgIcon: "lib/resource/svg/safe.png",
                          navigateTo: "Safezone",
                          description:
                              "Check the status and details of your submitted safe zones",
                        ),
                      ])),
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
            ),
          ),
        ),
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
