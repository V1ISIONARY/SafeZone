import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:safezone/frontend/widgets/reports_card.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class ReportsHistory extends StatefulWidget {
  const ReportsHistory({super.key});

  @override
  State<ReportsHistory> createState() => _ReportsHistoryState();
}

class _ReportsHistoryState extends State<ReportsHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Reports History"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  const Flexible(
                    child: Text(
                      'View and track the status of all your past reports.',
                      style: TextStyle(fontSize: 15, color: textColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Image.asset(
                      "lib/resources/svg/check.png",
                      width: 44,
                      height: 44,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Slidable(
                // startActionPane:
                //     ActionPane(motion: const DrawerMotion(), children: [
                //   SlidableAction(
                //     onPressed: ((context) {
                //       // do something
                //     }),
                //     icon: Icons.phone,
                //   )
                // ]),
                endActionPane:
                    ActionPane(motion: const DrawerMotion(), children: [
                  SlidableAction(
                    onPressed: ((context) {
                      // do something
                    }),
                    icon: Icons.delete,
                    foregroundColor: Colors.white,
                    // backgroundColor: dangerStatusColor,
                  )
                ]),
                child: const ReportsCard(
                    status: "Verified - Danger Zone",
                    location:
                        "28WV+R2R, Arellano St, Downtown District, Dagupan, 2400 Pangasinan",
                    timeAndDate: "December 17, 2024 || 1:48 pm"),
              ),
              const ReportsCard(
                  status: "Verified - Danger Zone",
                  location:
                      "28WV+R2R, Arellano St, Downtown District, Dagupan, 2400 Pangasinan",
                  timeAndDate: "December 17, 2024 || 1:48 pm")
            ],
          ),
        ),
      ),
    );
  }
}
