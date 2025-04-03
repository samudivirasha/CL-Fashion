import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:cl_fashion/widgets/addwork.dart';
import 'package:cl_fashion/widgets/worklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    );
  }
}
