import 'package:decibel_monitor/src/features/decibel/view_models/decibel_view_model.dart';
import 'package:decibel_monitor/src/features/settings/routes/setting_routes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DecibelView extends StatefulWidget {
  final DecibelViewModel decibelViewModel;

  const DecibelView({super.key, required this.decibelViewModel});

  @override
  State<DecibelView> createState() => _DecibelViewState();
}

class _DecibelViewState extends State<DecibelView> {
  @override
  void initState() {
    super.initState();
    widget.decibelViewModel.startListening();
  }

  @override
  void dispose() {
    widget.decibelViewModel.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Decibel Monitor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push(SettingRoutes.setting);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListenableBuilder(
              listenable: widget.decibelViewModel,
              builder: (context, child) {
                return Text(
                  '${widget.decibelViewModel.decibelModel.currentValue.toStringAsFixed(2)} dB',
                  style: const TextStyle(fontSize: 32),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.decibelViewModel,
                builder: (context, child) {
                  final recentHistory = _getRecentHistory(
                    widget.decibelViewModel.decibelModel.history,
                    maxPoints: 20,
                  );
                  return LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 2,
                          spots: _generateSpots(recentHistory),
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                      minX: 0,
                      maxX: recentHistory.length.toDouble(),
                      minY: recentHistory.isNotEmpty
                          ? recentHistory.reduce((a, b) => a < b ? a : b) - 10
                          : 0,
                      maxY: recentHistory.isNotEmpty
                          ? recentHistory.reduce((a, b) => a > b ? a : b) + 10
                          : 50,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<double> _getRecentHistory(List<double> history, {int maxPoints = 20}) {
    if (history.length <= maxPoints) {
      return history;
    }
    return history.sublist(history.length - maxPoints);
  }

  List<FlSpot> _generateSpots(List<double> history) {
    return List.generate(
      history.length,
      (index) => FlSpot(index.toDouble(), history[index]),
    );
  }
}
