import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/model/measurements.dart';
import 'package:cl_fashion/service/auth_service.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Addwork extends StatefulWidget {
  Addwork({super.key});

  @override
  State<Addwork> createState() => _AddworkState();
}

class _AddworkState extends State<Addwork> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();

  // Use controllers for persistent input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Add phone number controller
  final TextEditingController _phoneNumberController = TextEditingController();

  // Measurement controllers
  final TextEditingController _bodyLengthController = TextEditingController();
  final TextEditingController _shoulderController = TextEditingController();
  final TextEditingController _sleeveLengthController = TextEditingController();
  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _bottomWidthController = TextEditingController();

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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
          const SizedBox(height: 20),
          TextFormField(
            controller: _phoneNumberController,
            style: TextStyle(color: textColor),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a phone number' : null,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                "Measurements",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _bodyLengthController,
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Body Length',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _shoulderController,
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Shoulder',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _sleeveLengthController,
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Sleeve Length',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _chestController,
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Chest',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _waistController,
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Waist',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _bottomWidthController,
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Bottom Width',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
            decoration: const InputDecoration(
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
                    // Parse measurement values
                    double bodyLength =
                        double.tryParse(_bodyLengthController.text) ?? 0;
                    double shoulder =
                        double.tryParse(_shoulderController.text) ?? 0;
                    double sleeveLength =
                        double.tryParse(_sleeveLengthController.text) ?? 0;
                    double chest = double.tryParse(_chestController.text) ?? 0;
                    double waist = double.tryParse(_waistController.text) ?? 0;
                    double bottomWidth =
                        double.tryParse(_bottomWidthController.text) ?? 0;

                    // Create Measurements object
                    final measurements = Measurements(
                        bodyLength: bodyLength,
                        shoulder: shoulder,
                        sleeveLength: sleeveLength,
                        chest: chest,
                        waist: waist,
                        bottomWidth: bottomWidth);

                    WorkModel wmodel = WorkModel(
                      name: _nameController.text,
                      orderDate: DateTime.now(),
                      endDate: DateTime.parse(formattedDate),
                      status: _status,
                      user: user,
                      assingedTo: empdata,
                      description: _descriptionController.text,
                      priority: _priority,
                      phoneNumber: _phoneNumberController.text, // <-- Pass phone number
                      measurements: measurements,
                    );
                    await databaseService.addWork(wmodel);

                    // Clear the form fields after submission
                    _nameController.clear();
                    _phoneNumberController.clear(); // <-- Clear phone number
                    _bodyLengthController.clear();
                    _shoulderController.clear();
                    _sleeveLengthController.clear();
                    _chestController.clear();
                    _waistController.clear();
                    _bottomWidthController.clear();
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

                    // Navigator.pop(context);
                  }
                } catch (e) {
                  print('Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
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

// Place this widget in your login screen file (not here), but here's the code for the Track Order dialog:
class TrackOrderDialog extends StatefulWidget {
  const TrackOrderDialog({super.key});

  @override
  State<TrackOrderDialog> createState() => _TrackOrderDialogState();
}

class _TrackOrderDialogState extends State<TrackOrderDialog> {
  final TextEditingController _orderIdController = TextEditingController();
  WorkModel? _work;
  String? _error;
  bool _loading = false;

  Future<void> _fetchOrder() async {
    setState(() {
      _loading = true;
      _error = null;
      _work = null;
    });
    try {
      final doc = await FirebaseFirestore.instance
          .collection('works')
          .doc(_orderIdController.text.trim())
          .get();
      if (doc.exists) {
        setState(() {
          _work = WorkModel.fromDocument(doc);
        });
      } else {
        setState(() {
          _error = "Order not found.";
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      title: Text('Track Order', style: TextStyle(color: textColor)),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _orderIdController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Order ID',
                labelStyle: TextStyle(color: textColor),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _fetchOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              child: _loading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Check Status', style: TextStyle(color: textColor)),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: Colors.red)),
            ],
            if (_work != null) ...[
              const SizedBox(height: 20),
              Divider(color: textColor),
              Text('Order Status: ${_work!.status}',
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const SizedBox(height: 10),
              Text('Order Name: ${_work!.name}', style: TextStyle(color: textColor)),
              Text('Customer: ${_work!.user.name}', style: TextStyle(color: textColor)),
              Text('Phone: ${_work!.phoneNumber}', style: TextStyle(color: textColor)),
              Text('Due Date: ${_work!.endDate.day}/${_work!.endDate.month}/${_work!.endDate.year}',
                  style: TextStyle(color: textColor)),
              const SizedBox(height: 10),
              Text('Description:', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              Text(_work!.description, style: TextStyle(color: textColor)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close', style: TextStyle(color: textColor)),
        ),
      ],
    );
  }
}

// To use this dialog, add a button to your login screen like this:
// ElevatedButton.icon(
//   icon: Icon(Icons.search, color: textColor),
//   label: Text('Track Order', style: TextStyle(color: textColor)),
//   style: ElevatedButton.styleFrom(
//     backgroundColor: secondaryColor,
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//   ),
//   onPressed: () => showDialog(
//     context: context,
//     builder: (context) => const TrackOrderDialog(),
//   ),
// ),
