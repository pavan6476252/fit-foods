import 'package:flutter/material.dart';

class addNewRemainderPage extends StatefulWidget {
  @override
  _addNewRemainderPageState createState() => _addNewRemainderPageState();
}

class _addNewRemainderPageState extends State<addNewRemainderPage> {
  late String _medicineName;
  late String _medicineType;
  List<String> _selectedTimings = [];
  late int _durationInDays = 7;

  final List<Map<String, dynamic>> _medicineTypes = [
    {'name': 'Pills', 'icon': Icons.local_pharmacy},
    {'name': 'Tonic', 'icon': Icons.local_drink},
    {'name': 'Injection', 'icon': Icons.local_hospital},
    {'name': 'Other', 'icon': Icons.miscellaneous_services},
  ];
  String _selectedMedicineType='Other';

  final List<String> _timingOptions = [
    'After Breakfast',
    'After Lunch',
    'After Dinner',
    'Before Bed',
    'Before Eating',
  ];
  final TextStyle _headingStyle =
      const TextStyle(fontSize: 22, fontWeight: FontWeight.w400);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Input'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.medical_information_outlined, size: 150),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Medicine Name',
              ),
              onChanged: (value) {
                setState(() {
                  _medicineName = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 0.4,),

           Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Medicine Type', style: _headingStyle),
    const SizedBox(height: 10),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ..._medicineTypes.map(
          (type) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedMedicineType = type['name'];
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedMedicineType == type['name']
                      ? Colors.blue  // Color to indicate the selected type
                      : Colors.grey[300]!, // Color for unselected types
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Icon(type['icon'], size: 36),
                  const SizedBox(height: 8),
                  Text(type['name']),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ],
),

            const SizedBox(height: 16),
            const Divider(thickness: 0.4,),
             Text('Time & Schedule',style: _headingStyle,),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ..._timingOptions.map(
                  (option) => ChoiceChip(
                    label: Text(option),
                    selected: _selectedTimings.contains(option),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTimings.add(option);
                        } else {
                          _selectedTimings.remove(option);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(thickness: 0.4,),

             Text('Duration',style: _headingStyle,),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _durationInDays,
              onChanged: (value) {
                setState(() {
                  _durationInDays = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: 7, child: Text('7 Days')),
                DropdownMenuItem(value: 14, child: Text('14 Days')),
                DropdownMenuItem(value: 21, child: Text('21 Days')),
                DropdownMenuItem(value: 28, child: Text('28 Days')),
              ],
              decoration: const InputDecoration(
                labelText: 'Select duration',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Add Remainder'),
            ),
          ],
        ),
      ),
    );
  }
}
