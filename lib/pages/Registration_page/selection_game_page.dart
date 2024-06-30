import 'package:flutter/material.dart';
import 'package:game_tracker/widgets/app_logo.dart';

class SelectionGamePage extends StatefulWidget {
  @override
  _SelectionGamePage createState() => _SelectionGamePage();
}

class _SelectionGamePage extends State<SelectionGamePage> {
   final List<ListItem> _listItems = [
    ListItem(title: 'Item 1'),
    ListItem(title: 'Item 2'),
    ListItem(title: 'Item 3'),
    ListItem(title: 'Item 4'),
    ListItem(title: 'Item 5'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: const AppLogo(),
      ),
      body:
       Column(children: [
        const Text(
  "QUALI DI QUESTI GIOCHI POSSIEDI?",
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  textAlign: TextAlign.center, // Allineamento del testo al centro
  maxLines: 2, // Numero massimo di righe
  overflow: TextOverflow.ellipsis, // Troncamento con ellissi se il testo supera le 2 righe
),
SizedBox(
  height: 430,
  child: 
       ListView.separated(
        itemCount: _listItems.length,
        separatorBuilder: (context, index) => Divider(), 
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_listItems[index].title),
            subtitle: const Text('Subtitle'),
            leading: const CircleAvatar(
              backgroundImage: AssetImage("logo.png"),
            ),
            trailing: Checkbox(
              value: _listItems[index].isSelected,
              onChanged: (bool? value) {
                setState(() {
                  _listItems[index].isSelected = value ?? false;
                });
              },
            ),
            
            onTap: () {
              setState(() {
                _listItems[index].isSelected = !_listItems[index].isSelected;
              });
            },
          );
        },
      )
      ),

       FilledButton(
                    onPressed: () {

                    },
                    child: const Text("CONFERMA"),
                  ),
    ]
       )
    );
    
  }
  }
  class ListItem {
  String title;
  bool isSelected;

  ListItem({required this.title, this.isSelected = false});
}