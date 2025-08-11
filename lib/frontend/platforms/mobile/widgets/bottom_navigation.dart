import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/notification.dart';

import '../../../../../backend/properties/import.dart';

class BottomNavigationWidget extends StatefulWidget {
  final String userToken;

  const BottomNavigationWidget({super.key, required this.userToken});

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _pages = [
      Maps(UserToken: widget.userToken),
      Contact(UserToken: widget.userToken),
      Notif(UserToken: widget.userToken, initialPage: 0),
      Settings(UserToken: widget.userToken),
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
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 3.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: -3.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -3.0, end: 3.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 0.0), weight: 1),
    ]).animate(_controller);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
    return Scaffold(
      backgroundColor: widgetPricolor,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconItem("Map", "lib/resource/svg/map.svg", 0),
              _buildIconItem("Contacts", "lib/resource/svg/contacts.svg", 1),
              const Expanded(child: SizedBox(width: 48)),
              _buildIconItem(
                  "Notification", "lib/resource/svg/notification.svg", 2),
              _buildIconItem("Settings", "lib/resource/svg/settings.svg", 3),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.userToken == 'guest'
          ? FloatingActionButton(
              backgroundColor: widgetPricolor,
              splashColor: Colors.transparent,
              elevation: 5,
              shape: const CircleBorder(),
              onPressed: () {
                _startShake();
              },
              child: Stack(children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white38, shape: BoxShape.circle),
                ),
                Center(
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_animation.value, 0),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.asset(
                            'lib/resource/image/png/lock.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]))
          : FloatingActionButton(
              backgroundColor: widgetPricolor,
              splashColor: Colors.transparent,
              elevation: 5,
              shape: const CircleBorder(),
              onPressed: () {
                context.push('/sos-countdown');
              },
              child: const Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  Widget _buildIconItem(String label, String iconPath, int index) {
    bool isSelected = _selectedIndex == index;

    return Expanded(
        child: GestureDetector(
      onTap: () {
        _onItemTapped(index);
      },
      child: Container(
        height: double.infinity,
        width: 55,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 17,
              width: double.infinity,
              child: SvgPicture.asset(
                iconPath,
                color: isSelected ? widgetPricolor : Colors.black45,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    label,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w400,
                      color: isSelected ? widgetPricolor : Colors.black45,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
