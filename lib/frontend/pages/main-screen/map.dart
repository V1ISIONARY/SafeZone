// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/bottom_navigation.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 216, 216),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            PreferredSize(
              preferredSize: Size.fromHeight(120.0), 
              child: Container(
                height: 120,
                color: Colors.transparent, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0), 
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30), 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0), 
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white, // Background color
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 10),
                                  child: Icon(
                                    Icons.search, 
                                    color: Colors.grey
                                  )
                                ), // Icon stays visible
                                hintText: "Search", // Placeholder text disappears on typing
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide.none, // No border
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0), // Adjust padding
                              ),
                              style: TextStyle(fontSize: 16), // Style for the typed text
                              onChanged: (text) {
                                // Handle text changes if needed
                              },
                            ),
                          ],
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: Container(
                width: 60,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "lib/resources/svg/connect.svg"
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "lib/resources/svg/dangerzone.svg"
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "lib/resources/svg/safezone.svg"
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget()
    );
  }
}