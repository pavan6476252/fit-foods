import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'new_remainder.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
 ScrollController _dateScrollControler = ScrollController();
  @override
  Widget build(BuildContext context) {
    final dates = <Widget>[];

    for (int i = 0; i < 30; i++) {
      final date = _currentDate.add(Duration(days: i));
      dates.add(Card(
        child: Container(
          width: 70,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(_monthFormatter.format(date)),
              i == 0
                  ? CircleAvatar(
                      maxRadius: 15, child: Text(_dayFormatter.format(date)))
                  : Text(_dayFormatter.format(date)),
              Text(DateFormat('EEEE').format(date).substring(0, 3)),
            ],
          ),
        ),
      ));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Your Medicine \nRemainder",
            style: TextStyle(fontSize: 25),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  addNewRemainderPage()));
                },
                icon: const Icon(Icons.add_alert))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Scrollbar(
                controller: _dateScrollControler,
                thumbVisibility: true,
                interactive: true,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10,top: 10),
                  height: 100,
                  width: double.maxFinite,
                  child: ListView(
                    controller: _dateScrollControler,
                    scrollDirection: Axis.horizontal,
                    children:
                        dates.map((widget) => Expanded(child: widget)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
