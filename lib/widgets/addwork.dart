import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Addwork extends StatefulWidget {
  Addwork({super.key});

  @override
  State<Addwork> createState() => _AddworkState();
}

class _AddworkState extends State<Addwork> {
  DatabaseService databaseService = DatabaseService();
  String _name = '';

  String _measurement = '';

  String _priority = 'medium';
  String _emp = '';

  String _status = 'pending';

  String _description = '';

  String formattedDate = "Select a date";

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Form(
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(
                color:
                    textColor), // Add this line to set text color when typing
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
            onSaved: (value) => _name = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: textColor), //
            decoration: const InputDecoration(labelText: 'Measurement'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter measurement' : null,
            onSaved: (value) => _measurement = value!,
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
                  value: 'delivered', child: dropDownText("Delivered")),
              DropdownMenuItem(
                  value: 'problem', child: dropDownText('Problem')),
            ],
            onChanged: (value) => setState(() => _status = value!),
            decoration: const InputDecoration(
              labelText: 'Status',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            style:
                const TextStyle(color: Color.fromARGB(255, 212, 212, 212)), //
            decoration: const InputDecoration(labelText: 'Description'),
            onSaved: (value) => _description = value!,
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<UserModel>>(
            future: databaseService.getUsersData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No users found'));
              } else {
                List<UserModel> users = snapshot.data!;

                return DropdownButtonFormField(
                  dropdownColor: secondaryColor,
                  value: _emp.isEmpty
                      ? users[0].id
                      : _emp, // Assuming each user has a unique 'id' field
                  items: users.map((user) {
                    return DropdownMenuItem(
                      value: user.id, // Use user-specific values
                      child: dropDownText(
                          user.name), // Display user names in dropdown
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _emp = value!),
                  decoration: InputDecoration(
                    labelText: 'Employee',
                  ),
                );
              }
            },
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
            onPressed: () {
              try {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // WorkModel(name: '', orderDate: null, endDate: null, status: '', user: null, assingedTo: null, description: '', priority: '', measurements: '')
                }
              } on Exception catch (e) {
                // TODO
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
