// filepath: /Users/dineth/Dineth/Programming/Flutter/Flutter Ongoing/CL-Fashion/lib/widgets/work/employee_worklist.dart
import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/service/auth_service.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:cl_fashion/widgets/work/update_task_status.dart';
import 'package:cl_fashion/widgets/work/workcard.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmployeeWorkList extends StatefulWidget {
  const EmployeeWorkList({super.key});

  @override
  State<EmployeeWorkList> createState() => _EmployeeWorkListState();
}

class _EmployeeWorkListState extends State<EmployeeWorkList> {
  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();
  bool _refreshTrigger = false;

  void _refreshList() {
    setState(() {
      _refreshTrigger = !_refreshTrigger;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.getCurrentUser();

    if (currentUser == null) {
      return const Center(child: Text('Please login to view your tasks'));
    }

    return StreamBuilder<List<WorkModel>>(
      stream: _db.getEmployeeWorks(currentUser.uid),
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
              'No tasks assigned to you yet!',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          );
        }

        return SingleChildScrollView(
          child: SizedBox(
            height: 90.h,
            child: ListView.separated(
              itemCount: works.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final work = works[index];
                return GestureDetector(
                  onTap: () {
                    _showTaskDetailsDialog(context, work);
                  },
                  child: cardData(work),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showTaskDetailsDialog(BuildContext context, WorkModel work) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: Text(
            'Task Details',
            style: TextStyle(color: textColor),
          ),
          content: Container(
            width: 60.w,
            constraints: BoxConstraints(maxHeight: 80.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    work.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow('Status:', work.status),
                  _buildInfoRow('Priority:', work.priority),
                  _buildInfoRow('Order Date:',
                      work.orderDate.toLocal().toString().split(' ')[0]),
                  _buildInfoRow('Due Date:',
                      work.endDate.toLocal().toString().split(' ')[0]),
                  _buildInfoRow('Customer:', work.user.name),
                  const SizedBox(height: 10),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    work.description,
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Measurements:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Measurements table
                  Table(
                    border: TableBorder.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    children: [
                      TableRow(
                        children: [
                          _buildTableCell('Body Length', true),
                          _buildTableCell('Shoulder', true),
                          _buildTableCell('Sleeve Length', true),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell(
                              '${work.measurements.bodyLength}', false),
                          _buildTableCell(
                              '${work.measurements.shoulder}', false),
                          _buildTableCell(
                              '${work.measurements.sleeveLength}', false),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell('Chest', true),
                          _buildTableCell('Waist', true),
                          _buildTableCell('Bottom Width', true),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildTableCell('${work.measurements.chest}', false),
                          _buildTableCell('${work.measurements.waist}', false),
                          _buildTableCell(
                              '${work.measurements.bottomWidth}', false),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _showUpdateStatusDialog(context, work);
              },
              child: Text(
                'Update Status',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateStatusDialog(BuildContext context, WorkModel work) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          content: UpdateTaskStatus(
            work: work,
            onUpdate: _refreshList,
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, bool isHeader) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
          color: textColor,
        ),
      ),
    );
  }
}
