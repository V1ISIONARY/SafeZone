import 'package:flutter/widgets.dart';
import 'package:safezone/backend/properties/import.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/settings/locationservice.dart';

class Privacy extends StatefulWidget {
  final VoidCallback? onClose;
  const Privacy({this.onClose, super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool isActive = false;
  bool isPrivate = false;

  String? selectedInternalPage;

  @override
  Widget build(BuildContext context) {
    return _getPageForNavigation(selectedInternalPage);
  }

  Widget _getPageForNavigation(String? page) {
    switch (page) {
      case "details":
        return Locationservice(
          onBack: () {
            setState(() {
              selectedInternalPage = null;
            });
          },
        );
      default:
       return Scaffold(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Transform.translate(
                offset: const Offset(0, 0),
                child: const CategoryText(text: "Privacy")),
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
                )
              ),
              SizedBox(width: 10)
            ],
          ),
          body: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: ListView(children: [
                const Text(
                  "Discoverability",
                  style: TextStyle(color: Colors.black38, fontSize: 11),
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 250, 250, 250),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPrivate = !isPrivate;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          margin: const EdgeInsets.only(
                              bottom: 30, right: 10, left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Private account",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "With a private acccount, other user cannot view your account. Your existing followers won't be affected.",
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 9),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: 20,
                                    width: 35,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: BoxDecoration(
                                      color: isPrivate
                                          ? widgetPricolor
                                          : Colors.black26,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: AnimatedAlign(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      alignment: isPrivate
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        height: 16,
                                        width: 16,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              spreadRadius: 0.5,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              isActive = !isActive;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(
                                bottom: 30, right: 10, left: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Location status",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "When this is turned on, you and your group friends will see each other's activity status. You will see each other's activity status only when both of you turn this on.",
                                        style: TextStyle(
                                            color: Colors.black45, fontSize: 9),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      height: 20,
                                      width: 35,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? Colors.green.shade300
                                            : Colors.black26,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: AnimatedAlign(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        alignment: isActive
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          height: 16,
                                          width: 16,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                spreadRadius: 0.5,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedInternalPage = "details";
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(right: 10, left: 10),
                            color: Colors.transparent,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Location Service",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Manage the location information Safezone uses to personalize your experience",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      child: Container(
                                        height: 15,
                                        width: 15,
                                        margin:
                                            const EdgeInsets.only(right: 17),
                                        child: Icon(
                                          Icons.chevron_right_outlined,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Text(
                //   "Content & Display",
                //   style: TextStyle(
                //     color: Colors.black38,
                //     fontSize: 11
                //   ),
                // ),
                // Container(
                //   width: double.infinity,
                //   padding: EdgeInsets.symmetric(
                //     vertical: 20,
                //     horizontal: 20
                //   ),
                //   margin: EdgeInsets.symmetric(
                //     vertical: 10
                //   ),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(10)
                //   ),
                //   child: Text(
                //     "Notifications",
                //     style: TextStyle(
                //       fontSize: 12,
                //       color: Colors.black,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                // ),
              ]),
            )
          )
        );
    }
  }

}
