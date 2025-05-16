import 'package:cl_fashion/service/auth_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:cl_fashion/widgets/users/adduser.dart';
import 'package:cl_fashion/widgets/users/uselist.dart';
import 'package:cl_fashion/widgets/work/addwork.dart';
import 'package:cl_fashion/widgets/work/worklist.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final AuthService _authService = AuthService();

  void _handleLogout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        // Navigate to login after sign out
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
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
    print('HomeAdmin build method called');
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40.w,
                  child: Center(child: Addwork()),
                ),
                SizedBox(width: 40.w, child: const WorkList()),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: primaryColor,
                title: Text('Add New User', style: TextStyle(color: textColor)),
                content: SizedBox(
                  width: 80.w,
                  height: 600,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 35.w,
                          height: 500,
                          child: const AddUser(),
                        ),
                        SizedBox(
                          width: 35.w,
                          height: 500,
                          child: const UserList(),
                        )
                      ],
                    ),
                  ),
                ),
                // Replace with your form widget
              );
            },
          );
        },
        backgroundColor: secondaryColor,
        child: Icon(
          Icons.person_add,
          color: textColor,
        ),
      ),
    );
  }
}
