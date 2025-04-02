import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {

   final DatabaseService _db = DatabaseService();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                 StreamBuilder<List<WorkModel>>(
     stream: _db.getWorks(),
     builder: (context, snapshot) {
       if (snapshot.hasError) {
         print('Error: ${snapshot.error}');
         return Center(child: Text('Error: ${snapshot.error}'));
       }
   
       if (snapshot.connectionState == ConnectionState.waiting) {
         return Center(child: CircularProgressIndicator());
       }
   
       final works = snapshot.data;
   
       if (works == null || works.isEmpty) {
         return Center(child: Text('No orders yet!'));
       }
   
       return ListView.builder(
         itemCount: works.length,
         itemBuilder: (context, index) {
           final work = works[index];
          return Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  elevation: 4,
  margin: EdgeInsets.all(12),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          work.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),

        Row(
          children: [
            Icon(Icons.calendar_today, size: 16),
            SizedBox(width: 6),
            Text("Order Date: ${work.orderDate.toLocal().toString().split(' ')[0]}"),
          ],
        ),
        SizedBox(height: 4),

        Row(
          children: [
            Icon(Icons.event_available, size: 16),
            SizedBox(width: 6),
            Text("End Date: ${work.endDate.toLocal().toString().split(' ')[0]}"),
          ],
        ),
        SizedBox(height: 8),

        Row(
          children: [
            Icon(Icons.assignment_ind, size: 16),
            SizedBox(width: 6),
            Text("Assigned To: ${work.assingedTo.name}"),
          ],
        ),
        SizedBox(height: 4),

        Row(
          children: [
            Icon(Icons.person_outline, size: 16),
            SizedBox(width: 6),
            Text("Created By: ${work.user.name}"),
          ],
        ),
        SizedBox(height: 8),

        Row(
          children: [
            Icon(Icons.flag, size: 16),
            SizedBox(width: 6),
            Text("Priority: ${work.priority}"),
          ],
        ),
        SizedBox(height: 4),

        Row(
          children: [
            Icon(Icons.info_outline, size: 16),
            SizedBox(width: 6),
            Text("Status: ${work.status}"),
          ],
        ),
        SizedBox(height: 12),

        Text(
          "Description:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          work.description,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ],
    ),
  ),);
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

