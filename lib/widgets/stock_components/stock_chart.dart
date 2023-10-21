import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockChart extends StatefulWidget {
  final List<FlSpot> data;

  const StockChart({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  @override
  Widget build(BuildContext context) {
    final bool isPositiveGrowth = widget.data.last.y > widget.data.first.y; // Check if growth is positive

    final LinearGradient gradient = LinearGradient(
      colors: isPositiveGrowth
          ? [Colors.green, Colors.green.withOpacity(0.5)]
          : [Colors.red, Colors.red.withOpacity(0.5)],
    );

    return Container(
      height: 200.0,
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300]!,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: const FlTitlesData(show: true),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          minX: widget.data.first.x, 
          maxX: widget.data.last.x,
          minY: widget.data.first.y, 
          maxY: widget.data.last.y, 
          lineBarsData: [
            LineChartBarData(
              spots: widget.data,
              isCurved: true,
              gradient: gradient, 
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: gradient, 
              ),
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) => true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
