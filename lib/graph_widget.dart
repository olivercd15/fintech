//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class GraphWidget extends StatefulWidget {
  final List<double> data;

  const GraphWidget({Key key, this.data}) : super(key: key);
  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  

  _onSelectionChanged(SelectionModel model){
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};

    if(selectedDatum.isNotEmpty){
      time = selectedDatum.first.datum;
      selectedDatum.forEach((SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum;
      });
    }

    print(time);
    print(measures);
  }

  @override
  Widget build(BuildContext context) {
    List<Series<double, num>> series = [
      Series<double, int>(
        id: 'Gasto',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (value, index) => index,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 4,
      )
    ];
    
    return LineChart(series,
      animate: false,
      selectionModels: [
        SelectionModelConfig(
          type: SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      domainAxis: NumericAxisSpec(
        tickProviderSpec: StaticNumericTickProviderSpec(
          [
            TickSpec(0, label: '01'),
            TickSpec(4, label: '05'),
            TickSpec(9, label: '10'),
            TickSpec(14, label: '15'),
            TickSpec(19, label: '20'),
            TickSpec(24, label: '25'),
            TickSpec(29, label: '30'),
          ]
        )
      ),
      primaryMeasureAxis: NumericAxisSpec(
        tickProviderSpec: BasicNumericTickProviderSpec(
          desiredTickCount: 4,
        ),
      ),
    );
  }
}