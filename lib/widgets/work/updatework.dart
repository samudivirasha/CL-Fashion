import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/service/auth_service.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Updatework extends StatefulWidget {
  final WorkModel workmodel;
  const Updatework({super.key, required this.workmodel});

  @override
  State<Updatework> createState() => _UpdateworkState();
}

class _UpdateworkState extends State<Updatework> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();

  // Use controllers for persistent input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _measurementController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _priority = 'medium';
  String _emp = '';
  String _status = 'pending';
  String formattedDate = "Select a date";

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        formattedDate = DateFormat("yyyy-MM-dd").format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize fields with existing work data
    _priority = widget.workmodel.priority;
    _emp = widget.workmodel.assingedTo.id;
    _status = widget.workmodel.status;
    formattedDate =
        widget.workmodel.endDate.toString(); // Adjust formatting if needed

    // Initialize text controllers
    _nameController.text = widget.workmodel.name;
    _measurementController.text = widget.workmodel.measurements;
    _descriptionController.text = widget.workmodel.description;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: primaryColor,
                        title: const Text('Delete Work',
                            style: TextStyle(color: Colors.red)),
                        content: const Text('Are you sure you want to delete?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await databaseService
                                    .deleteWork(widget.workmodel.id ?? '');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Work deleted successfully'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              } on Exception catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _nameController,
            style: TextStyle(color: textColor),
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
          ),
          const SizedBox(height: 10),
          StreamBuilder<List<UserModel>>(
            stream: databaseService.getUsersData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No users found'));
              } else {
                List<UserModel> users = snapshot.data!;
                if (_emp.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _emp = users[0].id;
                    });
                  });
                }
                return DropdownButtonFormField(
                  dropdownColor: secondaryColor,
                  value: _emp.isNotEmpty ? _emp : null,
                  items: users.map((user) {
                    return DropdownMenuItem(
                      value: user.id,
                      child: dropDownText(user.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _emp = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Assinged To',
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _measurementController,
            style: TextStyle(color: textColor),
            decoration: const InputDecoration(
              labelText: 'Measurement',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _descriptionController,
            style: TextStyle(color: textColor),
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField(
            dropdownColor: secondaryColor,
            value: _priority,
            items: [
              DropdownMenuItem(value: 'high', child: dropDownText('High')),
              DropdownMenuItem(value: 'medium', child: dropDownText('Medium')),
              DropdownMenuItem(value: 'low', child: dropDownText('Low')),
            ],
            onChanged: (value) => setState(() => _priority = value!),
            decoration: InputDecoration(
              labelText: 'Priority',
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField(
            dropdownColor: secondaryColor,
            value: _status,
            items: [
              DropdownMenuItem(
                  value: 'pending', child: dropDownText('Pending')),
              DropdownMenuItem(
                  value: 'inprogress', child: dropDownText('In Progress')),
              DropdownMenuItem(
                  value: 'completed', child: dropDownText('Completed')),
              DropdownMenuItem(
                  value: 'cancelled', child: dropDownText('Cancelled')),
              DropdownMenuItem(value: 'onhold', child: dropDownText('On Hold')),
              DropdownMenuItem(
                  value: 'delivered', child: dropDownText('Delivered')),
              DropdownMenuItem(
                  value: 'returned', child: dropDownText('Returned')),
              DropdownMenuItem(
                  value: 'refunded', child: dropDownText('Refunded')),
              DropdownMenuItem(
                  value: 'exchanged', child: dropDownText('Exchanged')),
            ],
            onChanged: (value) => setState(() => _status = value!),
            decoration: InputDecoration(
              labelText: 'Status',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.calendar_month_outlined,
                  size: 40,
                  color: Colors.blue,
                ),
                onPressed: () => _selectDate(context),
              ),
              Text(
                formattedDate.split("T")[0],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  UserModel? empdata = await databaseService.getUserData(_emp);
                  UserModel? user = await databaseService
                      .getUserData(authService.getCurrentUser()!.uid);

                  if (empdata != null && user != null) {
                    WorkModel wmodel = WorkModel(
                      id: widget.workmodel.id,
                      name: _nameController.text,
                      orderDate: DateTime.now(),
                      endDate: DateTime.parse(formattedDate),
                      status: _status,
                      user: user,
                      assingedTo: empdata,
                      description: _descriptionController.text,
                      priority: _priority,
                      measurements: _measurementController.text,
                    );
                    await databaseService.updateWork(wmodel);
                  }
                  // Clear the form fields after submission
                  _nameController.clear();
                  _measurementController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _emp = '';
                    _priority = 'medium';
                    formattedDate = "Select a date";
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Work added successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  print('Error: $e');
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Text dropDownText(String text) {
    return Text(text, style: TextStyle(color: Colors.white));
  }
}
