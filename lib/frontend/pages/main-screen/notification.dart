import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/cubic/notification.dart';
import 'package:safezone/frontend/pages/main-screen/notification/all.dart';
import 'package:safezone/frontend/pages/main-screen/notification/read.dart';
import 'package:safezone/frontend/pages/main-screen/notification/unread.dart';
import 'package:safezone/frontend/widgets/buttons/notification_btn.dart';
import 'package:safezone/resources/schema/colors.dart';

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

class _NotifState extends State<Notif> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late PageController pageController;
  late List<Widget> topLevelPages;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: widget.initialPage);
    topLevelPages = [All(), Read(), Unread()];

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

  Widget _mainWrapperBody() {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: topLevelPages,
    );
  }

  void _startShake() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  Widget _bodyNavigator(BuildContext context) {
    return Container(
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
                    child:Container(
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
                          : SizedBox(), 
                        ),
                      ),
                    )
                  )
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
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: NotificationBtn(
                  title: "My Incident Reports",
                  svgIcon: "lib/resources/svg/report_notif.svg",
                  navigateTo: "Reports",
                  description:
                      "Check the status and details of your submitted reports",
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: NotificationBtn(
                  title: "My Safe Zones",
                  svgIcon: "lib/resources/svg/safe.png",
                  navigateTo: "Safezone",
                  description:
                      "Check the status and details of your submitted safe zones",
                ),
              ),
              _bodyNavigator(context),
              Expanded(child: _mainWrapperBody()),
            ],
          ),
        ),
        widget.UserToken == 'guess'
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
                                    'lib/resources/images/lock.png',
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
