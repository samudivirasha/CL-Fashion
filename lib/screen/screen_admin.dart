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
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 40.w,
                  child: Form(
                      child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Measurement'),
                      ),
                      DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(
                            value: 'high',
                            child: Text('High'),
                          ),
                          DropdownMenuItem(
                            value: 'medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(
                            value: 'low',
                            child: Text('Low'),
                          ),
                        ],
                        onChanged: (value) {},
                        decoration:
                            const InputDecoration(labelText: 'Priority'),
                      ),
                      // status dropdown
                      DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(
                            value: 'pending',
                            child: Text('Pending'),
                          ),
                          DropdownMenuItem(
                            value: 'inprogress',
                            child: Text('In Progress'),
                          ),
                          DropdownMenuItem(
                            value: 'completed',
                            child: Text('Completed'),
                          ),
                          DropdownMenuItem(
                            value: 'problem',
                            child: Text('Deliverd'),
                          ),
                          DropdownMenuItem(
                            value: 'problem',
                            child: Text('Problem'),
                          ),
                        ],
                        onChanged: (value) {},
                        decoration: const InputDecoration(labelText: 'Status'),
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                      ),
                    ],
                  )),
                ),
                Container(
                  width: 40.w,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
