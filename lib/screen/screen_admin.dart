import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrollable ListView Example',
      home: Scaffold(
        appBar: AppBar(title: Text('Orders')),
        body: MyListView(),
      ),
    );
  }
}

class MyListView extends StatelessWidget {
  final List<String> items = List.generate(50, (index) => "Item ${index + 1}");
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //   itemCount: items.length,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       leading: Icon(Icons.list),
    //       title: Text(items[index]),
    //     );
    //   },
    // );
   return StreamBuilder<List<WorkModel>>(
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
  ),
);

         },
       );
     },
   );
  }
}