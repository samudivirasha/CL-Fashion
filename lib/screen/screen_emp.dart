// filepath: /Users/dineth/Dineth/Programming/Flutter/Flutter Ongoing/CL-Fashion/lib/screen/screen_emp.dart
import 'package:cl_fashion/service/auth_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/model/measurements.dart';
import 'package:intl/intl.dart';

class HomeEmployee extends StatefulWidget {
  const HomeEmployee({super.key});

  @override
  State<HomeEmployee> createState() => _HomeEmployeeState();
}

class _HomeEmployeeState extends State<HomeEmployee> {
  final AuthService _authService = AuthService();

  void _handleLogout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        // Navigate to login after sign out, clearing all routes
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = _authService.getCurrentUser()?.uid ?? '';

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Logout button
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.logout, color: textColor, size: 28),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  tooltip: 'Logout',
                  onPressed: _handleLogout,
                ),
              ),
            ),

            // Main content - split into two columns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Add work form
                SizedBox(
                  width: 40.w,
                  child:
                      Center(child: EmployeeAddWork(employeeId: currentUserId)),
                ),

                // Work list
                SizedBox(
                  width: 40.w,
                  child: Column(
                    children: [
                      Text(
                        'My Assigned Works',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 80.h,
                        child: EmployeeWorkList(employeeId: currentUserId),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeAddWork extends StatefulWidget {
  final String employeeId;

  const EmployeeAddWork({super.key, required this.employeeId});

  @override
  State<EmployeeAddWork> createState() => _EmployeeAddWorkState();
}

class _EmployeeAddWorkState extends State<EmployeeAddWork> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService databaseService = DatabaseService();
  final AuthService authService = AuthService();

  // Use controllers for persistent input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // Measurement controllers
  final TextEditingController _bodyLengthController = TextEditingController();
  final TextEditingController _shoulderController = TextEditingController();
  final TextEditingController _sleeveLengthController = TextEditingController();
  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _bottomWidthController = TextEditingController();

  String _priority = 'medium';
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
          Text(
            'Add New Work',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          // Phone number field before measurements
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
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
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
              const SizedBox(width: 10),
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
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
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
            maxLines: 3,
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
                  color: textColor,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  // Get current employee's data
                  UserModel? empdata =
                      await databaseService.getUserData(widget.employeeId);
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
                      endDate: formattedDate != "Select a date"
                          ? DateTime.parse(formattedDate)
                          : DateTime.now().add(const Duration(days: 7)),
                      status: _status,
                      user: user,
                      assingedTo: empdata,
                      description: _descriptionController.text,
                      priority: _priority,
                      phoneNumber: _phoneNumberController.text,
                      measurements: measurements,
                    );
                    await databaseService.addWork(wmodel);

                    // Clear the form fields after submission
                    _nameController.clear();
                    _phoneNumberController.clear();
                    _bodyLengthController.clear();
                    _shoulderController.clear();
                    _sleeveLengthController.clear();
                    _chestController.clear();
                    _waistController.clear();
                    _bottomWidthController.clear();
                    _descriptionController.clear();

                    setState(() {
                      _priority = 'medium';
                      _status = 'pending';
                      formattedDate = "Select a date";
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Work added successfully'),
                        duration: Duration(seconds: 2),
                      ),
                    );
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
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Submit', style: TextStyle(color: textColor)),
          ),
        ],
      ),
    );
  }

  Text dropDownText(String text) {
    return Text(text, style: TextStyle(color: Colors.white));
  }
}

class EmployeeWorkList extends StatelessWidget {
  final String employeeId;

