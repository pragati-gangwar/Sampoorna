import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class HealthReportView extends StatefulWidget {
  const HealthReportView({super.key});

  @override
  State<HealthReportView> createState() => _HealthReportViewState();
}

class _HealthReportViewState extends State<HealthReportView> {
  late Future<Map<String, int>> futureMoodCounts;

  @override
  void initState() {
    super.initState();
    futureMoodCounts = fetchMoodCounts();
  }

  Future<Map<String, int>> fetchMoodCounts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('moods')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    final moodCounts = <String, int>{};
    for (final doc in querySnapshot.docs) {
      final mood = doc.get('mood');
      if (!moodCounts.containsKey(mood)) {
        moodCounts[mood] = 1;
      } else {
        moodCounts[mood] = moodCounts[mood]! + 1;
      }
    }
    return moodCounts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: FutureBuilder<Map<String, int>>(
            future: futureMoodCounts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Expanded(
                  child: PieChart(
                    dataMap: snapshot.data!
                        .map((key, value) => MapEntry(key, value.toDouble())),
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 2,
                    colorList: const [
                      Colors.green,
                      Colors.red,
                      Colors.blue,
                      Colors.orange,
                      Colors.purple
                    ], // Provide your color list here
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 22,
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendTextStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      chartValueBackgroundColor: Colors.white,
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,
                    ),
                  ),
                );
              }
            },
          )),
    );
  }
}