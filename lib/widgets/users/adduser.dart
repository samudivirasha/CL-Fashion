import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/service/auth_service.dart';
import 'package:cl_fashion/service/createnewuser.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService databaseService = DatabaseService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _type = 'emp';

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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
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
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Please enter an email' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phoneController,
            style: TextStyle(color: textColor),
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Please enter a phone number' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _addressController,
            style: TextStyle(color: textColor),
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField(
            dropdownColor: secondaryColor,
            value: _type,
            items: [
              DropdownMenuItem(value: 'emp', child: dropDownText('Employee')),
              DropdownMenuItem(value: 'admin', child: dropDownText('Admin')),
            ],
            onChanged: (value) => setState(() => _type = value!),
            decoration: const InputDecoration(labelText: 'Type'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  AdminAuthService authService = AdminAuthService();

                  UserCredential? userCredential =
                      await authService.createUserAsAdmin(
                    _emailController.text,
                    'defaultPassword123', // Use a secure password
                  );
                  if (userCredential == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to create user')),
                    );
                    return;
                  }
                  UserModel newUser = UserModel(
                    id: userCredential
                        .user!.uid, // Assuming ID will be set by the database
                    name: _nameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    type: _type,
                  );

                  await databaseService.saveUserData(newUser.id, newUser);

                  _nameController.clear();
                  _emailController.clear();
                  _phoneController.clear();
                  _addressController.clear();
                  setState(() => _type = 'emp');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User added successfully')),
                  );
                } catch (e) {
                  print('Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error ${e.toString()}")),
                  );
                }
              }
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  Text dropDownText(String text) {
    return Text(text, style: TextStyle(color: Colors.white));
  }
}
