import 'package:flutter/material.dart';

import '../views/seach_page.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController _searchController = TextEditingController();

  @override
    String _selectedFilterOption = 'All'; 

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0,vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 0), // changes position of shadow
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
              onSubmitted: (query) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(query: query),
                ),
              );
            },
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
}
}
