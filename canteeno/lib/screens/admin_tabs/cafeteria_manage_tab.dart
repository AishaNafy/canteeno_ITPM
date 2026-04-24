import 'package:flutter/material.dart';

class CafeteriaManageTab extends StatefulWidget {
  const CafeteriaManageTab({super.key});

  @override
  State<CafeteriaManageTab> createState() => _CafeteriaManageTabState();
}

class _CafeteriaManageTabState extends State<CafeteriaManageTab> {
  final List<Map<String, dynamic>> _cafeterias = [
    {"id": 1, "name": "Cafeteria 1", "location": "Main Building", "number": "0771234567", "timeOpen": "08:00 AM - 05:00 PM"},
    {"id": 2, "name": "Cafeteria 2", "location": "Engineering Block", "number": "0777654321", "timeOpen": "07:30 AM - 06:00 PM"},
  ];

  int _nextId = 3;

  void _showAddEditDialog([Map<String, dynamic>? cafeteria]) {
    final bool isEdit = cafeteria != null;
    final _formKey = GlobalKey<FormState>();

    String name = isEdit ? cafeteria['name'] : '';
    String location = isEdit ? cafeteria['location'] : '';
    String number = isEdit ? cafeteria['number'] : '';
    String timeOpen = isEdit ? cafeteria['timeOpen'] : '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Cafeteria" : "Add Cafeteria"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: "Name"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Name is required";
                      if (RegExp(r'^[0-9\+\-\s]+$').hasMatch(value.trim())) return "Type a valid name";
                      return null;
                    },
                    onSaved: (value) => name = value!.trim(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: location,
                    decoration: const InputDecoration(labelText: "Location"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Location is required";
                      if (RegExp(r'^[0-9\+\-\s]+$').hasMatch(value.trim())) return "Type the location not the phone number";
                      return null;
                    },
                    onSaved: (value) => location = value!.trim(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: number,
                    decoration: const InputDecoration(labelText: "Phone Number"),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Number is required";
                      if (RegExp(r'[a-zA-Z]').hasMatch(value)) return "Type the phone number not letters";
                      if (value.trim().length < 9) return "Enter a valid phone number";
                      return null;
                    },
                    onSaved: (value) => number = value!.trim(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: timeOpen,
                    decoration: const InputDecoration(labelText: "Time Open", hintText: "e.g., 08:00 AM - 05:00 PM"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Time Open is required";
                      if (!RegExp(r'\d{1,2}:\d{2}').hasMatch(value)) return "Enter a valid time";
                      return null;
                    },
                    onSaved: (value) => timeOpen = value!.trim(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9B1C1C)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    if (isEdit) {
                      final index = _cafeterias.indexWhere((c) => c['id'] == cafeteria['id']);
                      if (index != -1) {
                        _cafeterias[index] = {
                          "id": cafeteria['id'],
                          "name": name,
                          "location": location,
                          "number": number,
                          "timeOpen": timeOpen,
                        };
                      }
                    } else {
                      _cafeterias.add({
                        "id": _nextId++,
                        "name": name,
                        "location": location,
                        "number": number,
                        "timeOpen": timeOpen,
                      });
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEdit ? "Cafeteria updated successfully" : "Cafeteria added successfully")),
                  );
                }
              },
              child: Text(isEdit ? "Update" : "Add", style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _deleteCafeteria(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Cafeteria"),
        content: const Text("Are you sure you want to delete this cafeteria?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                _cafeterias.removeWhere((c) => c['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cafeteria deleted")));
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _cafeterias.isEmpty
          ? const Center(child: Text("No cafeterias added yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cafeterias.length,
              itemBuilder: (context, index) {
                final cafeteria = _cafeterias[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(cafeteria['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(cafeteria['location'])]),
                        const SizedBox(height: 4),
                        Row(children: [const Icon(Icons.phone, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(cafeteria['number'])]),
                        const SizedBox(height: 4),
                        Row(children: [const Icon(Icons.access_time, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(cafeteria['timeOpen'])]),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showAddEditDialog(cafeteria),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCafeteria(cafeteria['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFF9B1C1C),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Cafeteria", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

