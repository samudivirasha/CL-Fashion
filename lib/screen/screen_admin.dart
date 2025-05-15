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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Employee management button
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.people, color: textColor),
                  label: Text('Manage Employees', style: TextStyle(color: textColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: primaryColor,
                          title: Text('Employee Management', style: TextStyle(color: textColor)),
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
                        );
                      },
                    );
                  },
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
