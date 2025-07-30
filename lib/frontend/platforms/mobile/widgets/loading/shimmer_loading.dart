import 'package:flutter/material.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox(
      {super.key,
      required this.flex,
      required this.widthFactor,
      required this.color});

  final double flex;
  final double widthFactor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 13 * flex.toDouble(),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// for notifs

class ShimmerHistoryLoading extends StatelessWidget {
  const ShimmerHistoryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(
                flex: 1,
                widthFactor: 0.7,
                color: Color.fromARGB(255, 247, 247, 247),
              ),
              SizedBox(height: 10),
              ShimmerBox(
                  flex: 1,
                  widthFactor: 0.5,
                  color: Color.fromARGB(255, 247, 247, 247)),
              SizedBox(height: 10),
              ShimmerBox(
                  flex: 1,
                  widthFactor: 0.4,
                  color: Color.fromARGB(255, 247, 247, 247)),
            ],
          ),
        );
      },
    );
  }
}

// notifs

class ShimmerNotificationCard extends StatelessWidget {
  const ShimmerNotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(10, 0, 0, 0),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Circle shimmer icon with static bell icon inside
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.notifications,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            // Text shimmer lines
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6),
                  ShimmerBox(flex: 1, widthFactor: 0.5, color: Colors.white),
                  SizedBox(height: 6),
                  ShimmerBox(flex: 1, widthFactor: 0.8, color: Colors.white),
                  SizedBox(height: 6),
                  ShimmerBox(flex: 1, widthFactor: 0.3, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// for contacts

class ShimmerContactsLoading extends StatelessWidget {
  const ShimmerContactsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: 9,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: Divider(
          thickness: 0.6,
          color: Color.fromARGB(50, 0, 0, 0), // subtle line
        ),
      ),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(9, 248, 248, 248),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(
                flex: 0.7,
                widthFactor: 0.5,
                color: Color.fromARGB(171, 201, 201, 201),
              ),
              SizedBox(height: 8),
              ShimmerBox(
                flex: 0.7,
                widthFactor: 0.3,
                color: Color.fromARGB(160, 233, 233, 233),
              ),
            ],
          ),
        );
      },
    );
  }
}
