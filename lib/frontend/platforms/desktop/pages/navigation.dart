import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safezone/backend/properties/properties.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/contact.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/dashboard/admin_dangerzones.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/dashboard/admin_initial_screen.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/dashboard/admin_reports.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/dashboard/admin_safezones.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/dashboard/admin_users.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/dashboard/main_analytics.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/content/createreport.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/content/listofgroup.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/content/marksafezone.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/map.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/mapheader.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/notification.dart';
import 'package:safezone/frontend/platforms/desktop/widget/button/sidenav.dart';
import 'package:safezone/resource/schema/colors.dart';

class NavigationDT extends StatefulWidget {
  final String userToken;
  const NavigationDT({super.key, required this.userToken});

  @override
  State<NavigationDT> createState() => _NavigationDTState();
}

class _NavigationDTState extends State<NavigationDT> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedDropdownIndex = 0;
  int _selectedPageIndex = 0;
  double topHeight = 300;
  int selectedComs = 0;

  bool showit = false;
  bool dropdown = false;
  bool? _wasSmallScreen;
  final sharedController = SharedProperties();

  ValueNotifier<String?> selectedPageNotifier = ValueNotifier(null);

  Widget _getSelectedPage() {
    Widget pageContent;

    switch (_selectedPageIndex) {
      case 0:
        pageContent = MapDT(UserToken: widget.userToken);
        break;
      case 1:
        pageContent = AdminInitialScreen();
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

    Widget getComsPage() {
      switch (selectedComs) {
        case 0:
          return NotificationDT(
            initialPage: 0,
            selectedPage: selectedPageNotifier,
            key: ValueKey(selectedPageNotifier.value),
            onClose: () {
              setState(() {
                showit = false;
                selectedPageNotifier.value = null;
                Sidenav.selectedComsNotifier.value = null;
              });
            },
            UserToken: widget.userToken,
          );
        case 1:
          return ContactDT(
            UserToken: widget.userToken,
            onClose: () {
              setState(() {
                showit = false;
                Sidenav.selectedComsNotifier.value = null;
              });
            },
          );
        default:
          return const Center(child: Text('No Dropdown Content'));
      }
    }

    Widget getSelectedDropPage() {
      switch (selectedDropdownIndex) {
        case 0:
          return ListOfGroupsDT(
            onClose: () {
              setState(() {
                dropdown = false;
                Sidenav.selectedDropdownId.value = null;
              });
            },
          );
        case 1:
          return CreateReportDT(onClose: () {
            setState(() {
              dropdown = false;
              Sidenav.selectedDropdownId.value = null;
            });
          }, onOpenNotification: (String page) {
            setState(() {
              showit = true;
              selectedComs = 0;
              selectedPageNotifier.value = null;
              Sidenav.selectedComsNotifier.value = 0;
            });

            Future.delayed(const Duration(milliseconds: 10), () {
              selectedPageNotifier.value = page;
            });
          });
        case 2:
          return MarkSafeZoneDT(onClose: () {
            setState(() {
              dropdown = false;
              Sidenav.selectedDropdownId.value = null;
            });
          }, 
          onOpenNotification: (String page) {
            setState(() {
              showit = true;
              selectedComs = 0;
              selectedPageNotifier.value = null;
              Sidenav.selectedComsNotifier.value = 0;
            });

            Future.delayed(const Duration(milliseconds: 10), () {
              selectedPageNotifier.value = page;
            });
          });
        case 3:
          return AdminReportsUsers();
        case 4: 
          return AdminSafezones();
        case 5: 
          return AdminDangerzones();
        case 6: 
          return AdminReports();
        default:
          return const Center(child: Text('No Dropdown Content'));
      }
    }

    return Column(
      children: [
        if (_selectedPageIndex == 0) const MapHeader(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double pageContentWidth = constraints.maxWidth;
              final bool isInSplitMode =
                  showit && dropdown && pageContentWidth <= 1220;
              return Row(
                children: [
                  if (showit && isInSplitMode)
                    Container(
                      width: 400,
                      height: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            height: topHeight,
                            width: double.infinity,
                            color: Colors.transparent,
                            child: getComsPage(),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onPanUpdate: (details) {
                              setState(() {
                                topHeight += details.delta.dy;
                                topHeight = topHeight.clamp(
                                    150.0, constraints.maxHeight - 300);
                              });
                            },
                            child: Container(
                              height: 10,
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              color: btnColor.withOpacity(0.5),
                              child: const Center(
                                child: Icon(Icons.drag_handle,
                                    size: 10, color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              child: getSelectedDropPage(),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (showit && !isInSplitMode)
                    Container(
                      width: 350,
                      height: double.infinity,
                      color: Colors.white,
                      child: getComsPage(),
                    ),
                  Expanded(child: pageContent),
                  if (dropdown && !isInSplitMode)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 400,
                        color: Colors.white,
                        child: getSelectedDropPage(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return ValueListenableBuilder<bool>(
        valueListenable: sharedController.isSidebarCollapsed,
        builder: (context, isCollapsed, child) {
          return SizedBox(
              width: isCollapsed ? 40 : 240,
              height: double.infinity,
              child: LayoutBuilder(builder: (context, constraints) {
                return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false,
                    ),
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.only(right: 9),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight),
                            child: IntrinsicHeight(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 13),
                                SizedBox(
                                  height: 30,
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: btnColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Center(
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
                                        visible: !sharedController
                                            .isSidebarCollapsed.value,
                                        child: const SizedBox(width: 10),
                                      ),
                                      Visibility(
                                        visible: !sharedController
                                            .isSidebarCollapsed.value,
                                        child: Expanded(
                                          child: Row(
                                            children: [
                                              const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Ramon',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    'ramonlangpu@gmail.com',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              ValueListenableBuilder(
                                                  valueListenable:
                                                      sharedController
                                                          .isSidebarTabUi,
                                                  builder:
                                                      (context, isVisible, _) {
                                                    return AnimatedSwitcher(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        transitionBuilder:
                                                            (child, animation) =>
                                                                FadeTransition(
                                                                  opacity:
                                                                      animation,
                                                                  child: child,
                                                                ),
                                                        child: Tooltip(
                                                          message: sharedController
                                                                  .isSidebarTabUi
                                                                  .value
                                                              ? 'Close tab'
                                                              : 'Close sidebar',
                                                          preferBelow: false,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          textStyle:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8,
                                                          ),
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              hoverColor: Colors
                                                                  .grey
                                                                  .shade300,
                                                              onTap: () {
                                                                setState(() {
                                                                  if (sharedController
                                                                      .isSidebarTabUi
                                                                      .value) {
                                                                    sharedController
                                                                        .isSidebarTabUi
                                                                        .value = false;
                                                                  } else {
                                                                    sharedController
                                                                            .isSidebarCollapsed
                                                                            .value =
                                                                        !sharedController
                                                                            .isSidebarCollapsed
                                                                            .value;
                                                                  }
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child: sharedController
                                                                        .isSidebarTabUi
                                                                        .value
                                                                    ? const Icon(
                                                                        Icons
                                                                            .cancel_outlined,
                                                                        color: Colors
                                                                            .black45,
                                                                        size:
                                                                            18,
                                                                      )
                                                                    : SvgPicture
                                                                        .asset(
                                                                        'lib/resource/svg/close_sidebar.svg',
                                                                        color: Colors
                                                                            .black45,
                                                                        height:
                                                                            18,
                                                                        width:
                                                                            18,
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                        ));
                                                  })
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                sharedController.isSidebarCollapsed.value
                                    ? const SizedBox.shrink()
                                    : Container(
                                        height: 33,
                                        margin: const EdgeInsets.only(
                                            top: 15, bottom: 10),
                                        child: TextField(
                                          cursorColor: labelFormFieldColor,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w100,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Search",
                                            hintStyle: const TextStyle(
                                              fontSize: 10,
                                              color: labelFormFieldColor,
                                              fontWeight: FontWeight.w100,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.black12),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.black12,
                                                  width: 2),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: widgetPricolor,
                                                  width: 2),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: -5,
                                                    top: 12,
                                                    bottom: 12),
                                            prefixIcon: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0,
                                                    right:
                                                        5), // Remove extra padding
                                                child: Transform.translate(
                                                  offset: const Offset(5, 0),
                                                  child: Icon(
                                                    Icons.search,
                                                    size: 18,
                                                    color: sharedController
                                                            .emailController
                                                            .text
                                                            .isNotEmpty
                                                        ? widgetPricolor
                                                        : Colors.black26,
                                                  ),
                                                )),
                                            prefixIconConstraints:
                                                const BoxConstraints(
                                              minWidth: 28,
                                              minHeight: 18,
                                            ),
                                            suffixIcon: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(Icons.grid_view_outlined,
                                                    color: Colors.black54,
                                                    size: 16),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          ? const SizedBox(height: 15)
                                          : const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                  Text(
                                                    'Control Panel',
                                                    style: TextStyle(
                                                      color: Colors.black38,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10)
                                                ]),
                                      Sidenav(
                                        icon: Icons.public,
                                        label: 'Zones',
                                        withDrop: true,
                                        hoverTrailing: const [
                                          Text(
                                            'Alt',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black38),
                                          ),
                                          Icon(Icons.arrow_upward_outlined,
                                              color: Colors.black38, size: 10),
                                          Text('Q',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black38)),
                                        ],
                                        dropdownItems: [
                                          DropdownItem(
                                            label: 'Group List',
                                            id: 'gl',
                                            onTap: () {
                                              setState(() {
                                                if (selectedDropdownIndex ==
                                                    0) {
                                                  dropdown = !dropdown;
                                                } else {
                                                  dropdown = true;
                                                  selectedDropdownIndex = 0;
                                                }
                                                _selectedPageIndex = 0;
                                              });
                                            },
                                          ),
                                          DropdownItem(
                                            label: 'Report an Incident',
                                            id: 'ri',
                                            onTap: () {
                                              setState(() {
                                                if (selectedDropdownIndex ==
                                                    1) {
                                                  dropdown = !dropdown;
                                                } else {
                                                  dropdown = true;
                                                  selectedDropdownIndex = 1;
                                                }
                                                _selectedPageIndex = 0;
                                              });
                                            },
                                          ),
                                          DropdownItem(
                                            label: 'Mark a Safe Place',
                                            id: 'msp',
                                            onTap: () {
                                              setState(() {
                                                if (selectedDropdownIndex ==
                                                    2) {
                                                  dropdown = !dropdown;
                                                } else {
                                                  dropdown = true;
                                                  selectedDropdownIndex = 2;
                                                }
                                                _selectedPageIndex = 0;
                                              });
                                            },
                                          ),
                                        ],
                                        onTap: () {
                                          setState(() {
                                            dropdown = false;
                                            _selectedPageIndex = 0;
                                          });
                                        },
                                      ),
                                      Sidenav(
                                        icon: Icons.dashboard_outlined,
                                        label: 'Dashboard',
                                        withDrop: true,
                                        hoverTrailing: const [
                                          Text(
                                            'Alt',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black38),
                                          ),
                                          Icon(Icons.arrow_upward_outlined,
                                              color: Colors.black38, size: 10),
                                          Text('A',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black38)),
                                        ],
                                        dropdownItems: [
                                          DropdownItem(
                                            label: 'Users',
                                            id: 'us',
                                            onTap: () {
                                              setState(() {
                                                if (selectedDropdownIndex == 3) {
                                                  dropdown = !dropdown;
                                                } else {
                                                  dropdown = true;
                                                  selectedDropdownIndex = 3;
                                                }
                                                _selectedPageIndex = 1;
                                              });
                                            },
                                          ),
                                          DropdownItem(
                                            label: 'Safe Zones',
                                            id: 'sz',
                                            onTap: () {
                                              setState(() {
                                                if (selectedDropdownIndex == 4) {
                                                  dropdown = !dropdown;
                                                } else {
                                                  dropdown = true;
                                                  selectedDropdownIndex = 4;
                                                }
                                                _selectedPageIndex = 1;
                                              });
                                            },
                                          ),
                                          DropdownItem(
                                            label: 'Danger Zones',
                                            id: 'dz',
                                            onTap: () {
                                              setState(() {
                                                if (selectedDropdownIndex == 5) {
                                                  dropdown = !dropdown;
                                                } else {
                                                  dropdown = true;
                                                  selectedDropdownIndex = 5;
                                                }
                                                _selectedPageIndex = 1;
                                              });
                                            },
                                          ),
                                        ],
                                        onTap: () {
                                          setState(() {
                                            dropdown = false;
                                            _selectedPageIndex = 1;
                                          });
                                        },
                                      ),
                                      sharedController.isSidebarCollapsed.value
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              height: 1,
                                              width: double.infinity,
                                              color: Colors.black12,
                                            )
                                          : const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                ]),
                                      Sidenav(
                                        icon:
                                            Icons.private_connectivity_outlined,
                                        label: 'Privacy and Security',
                                        onTap: () {
                                          setState(() {
                                            dropdown = false;
                                            _selectedPageIndex = 2;
                                          });
                                        },
                                      ),
                                      Sidenav(
                                        icon: Icons.settings_outlined,
                                        label: 'Settings',
                                        withDrop: true,
                                        hoverTrailing: const [
                                          Text(
                                            'Alt',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black38),
                                          ),
                                          Icon(Icons.arrow_upward_outlined,
                                              color: Colors.black38, size: 10),
                                          Text('S',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black38)),
                                        ],
                                        dropdownItems: [
                                          DropdownItem(
                                              label: 'Privacy and Security',
                                              id: 'privacy_security',
                                              onTap: () => print('Controls')),
                                          DropdownItem(
                                              label: 'Permission Controls',
                                              id: 'permission_controls',
                                              onTap: () => print('Controls')),
                                          DropdownItem(
                                              label:
                                                  'Local Data Storage Options',
                                              id: 'ldso',
                                              onTap: () => print('Security')),
                                        ],
                                      ),
                                      sharedController.isSidebarCollapsed.value
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              height: 1,
                                              width: double.infinity,
                                              color: Colors.black12,
                                            )
                                          : const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                ]),
                                      Sidenav(
                                        icon: Icons.notifications_outlined,
                                        label: 'Notification',
                                        hoverTrailing: const [
                                          Text(
                                            'Alt',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black38),
                                          ),
                                          Icon(Icons.arrow_upward_outlined,
                                              color: Colors.black38, size: 10),
                                          Text(
                                            'W',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black38),
                                          ),
                                        ],
                                        onTap: () {
                                          setState(() {
                                            if (selectedComs == 0) {
                                              showit = !showit;
                                              if (!showit) {
                                                Sidenav.selectedComsNotifier
                                                    .value = null;
                                              } else {
                                                Sidenav.selectedComsNotifier
                                                    .value = 0;
                                              }
                                            } else {
                                              showit = true;
                                              selectedComs = 0;
                                              Sidenav.selectedComsNotifier
                                                  .value = 0;
                                            }
                                          });
                                        },
                                      ),
                                      Sidenav(
                                        icon: Icons.phone_outlined,
                                        label: 'Contact',
                                        onTap: () {
                                          setState(() {
                                            if (selectedComs == 1) {
                                              showit = !showit;
                                              if (!showit) {
                                                Sidenav.selectedComsNotifier
                                                    .value = null;
                                              } else {
                                                Sidenav.selectedComsNotifier
                                                    .value = 1;
                                              }
                                            } else {
                                              showit = true;
                                              selectedComs = 1;
                                              Sidenav.selectedComsNotifier
                                                  .value = 1;
                                            }
                                          });
                                        },
                                      ),
                                      sharedController.isSidebarCollapsed.value
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              height: 1,
                                              width: double.infinity,
                                              color: Colors.black12,
                                            )
                                          : const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                ]),
                                      Sidenav(
                                        icon: Icons.help_outline_outlined,
                                        label: 'Help Center',
                                        hoverTrailing: const [
                                          Text(
                                            'Shift',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black38),
                                          ),
                                          Icon(Icons.arrow_upward_outlined,
                                              color: Colors.black38, size: 10),
                                          Text('H',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black38)),
                                        ],
                                        onTap: () {
                                          setState(() {
                                            dropdown = false;
                                            _selectedPageIndex = 6;
                                          });
                                        },
                                      ),
                                      Sidenav(
                                        icon: Icons.support_agent,
                                        label: 'Chat Support',
                                        onTap: () {
                                          setState(() {
                                            dropdown = false;
                                            _selectedPageIndex = 7;
                                          });
                                        },
                                      ),
                                      Sidenav(
                                        icon: Icons.source_outlined,
                                        label: 'Safety Tips & Resources',
                                        onTap: () {
                                          setState(() {
                                            dropdown = false;
                                            _selectedPageIndex = 8;
                                          });
                                        },
                                      ),
                                    ]),
                                const Spacer(),
                                Container(
                                  height: 200,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              ],
                            )))));
              }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double pageContentWidth = constraints.maxWidth;
        final bool isSmallScreen = pageContentWidth <= 900;

        if (_wasSmallScreen != isSmallScreen) {
          _wasSmallScreen = isSmallScreen;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (isSmallScreen) {
              if (!sharedController.isSidebarTab.value) {
                sharedController.isSidebarTab.value = true;
                if (sharedController.isSidebarCollapsed.value) {
                  sharedController.isSidebarCollapsed.value = false;
                }
              }
            } else {
              if (sharedController.isSidebarTab.value) {
                sharedController.isSidebarTabUi.value = false;
                sharedController.isSidebarTab.value = false;
              }
            }
          });
        }

        return Scaffold(
          key: _scaffoldKey,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(255, 250, 250, 250),
            padding: EdgeInsets.only(
              left: !isSmallScreen ? 10 : 0,
            ),
            child: Row(
              children: [
                if (pageContentWidth > 900) _buildDrawer(),
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: sharedController.isSidebarTabUi,
                      builder: (context, isVisible, _) {
                        return Stack(
                          children: [
                            _getSelectedPage(),
                            if (isSmallScreen)
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                left: isVisible ? 0 : -247,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 247,
                                  height: double.infinity,
                                  padding: const EdgeInsets.only(left: 10),
                                  color:
                                      const Color.fromARGB(250, 250, 250, 250),
                                  child: _buildDrawer(),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
