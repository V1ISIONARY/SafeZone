import 'package:safezone/backend/properties/import.dart';
import 'package:safezone/backend/properties/properties.dart';
import 'package:safezone/frontend/platforms/desktop/widget/button/sidenav.dart';

class NavigationDT extends StatefulWidget {
  const NavigationDT({super.key});

  @override
  State<NavigationDT> createState() => _NavigationDTState();
}

class _NavigationDTState extends State<NavigationDT> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final sharedController = SharedProperties();

  bool isMapSelected = true;
  bool _hovering = false;

  void toggleSwitch() {
    setState(() {
      isMapSelected = !isMapSelected;
    });
  }

  Widget _buildDrawer() {
    return Container(
      width: sharedController.isSidebarCollapsed ? 40 : 240,
      height: double.infinity,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          right: 9
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: btnColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'R',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !sharedController.isSidebarCollapsed,
                    child: SizedBox(width: 10),
                  ),
                  Visibility(
                    visible: !sharedController.isSidebarCollapsed,
                    child: Expanded(
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ramon',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'ramonlangpu@gmail.com',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Tooltip(
                            message: 'Close sidebar',
                            preferBelow: false,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                hoverColor: Colors.grey.shade300,
                                onTap: () {
                                  setState(() {
                                    sharedController.isSidebarCollapsed =
                                        !sharedController.isSidebarCollapsed;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: SvgPicture.asset(
                                    'lib/resource/svg/close_sidebar.svg',
                                    color: Colors.black45,
                                    height: 18,
                                    width: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Sidenav(
                  icon: Icons.public,
                  label: 'Zones',
                  hoverTrailing: [
                    Text(
                      'Ctrl',
                      style: TextStyle(fontSize: 10, color: Colors.black38),
                    ),
                    Icon(Icons.arrow_upward_outlined, color: Colors.black38, size: 10),
                    Text('W', style: TextStyle(fontSize: 10, color: Colors.black38)),
                  ],
                  onTap: () => print('Tapped Zones'),
                ),
                Sidenav(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  hoverTrailing: [
                    Text(
                      'Ctrl',
                      style: TextStyle(fontSize: 10, color: Colors.black38),
                    ),
                    Icon(Icons.arrow_upward_outlined, color: Colors.black38, size: 10),
                    Text('A', style: TextStyle(fontSize: 10, color: Colors.black38)),
                  ],
                  onTap: () => print('Tapped Zones'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 1,
                  width: double.infinity,
                  color: Colors.black12,
                ),
                Sidenav(
                  icon: Icons.notifications_outlined,
                  label: 'Notification',
                  onTap: () => print('Tapped Zones'),
                ),
                Sidenav(
                  icon: Icons.phone_outlined,
                  label: 'Contact',
                  onTap: () => print('Tapped Zones'),
                ),
                Sidenav(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  withDrop: true,
                  dropdownItems: [
                    DropdownItem(
                      label: 'Account',
                      onTap: () => print('Account')
                    ),
                    DropdownItem(
                      label: 'Security', 
                      onTap: () => print('Security')
                    ),
                    DropdownItem(
                      label: 'Notifications', 
                      onTap: () => print('Notifications')
                    ),
                  ],
                ),
                Sidenav(
                  icon: Icons.help_outline_outlined,
                  label: 'Help Center',
                  onTap: () => print('Tapped Zones'),
                ),
              ]
            )
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 250, 250, 250),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            _buildDrawer(),
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 130,
                            height: 30,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                AnimatedAlign(
                                  alignment: isMapSelected ? Alignment.centerLeft : Alignment.centerRight,
                                  duration: Duration(milliseconds: 250),
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
                          SizedBox(width: 10),
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
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Transform.translate(
                              offset: Offset(-2, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.layers_outlined,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Layers',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500
                                    ),
                                  )
                                ],
                              ),
                            )
                          ) 
                        ],
                      )
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}