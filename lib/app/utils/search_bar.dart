import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchController = TextEditingController();

  @override
    String _selectedFilterOption = 'All'; 

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
            ),
          ),
          CircleAvatar(
            child: IconButton(
              icon: Icon(Icons.graphic_eq_outlined),
              onPressed: () {
                 _showFilterOptions(context);
              },
            ),
          ),
          SizedBox(width: 6,)
        ],
      ),
    );
  }
   void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Filter Option'),
          content: DropdownButton<String>(
            value: _selectedFilterOption,
            onChanged: (value) {
              _selectedFilterOption= value!;
              setState(() {    });
            },
            items: <String>[
              'All',
              'Drinks',
              'Food',
              'Vegitables',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('APPLY'),
              onPressed: () {
                // Add your filter logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
}
}