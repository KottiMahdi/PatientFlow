import 'package:flutter/material.dart';
import '../data.dart';

class AgendaPage extends StatefulWidget {
  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {

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
                    icon: Icon(Icons.edit, color: Colors.green),
                    onPressed: () => _editAgendaItem(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
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
        backgroundColor: Colors.blueAccent.shade400,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Method to show a dialog for adding a new agenda item
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
                    lastDate: DateTime(2040),
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

  // Method to show a dialog for editing an existing agenda item
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

  // Method to delete an agenda item
  void _deleteAgendaItem(int index) {
    setState(() {
      agendaItems.removeAt(index);
    });
  }
}
