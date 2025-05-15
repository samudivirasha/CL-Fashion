import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:cl_fashion/widgets/users/usercard.dart';
import 'package:cl_fashion/widgets/users/updateuser.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseService _db = DatabaseService();

    return StreamBuilder<List<UserModel>>(
        stream: _db.getUsersData(),
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
            return const Center(child: Text('No orders yet!'));
          }

          return SingleChildScrollView(
            child: SizedBox(
              height: 90.h, // Adjust this value as needed
              child: ListView.separated(
                itemCount: works.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
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
                              height: 600,
                              child: Center(child: UpdateUser(userModel: work)),
                            ),
                          );
                        },
                      );
                    },
                    child: userData(work),
                  );
                },
              ),
            ),
          );
        });
  }
}
