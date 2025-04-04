import 'package:auto_size_text/auto_size_text.dart';
import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/utl/changecolor.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:flutter/material.dart';

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
                    getStatusColor(work.status))
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
            AutoSizeText(
              maxLines: 3,
              work.measurements,
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
                      work.endDate.isBefore(
                              DateTime.now().add(const Duration(days: -1)))
                          ? "  Overdue | End Date ${work.endDate.toLocal().toString().split(' ')[0]}  "
                          : "  End Date ${work.endDate.toLocal().toString().split(' ')[0]}  ",
                      work.endDate.isBefore(DateTime.now())
                          ? Colors.red
                          : Colors.green),
                ),
                Spacer(),
                AutoSizeText(
                  "By: ${work.user.name}",
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
