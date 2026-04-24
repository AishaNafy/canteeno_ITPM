import 'package:flutter/material.dart';

class StaffManageTab extends StatefulWidget {
  const StaffManageTab({super.key});

  @override
  State<StaffManageTab> createState() => _StaffManageTabState();
}

class _StaffManageTabState extends State<StaffManageTab> {
  final List<Map<String, dynamic>> _staffMembers = [
    {"id": 1, "name": "Isumi Jayamanna", "role": "Admin", "email": "isumi@my.sliit.lk", "status": "Active"},
    {"id": 2, "name": "Hirusha Pathum", "role": "Canteen Owner", "email": "COit23317758@my.sliit.lk", "status": "Active"},
  ];

  int _nextId = 3;

  void _showAddEditDialog([Map<String, dynamic>? staff]) {
    final bool isEdit = staff != null;
    final _formKey = GlobalKey<FormState>();

    String name = isEdit ? staff['name'] : '';
    String role = isEdit ? staff['role'] : '';
    String email = isEdit ? staff['email'] : '';
    String status = isEdit ? staff['status'] : 'Active';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Staff" : "Add Staff"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: "Name"),
                    validator: (value) => value == null || value.trim().isEmpty ? "Name is required" : null,
                    onSaved: (value) => name = value!.trim(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: role,
                    decoration: const InputDecoration(labelText: "Role"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Role is required";
                      if (value.trim().length < 3) return "Role must be at least 3 characters";
                      return null;
                    },
                    onSaved: (value) => role = value!.trim(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: email,
                    decoration: const InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Email is required";
                      if (!value.contains('@')) return "Enter a valid email address";
                      return null;
                    },
                    onSaved: (value) => email = value!.trim(),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: "Status"),
                    items: const [
                      DropdownMenuItem(value: "Active", child: Text("Active")),
                      DropdownMenuItem(value: "Not Active", child: Text("Not Active")),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        status = val;
                      }
                    },
                    onSaved: (value) => status = value!,
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
                      final index = _staffMembers.indexWhere((s) => s['id'] == staff['id']);
                      if (index != -1) {
                        _staffMembers[index] = {
                          "id": staff['id'],
                          "name": name,
                          "role": role,
                          "email": email,
                          "status": status,
                        };
                      }
                    } else {
                      _staffMembers.add({
                        "id": _nextId++,
                        "name": name,
                        "role": role,
                        "email": email,
                        "status": status,
                      });
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEdit ? "Staff updated successfully" : "Staff added successfully")),
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

  void _deleteStaff(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Staff"),
        content: const Text("Are you sure you want to delete this staff member?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                _staffMembers.removeWhere((s) => s['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Staff deleted")));
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
      body: _staffMembers.isEmpty
          ? const Center(child: Text("No staff added yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _staffMembers.length,
              itemBuilder: (context, index) {
                final staff = _staffMembers[index];
                final isActive = staff['status'] == 'Active';
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: isActive ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                      child: Icon(Icons.person, color: isActive ? Colors.green : Colors.red),
                    ),
                    title: Text(staff['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Row(children: [const Icon(Icons.badge, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(staff['role'])]),
                        const SizedBox(height: 4),
                        Row(children: [const Icon(Icons.email, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(staff['email'])]),
                        const SizedBox(height: 4),
                        Row(children: [
                          Icon(isActive ? Icons.check_circle : Icons.cancel, size: 16, color: isActive ? Colors.green : Colors.grey),
                          const SizedBox(width: 4),
                          Text(staff['status'], style: TextStyle(color: isActive ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
                        ]),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showAddEditDialog(staff),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteStaff(staff['id']),
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
        label: const Text("Add Staff", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

