import 'package:flutter/material.dart';

import '../data.dart';

class AgendaPage extends StatefulWidget {
  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  // List of agenda items
  List<AgendaItem> agendaItems = [
    AgendaItem(title: "Team Meeting", date: "2024-11-01", description: "Monthly team meeting to discuss project updates."),
    AgendaItem(title: "Code Review", date: "2024-11-05", description: "Reviewing code submissions from the latest sprint."),
    AgendaItem(title: "Design Session", date: "2024-11-10", description: "Brainstorming session for new design features.")
  ];

  // Method to show dialog and add new item
  void _addAgendaItem() {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Agenda Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10),
                    Text("Select Date: ${selectedDate.toLocal()}".split(' ')[0]),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  agendaItems.add(
                    AgendaItem(
                      title: _titleController.text,
                      date: selectedDate.toLocal().toString().split(' ')[0],
                      description: _descriptionController.text,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda"),
      ),
      body: ListView.builder(
        itemCount: agendaItems.length,
        itemBuilder: (context, index) {
          final item = agendaItems[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(item.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date: ${item.date}"),
                  SizedBox(height: 4),
                  Text(item.description),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editAgendaItem(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteAgendaItem(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAgendaItem,
        child: Icon(Icons.add),
      ),
    );
  }
  void _editAgendaItem(int index) {
    final _titleController = TextEditingController(text: agendaItems[index].title);
    final _descriptionController = TextEditingController(text: agendaItems[index].description);
    DateTime selectedDate = DateTime.parse(agendaItems[index].date);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Agenda Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10),
                    Text("Select Date: ${selectedDate.toLocal()}".split(' ')[0]),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  agendaItems[index] = AgendaItem(
                    title: _titleController.text,
                    date: selectedDate.toLocal().toString().split(' ')[0],
                    description: _descriptionController.text,
                  );
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteAgendaItem(int index) {
    setState(() {
      agendaItems.removeAt(index);
    });
  }}

