import 'package:safezone/backend/properties/import.dart';
import 'package:safezone/backend/properties/properties.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/contact.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/circles/createreport.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/circles/listofgroup.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/circles/marksafezone.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/map.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/mapheader.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification.dart';
import 'package:safezone/frontend/platforms/desktop/widget/button/sidenav.dart';

class NavigationDT extends StatefulWidget {
  final String userToken;
  const NavigationDT({
    super.key,
    required this.userToken
  });

  @override
  State<NavigationDT> createState() => _NavigationDTState();
}

class _NavigationDTState extends State<NavigationDT> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedDropdownIndex = 0;
  int _selectedPageIndex = 0;
  int selectedComs = 0;

  bool showit = false;
  bool dropdown = false;
  final sharedController = SharedProperties();

  Widget _getSelectedPage() {
    Widget pageContent;

    switch (_selectedPageIndex) {
      case 0:
        pageContent = MapDT(UserToken: widget.userToken);
        break;
      case 1:
        pageContent = Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        );
        break;
      case 2:
        pageContent = const Center(child: Text('Page 2 Content'));
        break;
      case 3:
        pageContent = const Center(child: Text('Page 3 Content'));
        break;
      case 4:
        pageContent = const Center(child: Text('Page 4 Content'));
        break;
      case 6:
        pageContent = const Center(child: Text('Page 6 Content'));
        break;
      default:
        pageContent = const Center(child: Text('Default Page'));
    }

    Widget _getComsPage() {
      switch (selectedComs) {
        case 0:
          return NotificationDT(UserToken: widget.userToken, initialPage: 0);
        case 1:
          return ContactDT(UserToken: widget.userToken);
        default:
          return const Center(child: Text('No Dropdown Content'));
      }
    }

    Widget _getSelectedDropPage() {
      switch (selectedDropdownIndex) {
        case 0:
          return ListOfGroupsDT();
        case 1:
          return CreateReportDT();
        case 2:
          return MarkSafeZoneDT();
        default:
          return const Center(child: Text('No Dropdown Content'));
      }
    }

    return Column(
      children: [
        if (_selectedPageIndex == 0) const MapHeader(),
        Expanded(
          child: Row(
            children: [
              if (showit == true)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 350,
                    color: Colors.white,
                    child: _getComsPage(),
                  ),
                ),
              Expanded(
                child: pageContent,
              ),
              if (dropdown == true)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.only(
                      right: 15,
                      left: 15,
                    ),
                    color: Colors.white,
                    child: _getSelectedDropPage(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return ValueListenableBuilder<bool>(
      valueListenable: sharedController.isSidebarCollapsed,
      builder: (context, isCollapsed, child) {
        return Container(
          width: isCollapsed ? 40 : 240,
          height: double.infinity,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              right: 9
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 13),
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
                        visible: !sharedController.isSidebarCollapsed.value,
                        child: SizedBox(width: 10),
                      ),
                      Visibility(
                        visible: !sharedController.isSidebarCollapsed.value,
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
                                        sharedController.isSidebarCollapsed.value =
                                            !sharedController.isSidebarCollapsed.value;
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
                sharedController.isSidebarCollapsed.value
                  ? SizedBox.shrink()
                  : Container(
                    height: 33,
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    child: TextField(
                      cursorColor: labelFormFieldColor,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.w100,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(
                          fontSize: 10,
                          color: labelFormFieldColor,
                          fontWeight: FontWeight.w100,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.black12, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: widgetPricolor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.only(left: -5, top: 12, bottom: 12),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 0, right: 5), // Remove extra padding
                          child: Transform.translate(
                            offset: Offset(5, 0),
                            child: Icon(
                              Icons.search,
                              size: 18,
                              color: sharedController.emailController.text.isNotEmpty
                                ? widgetPricolor
                                : Colors.black26,
                            ),
                          )
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 18,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(Icons.grid_view_outlined, color: Colors.black54, size: 16),
                            SizedBox(width: 2),
                            Text(
                              'K',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    // sharedController.isSidebarCollapsed.value
                    //   ? SizedBox.shrink()
                    //   : Container(
                    //     margin: EdgeInsets.symmetric(vertical: 10),
                    //     height: 1,
                    //     width: double.infinity,
                    //     color: Colors.black12,
                    //   ),
                    sharedController.isSidebarCollapsed.value
                      ? SizedBox(height: 15)
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Control Panel',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(height: 10)
                        ]
                      ),
                    Sidenav(
                      icon: Icons.public,
                      label: 'Zones',
                      withDrop: true,
                      hoverTrailing: [
                        Text(
                          'Alt',
                          style: TextStyle(fontSize: 10, color: Colors.black38),
                        ),
                        Icon(Icons.arrow_upward_outlined, color: Colors.black38, size: 10),
                        Text('Q', style: TextStyle(fontSize: 10, color: Colors.black38)),
                      ],
                      dropdownItems: [
                        DropdownItem(
                          label: 'Group List',
                          id: 'gl', 
                          onTap: (){
                            setState(() {
                              dropdown = true;
                              _selectedPageIndex = 0;
                              selectedDropdownIndex = 0;
                            });
                          }
                        ),
                        DropdownItem(
                          label: 'Report an Incident',
                          id: 'ri', 
                          onTap: (){
                            setState(() {
                              dropdown = true;
                              _selectedPageIndex = 0;
                              selectedDropdownIndex = 1;
                            });
                          }
                        ),
                        DropdownItem(
                          label: 'Mark an Safe Place', 
                          id: 'msp', 
                          onTap: (){
                            setState(() {
                              dropdown = true;
                              _selectedPageIndex = 0;
                              selectedDropdownIndex = 2;
                            });
                          }
                        ),
                      ],
                      onTap: (){
                        setState(() {
                          dropdown = false;
                          _selectedPageIndex = 0;
                        });
                      },
                    ),
                    Sidenav(
                      icon: Icons.dashboard_outlined,
                      label: 'Dashboard',
                      hoverTrailing: [
                        Text(
                          'Alt',
                          style: TextStyle(fontSize: 10, color: Colors.black38),
                        ),
                        Icon(Icons.arrow_upward_outlined, color: Colors.black38, size: 10),
                        Text('A', style: TextStyle(fontSize: 10, color: Colors.black38)),
                      ],
                      onTap: (){
                        setState(() {
                          dropdown = false;
                          _selectedPageIndex = 1;
                        });
                      },
                    ),
                    sharedController.isSidebarCollapsed.value
                      ? Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 1,
                        width: double.infinity,
                        color: Colors.black12,
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'User Preference',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(height: 10)
                        ]
                      ),
                    Sidenav(
                      icon: Icons.private_connectivity_outlined,
                      label: 'Privacy and Security',
                      onTap: (){
                        setState(() {
                          _selectedPageIndex = 2; // this is now correct
                        });
                      },
                    ),
                    Sidenav(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      withDrop: true,
                      hoverTrailing: [
                        Text(
                          'Alt',
                          style: TextStyle(fontSize: 10, color: Colors.black38),
                        ),
                        Icon(Icons.arrow_upward_outlined, color: Colors.black38, size: 10),
                        Text('S', style: TextStyle(fontSize: 10, color: Colors.black38)),
                      ],
                      dropdownItems: [
                        DropdownItem(
                          label: 'Privacy and Security',
                          id: 'privacy_security', 
                          onTap: () => print('Controls')
                        ),
                        DropdownItem(
                          label: 'Permission Controls',
                          id: 'permission_controls',
                          onTap: () => print('Controls')
                        ),
                        DropdownItem(
                          label: 'Local Data Storage Options', 
                          id: 'ldso', 
                          onTap: () => print('Security')
                        ),
                      ],
                    ),
                    sharedController.isSidebarCollapsed.value
                      ? Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 1,
                        width: double.infinity,
                        color: Colors.black12,
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Communication & Alerts',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(height: 10)
                        ]
                      ),
                    Sidenav(
                      icon: Icons.notifications_outlined,
                      label: 'Notification',
                      hoverTrailing: [
                        Text(
                          'Alt',
                          style: TextStyle(fontSize: 10, color: Colors.black38),
                        ),
                        Icon(Icons.arrow_upward_outlined, color: Colors.black38, size: 10),
                        Text(
                          'W',
                          style: TextStyle(fontSize: 10, color: Colors.black38),
                        ),
                      ],
                      onTap: () {
                        setState(() {
                          dropdown = false;
                          if (selectedComs == 0) {
                            showit = !showit; 
                          } else {
                            showit = true;
                          }
                          selectedComs = 0;
                        });
                      },
                    ),
                    Sidenav(
                      icon: Icons.phone_outlined,
                      label: 'Contact',
                      onTap: () {
                        setState(() {
                          dropdown = false;
                          if (selectedComs == 1) {
                            showit = !showit;
                          } else {
                            showit = true;
                          }
                          selectedComs = 1;
                        });
                      },
                    ),
                    sharedController.isSidebarCollapsed.value
                      ? Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 1,
                        width: double.infinity,
                        color: Colors.black12,
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Help & Support Hub',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(height: 10)
                        ]
                      ),
                    Sidenav(
                      icon: Icons.help_outline_outlined,
                      label: 'Help Center',
                      hoverTrailing: [
                        Text(
                          'Shift',
                          style: TextStyle(fontSize: 10, color: Colors.black38),
                        ),
                        Icon(Icons.arrow_upward_outlined, color: Colors.black38, size: 10),
                        Text('H', style: TextStyle(fontSize: 10, color: Colors.black38)),
                      ],
                      onTap: (){
                        setState(() {
                          dropdown = false;
                          _selectedPageIndex = 6;
                        });
                      },
                    ),
                    Sidenav(
                      icon: Icons.support_agent,
                      label: 'Chat Support',
                      onTap: (){
                        setState(() {
                          dropdown = false;
                          _selectedPageIndex = 7;
                        });
                      },
                    ),
                    Sidenav(
                      icon: Icons.source_outlined,
                      label: 'Safety Tips & Resources',
                      onTap: (){
                        setState(() {
                          dropdown = false;
                          _selectedPageIndex = 8;
                        });
                      },
                    ),
                  ]
                )
              ],
            )
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color:  const Color.fromARGB(255, 250, 250, 250),
        padding: EdgeInsets.only(
          left: 10
        ),
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
                child: _getSelectedPage()
              )
            )
          ],
        ),
      ),
    );
  }
}