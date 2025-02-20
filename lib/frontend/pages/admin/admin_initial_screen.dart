import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';
import '../../../resources/schema/texts.dart';
import '../../widgets/buttons/percentage_average.dart';

class AdminInitialScreen extends StatefulWidget {
  final int? initialPage;
  const AdminInitialScreen({super.key, this.initialPage});

  @override
  State<AdminInitialScreen> createState() => _AdminInitialScreenState();
}

class _AdminInitialScreenState extends State<AdminInitialScreen> {
  String selectedCategory = 'Monthly';
  final Map<String, List<FlSpot>> graphData = {
    'Monthly': [
      const FlSpot(0, 5),
      const FlSpot(1, 8),
      const FlSpot(2, 6),
      const FlSpot(3, 10),
      const FlSpot(4, 7),
      const FlSpot(5, 9),
      const FlSpot(6, 4),
    ],
    'Weekly': [
      const FlSpot(0, 3),
      const FlSpot(1, 7),
      const FlSpot(2, 5),
      const FlSpot(3, 9),
      const FlSpot(4, 6),
      const FlSpot(5, 8),
      const FlSpot(6, 3),
    ],
    'Today': [
      const FlSpot(0, 1),
      const FlSpot(1, 3),
      const FlSpot(2, 2),
      const FlSpot(3, 4),
      const FlSpot(4, 5),
      const FlSpot(5, 7),
      const FlSpot(6, 2),
    ],
  };

  void _updateGraph(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (value % 1 != 0 || value < 0 || value >= days.length) return Container();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        days[value.toInt()],
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value.toInt()}',
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategoryText(text: 'Reports'),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Monthly', 'Weekly', 'Today'].map((category) {
                      return GestureDetector(
                        onTap: () => _updateGraph(category),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: selectedCategory == category
                                  ? FontWeight.w500
                                  : FontWeight.w300,
                              color: selectedCategory == category
                                  ? widgetPricolor
                                  : Colors.black38,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(10, 0, 0, 0),
                  ),
                  padding:
                      const EdgeInsets.only(right: 20, top: 20, bottom: 15),
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: _leftTitleWidgets,
                            reservedSize: 25,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: _bottomTitleWidgets,
                            reservedSize: 22,
                            interval: 1,
                          ),
                        ),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: graphData[selectedCategory]!,
                          isCurved: true,
                          color: widgetPricolor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Expanded(
                    child:
                        PercentageAverage(count: 236, title: 'Total Reports')),
                const SizedBox(width: 10),
                Expanded(
                    child:
                        PercentageAverage(count: 236, title: 'Total Reviews')),
              ],
            ),
          ),
          Column(
            children: [
              PercentageAverage(count: 236, title: 'Total Rejects'),
              PercentageAverage(count: 236, title: 'Total Verify'),
            ],
          ),
        ],
      ),
    );
  }
}
