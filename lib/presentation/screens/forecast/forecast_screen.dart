import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class ForecastScreen extends StatelessWidget {
	const ForecastScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Prepal Forecast'),
			),
			body: SingleChildScrollView(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						// Bar Chart
						Card(
							elevation: 2,
							shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
							child: Padding(
								padding: const EdgeInsets.all(16.0),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											"7-days Demand Forecast",
											style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
										),
										SizedBox(height: 12),
										SizedBox(
											height: 180,
											child: BarChart(
												BarChartData(
													barGroups: [
														BarChartGroupData(x: 0, barRods: [
															BarChartRodData(toY: 80, color: Colors.orange, width: 12),
															BarChartRodData(toY: 70, color: Colors.red, width: 12),
														]),
														BarChartGroupData(x: 1, barRods: [
															BarChartRodData(toY: 90, color: Colors.orange, width: 12),
															BarChartRodData(toY: 60, color: Colors.red, width: 12),
														]),
														BarChartGroupData(x: 2, barRods: [
															BarChartRodData(toY: 120, color: Colors.orange, width: 12),
															BarChartRodData(toY: 100, color: Colors.red, width: 12),
														]),
														BarChartGroupData(x: 3, barRods: [
															BarChartRodData(toY: 100, color: Colors.orange, width: 12),
															BarChartRodData(toY: 90, color: Colors.red, width: 12),
														]),
														BarChartGroupData(x: 4, barRods: [
															BarChartRodData(toY: 110, color: Colors.orange, width: 12),
															BarChartRodData(toY: 80, color: Colors.red, width: 12),
														]),
														BarChartGroupData(x: 5, barRods: [
															BarChartRodData(toY: 130, color: Colors.orange, width: 12),
															BarChartRodData(toY: 120, color: Colors.red, width: 12),
														]),
														BarChartGroupData(x: 6, barRods: [
															BarChartRodData(toY: 160, color: Colors.orange, width: 12),
															BarChartRodData(toY: 140, color: Colors.red, width: 12),
														]),
													],
													titlesData: FlTitlesData(
														leftTitles: AxisTitles(
															sideTitles: SideTitles(showTitles: true, reservedSize: 28),
														),
														bottomTitles: AxisTitles(
															sideTitles: SideTitles(
																showTitles: true,
																getTitlesWidget: (value, meta) {
																	const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
																	if (value >= 0 && value < days.length) {
																		return Padding(
																			padding: EdgeInsets.only(top: 8),
																			child: Text(days[value.toInt()]),
																		);
																	}
																	return Text('');
																},
																reservedSize: 32,
															),
														),
													),
													gridData: FlGridData(show: true),
													borderData: FlBorderData(show: false),
													groupsSpace: 16,
												),
											),
										),
									],
								),
							),
						),
						SizedBox(height: 16),
						// Insight
						Card(
							color: Color(0xFFFFF3E0),
							shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
							child: Padding(
								padding: const EdgeInsets.all(16.0),
								child: Row(
									children: [
										Icon(Icons.insights, color: Colors.orange),
										SizedBox(width: 12),
										Expanded(
											child: Text(
												'AI Insight: Weekend demand expected to increase by 15% due to weather/rush!',
												style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
											),
										),
									],
								),
							),
						),
						SizedBox(height: 16),
						// Forecast Accuracy
						Card(
							color: Color(0xFFFFEBEE),
							shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
							child: Padding(
								padding: const EdgeInsets.all(16.0),
								child: Row(
									children: [
										Expanded(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text('Forecast Accuracy', style: TextStyle(fontWeight: FontWeight.bold)),
													SizedBox(height: 8),
													Text('73.9%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red)),
													Text('Last 30 days', style: TextStyle(fontSize: 12)),
												],
											),
										),
										Icon(Icons.trending_up, color: Colors.red, size: 32),
									],
								),
							),
						),
						SizedBox(height: 16),
						// Demand forecast per item
						Text('Demand forecast per item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
						SizedBox(height: 8),
						_forecastItem(context, 'Mega meat pie', 'assets/images/meat_pie.png', -4.4, 52, 60),
						_forecastItem(context, 'Jollof rice', 'assets/images/jollof_rice.png', 10, 75, 60),
						_forecastItem(context, 'Spaghetti', 'assets/images/spaghetti.png', -4.4, 58, 60),
						_forecastItem(context, 'Chicken', 'assets/images/chicken.png', -5.7, 34, 55),
					],
				),
			),
		);
	}

	Widget _forecastItem(BuildContext context, String name, String imagePath, double change, int today, int yesterday) {
		final isPositive = change > 0;
		return Card(
			margin: EdgeInsets.symmetric(vertical: 6),
			child: ListTile(
				leading: CircleAvatar(
					backgroundImage: AssetImage(imagePath),
					backgroundColor: Colors.grey[100],
				),
				title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
				subtitle: Row(
					children: [
						Text('Today: $today', style: TextStyle(fontSize: 12)),
						SizedBox(width: 8),
						Text('Yesterday: $yesterday', style: TextStyle(fontSize: 12)),
					],
				),
				trailing: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.end,
					children: [
						Text(
							(isPositive ? '+' : '') + change.toStringAsFixed(1) + '%',
							style: TextStyle(
								color: isPositive ? Colors.green : Colors.red,
								fontWeight: FontWeight.bold,
								fontSize: 16,
							),
						),
						Icon(
							isPositive ? Icons.trending_up : Icons.trending_down,
							color: isPositive ? Colors.green : Colors.red,
							size: 18,
						),
					],
				),
			),
		);
	}
}
