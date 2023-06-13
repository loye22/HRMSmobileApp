import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DonutChartWidget extends StatefulWidget {
  final double totalDays;
  final double usedDays;
  final Color color;
  final String txt;

  const DonutChartWidget({
    Key? key,
    required this.totalDays,
    required this.usedDays,
    required this.color,
    required this.txt,
  }) : super(key: key);

  @override
  _DonutChartWidgetState createState() => _DonutChartWidgetState();
}

class _DonutChartWidgetState extends State<DonutChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfCircularChart(

          series: <CircularSeries>[
            DoughnutSeries<ChartSampleData, String>(

              dataSource: <ChartSampleData>[
                ChartSampleData('Used Days', widget.usedDays ,Colors.red),
                ChartSampleData(
                    'Remaining Days', widget.totalDays - widget.usedDays , Colors.blue),
              ],
              pointColorMapper: (ChartSampleData data, _) => data.color,
              xValueMapper: (ChartSampleData data, _) => data.x,
              yValueMapper: (ChartSampleData data, _) => data.y,
              radius: '80%',
              innerRadius: '70%',
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.inside,
                textStyle: TextStyle(color: Colors.white),
              ),
            )
          ],
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(

              widget: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*Text(
                      widget.txt ,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.color),
                    ),*/
                    SizedBox(height: 4),
                    Text(
                      '${(widget.usedDays / widget.totalDays * 100).toStringAsFixed(0)}% Used',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(" Total days${this.widget.totalDays.toString()}")
                  ],
                ),
              ),
            ),
          ],
        ),
        Text(
          widget.txt,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: widget.color),
        ),
      ],
    );
  }
}

class ChartSampleData {
  ChartSampleData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
