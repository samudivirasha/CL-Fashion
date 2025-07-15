import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:flutter/material.dart';

class UpdateTaskStatus extends StatefulWidget {
  final WorkModel work;
  final Function() onUpdate;

  const UpdateTaskStatus({
    Key? key,
    required this.work,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<UpdateTaskStatus> createState() => _UpdateTaskStatusState();
}

class _UpdateTaskStatusState extends State<UpdateTaskStatus> {
  final DatabaseService _database = DatabaseService();
  bool _isUpdating = false;
  late String _selectedStatus;

  final List<String> statusOptions = ['pending', 'in progress', 'completed'];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.work.status;
  }

  Future<void> _updateStatus() async {
    if (_selectedStatus == widget.work.status) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      // Create a new work model with the updated status
      final updatedWork = WorkModel(
        id: widget.work.id,
        name: widget.work.name,
        orderDate: widget.work.orderDate,
        endDate: widget.work.endDate,
        status: _selectedStatus,
        user: widget.work.user,
        assingedTo: widget.work.assingedTo,
        description: widget.work.description,
        priority: widget.work.priority,
        phoneNumber: widget.work.phoneNumber, // <-- Add this line
        measurements: widget.work.measurements,
      );

      await _database.updateWork(updatedWork);
      widget.onUpdate();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task status updated to $_selectedStatus'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Update Task Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Current Status: ${widget.work.status}',
          style: TextStyle(
            color: textColor,
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'New Status',
            labelStyle: TextStyle(color: textColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
          ),
          dropdownColor: secondaryColor,
          style: TextStyle(color: textColor),
          value: _selectedStatus,
          items: statusOptions.map((String status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedStatus = newValue;
              });
            }
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: _isUpdating ? null : () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: textColor),
              ),
            ),
            ElevatedButton(
              onPressed: _isUpdating ? null : _updateStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: _isUpdating
                  ? const CircularProgressIndicator()
                  : Text(
                      'Update Status',
                      style: TextStyle(color: textColor),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
