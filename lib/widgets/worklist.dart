import 'package:auto_size_text/auto_size_text.dart';
import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/service/database_service.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WorkList extends StatelessWidget {
  const WorkList({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseService _db = DatabaseService();

    return StreamBuilder<List<WorkModel>>(
        stream: _db.getWorks(),
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
                  return cardData(work);
                },
              ),
            ),
          );
        });
  }

  Card cardData(WorkModel work) {
    return Card(
        color: secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        // margin: EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      "Order Date: ${work.orderDate.toLocal().toString().split(' ')[0]}"),
                  const Spacer(),
                  statusCard(
                      "${work.status[0].toUpperCase()}${work.status.substring(1)}",
                      Colors.green)
                ],
              ),
              AutoSizeText(
                textAlign: TextAlign.left,
                work.name,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AutoSizeText(
                textAlign: TextAlign.left,
                work.assingedTo.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              AutoSizeText(
                maxLines: 3,
                work.description,
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    // width: 20.w,
                    child: statusCard(
                        "  End Date ${work.endDate.toLocal().toString().split(' ')[0]}  ",
                        Colors.red),
                  ),
                  Spacer(),
                  AutoSizeText(
                    "By: ${work.assingedTo.name}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Container statusCard(String text, Color color) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(40),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
        color: color.withAlpha(70),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.all(5),
      height: 30,
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }
}
