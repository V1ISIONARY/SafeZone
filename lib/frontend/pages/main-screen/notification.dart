import 'package:flutter/material.dart';
import 'package:safezone/frontend/widgets/buttons/notification_btn.dart';

class Notif extends StatefulWidget {

  final String UserToken;

  const Notif({
    super.key,
    required this.UserToken
  });

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
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

  void _startShake() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
            centerTitle: false,
            title: const Text(
              "Notification",
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                NotificationBtn(
                    title: "Reports History",
                    svgIcon: "lib/resources/svg/report_notif.svg",
                    navigateTo: "Reports",
                    description:
                        "Check the status and details of your submitted reports"),
              ],
            ),
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
                            child: Container(
                              width: 150,
                              height: 130,
                              child: Image.asset(
                                'lib/resources/images/lock.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      ),
                      Text(
                        'Lock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'You need to sign in to your account to access all features.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ]
                  )
                ),
              ),
            ) 
          )
          : SizedBox(),
      ]
    );
  }
}
