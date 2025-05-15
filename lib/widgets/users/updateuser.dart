import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:flutter/material.dart';

class UpdateUser extends StatefulWidget {
  final UserModel userModel;
  const UpdateUser({super.key, required this.userModel});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = DatabaseService();

  // Use controllers for persistent input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  String? _type;
  List<String> userTypes = ['admin', 'employee'];

  @override
  void initState() {
    super.initState();

    // Initialize fields with existing user data
    _type = widget.userModel.type;
    
    // Debug
    print("Initial user type: $_type");
    
    // If type is not in the list of valid types, set it to the first option
    if (_type == null || (_type?.isEmpty ?? true) || !userTypes.contains(_type)) {
      _type = userTypes[0];
      print("Type reset to: $_type");
    }

    // Initialize text controllers
    _nameController.text = widget.userModel.name;
    _emailController.text = widget.userModel.email;
    _phoneController.text = widget.userModel.phone;
    _addressController.text = widget.userModel.address;
  }

  // Dispose controllers when the widget is removed
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Validator function for the form
  String? validateForm() {
    if (_nameController.text.isEmpty) {
      return 'Please enter a name';
    }
    if (_emailController.text.isEmpty) {
      return 'Please enter an email';
    }
    if (_phoneController.text.isEmpty) {
      return 'Please enter a phone number';
    }
    if (_addressController.text.isEmpty) {
      return 'Please enter an address';
    }
    if (_type == null || (_type?.isEmpty ?? true)) {
      return 'Please select a user type';
    }
    return null;
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
                        title: const Text('Delete User',
                            style: TextStyle(color: Colors.red)),
                        content: const Text('Are you sure you want to delete this user?'),
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
                                await databaseService.deleteUser(widget.userModel.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('User deleted successfully'),
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
          const SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            style: TextStyle(color: textColor),
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phoneController,
            style: TextStyle(color: textColor),
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            validator: (value) => value!.isEmpty ? 'Please enter a phone number' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _addressController,
            style: TextStyle(color: textColor),
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            validator: (value) => value!.isEmpty ? 'Please enter an address' : null,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            dropdownColor: secondaryColor,
            value: _type,
            items: userTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _type = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'User Type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String? validationError = validateForm();
                if (validationError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(validationError),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                
                try {
                  UserModel updatedUser = UserModel(
                    id: widget.userModel.id,
                    name: _nameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    type: _type ?? 'employee', // Default to 'employee' if _type is null
                  );
                  
                  await databaseService.updateUser(updatedUser);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User updated successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.of(context).pop();
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            child: Text(
              'Update User',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