  const EmployeeWorkList({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    DatabaseService _db = DatabaseService();

    return StreamBuilder<List<WorkModel>>(
      stream: _db.getEmployeeWorks(employeeId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final works = snapshot.data;

        if (works == null || works.isEmpty) {
          return Center(
            child: Text(
              'No works assigned to you yet!',
              style: TextStyle(color: textColor, fontSize: 18),
            ),
          );
        }

        return SingleChildScrollView(
          child: SizedBox(
            height: 80.h, // Adjust this value as needed
            child: ListView.separated(
              itemCount: works.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final work = works[index];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: secondaryColor,
                          content: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: 50.w,
                            height: 700,
                            child: Center(
                              child: WorkDetailView(workmodel: work),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: WorkCard(work: work),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class WorkCard extends StatelessWidget {
  final WorkModel work;

  const WorkCard({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    // Format the dates for display
    final orderDate =
        '${work.orderDate.day}/${work.orderDate.month}/${work.orderDate.year}';
    final endDate =
        '${work.endDate.day}/${work.endDate.month}/${work.endDate.year}';

    // Get status color based on priority and status
    Color statusColor = Colors.grey;
    if (work.status == 'Pending') {
      statusColor = Colors.orange;
    } else if (work.status == 'In Progress') {
      statusColor = Colors.blue;
    } else if (work.status == 'Completed') {
      statusColor = Colors.green;
    }

    // Priority color
    Color priorityColor = Colors.grey;
    if (work.priority == 'High') {
      priorityColor = Colors.red;
    } else if (work.priority == 'Medium') {
      priorityColor = Colors.orange;
    } else if (work.priority == 'Low') {
      priorityColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order name and priority
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  work.name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: priorityColor),
                ),
                child: Text(
                  work.priority,
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              work.status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Date: $orderDate',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
              Text(
                'Due Date: $endDate',
                style: TextStyle(
                  color: work.endDate.isBefore(DateTime.now())
                      ? Colors.red
                      : textColor,
                  fontSize: 14,
                  fontWeight: work.endDate.isBefore(DateTime.now())
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Customer name
          Text(
            'Assigned by: ${work.user.name}',
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkDetailView extends StatelessWidget {
  final WorkModel workmodel;

  const WorkDetailView({super.key, required this.workmodel});

  @override
  Widget build(BuildContext context) {
    // Format the dates for display
    final orderDate =
        '${workmodel.orderDate.day}/${workmodel.orderDate.month}/${workmodel.orderDate.year}';
    final endDate =
        '${workmodel.endDate.day}/${workmodel.endDate.month}/${workmodel.endDate.year}';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Work Details',
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Work details
          buildDetailRow('Work Name', workmodel.name),
          buildDetailRow('Customer', workmodel.user.name),
          buildDetailRow('Phone Number', workmodel.phoneNumber),
          buildDetailRow('Status', workmodel.status),
          buildDetailRow('Priority', workmodel.priority),
          buildDetailRow('Order Date', orderDate),
          buildDetailRow('Due Date', endDate),

          const SizedBox(height: 20),
          Text(
            'Description',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              workmodel.description,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 20),
          Text(
            'Measurements',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Measurements
          buildMeasurementRow('Body Length', workmodel.measurements.bodyLength),
          buildMeasurementRow('Shoulder', workmodel.measurements.shoulder),
          buildMeasurementRow(
              'Sleeve Length', workmodel.measurements.sleeveLength),
          buildMeasurementRow('Chest', workmodel.measurements.chest),
          buildMeasurementRow('Waist', workmodel.measurements.waist),
          buildMeasurementRow(
              'Bottom Width', workmodel.measurements.bottomWidth),

          const SizedBox(height: 20),
          // Mark as In Progress / Completed button
          if (workmodel.status != 'Completed')
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final DatabaseService _db = DatabaseService();
                  String newStatus = workmodel.status == 'Pending'
                      ? 'In Progress'
                      : 'Completed';

                  WorkModel updatedWork = WorkModel(
                    id: workmodel.id,
                    name: workmodel.name,
                    orderDate: workmodel.orderDate,
                    endDate: workmodel.endDate,
                    status: newStatus,
                    user: workmodel.user,
                    assingedTo: workmodel.assingedTo,
                    description: workmodel.description,
                    priority: workmodel.priority,
                    phoneNumber: workmodel.phoneNumber,
                    measurements: workmodel.measurements,
                  );

                  _db.updateWork(updatedWork).then((_) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Status updated to $newStatus'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error updating status: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  workmodel.status == 'Pending'
                      ? 'Mark as In Progress'
                      : 'Mark as Completed',
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMeasurementRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
          ),
          Text(
            '$value inches',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
