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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  "Measurements:",
                  style: TextStyle(
                      color: Colors.grey[700], fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    width: 1,
                    style: BorderStyle.solid,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      children: [
                        _buildTableCell("Body", true),
                        _buildTableCell("Shoulder", true),
                        _buildTableCell("Sleeve", true),
                      ],
                    ),
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      children: [
                        _buildTableCell(
                            "${work.measurements.bodyLength}", false),
                        _buildTableCell("${work.measurements.shoulder}", false),
                        _buildTableCell(
                            "${work.measurements.sleeveLength}", false),
                      ],
                    ),
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      children: [
                        _buildTableCell("Chest", true),
                        _buildTableCell("Waist", true),
                        _buildTableCell("Bottom", true),
                      ],
                    ),
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      children: [
                        _buildTableCell("${work.measurements.chest}", false),
                        _buildTableCell("${work.measurements.waist}", false),
                        _buildTableCell(
                            "${work.measurements.bottomWidth}", false),
                      ],
                    ),
                  ],
                ),
              ],
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

Widget _buildTableCell(String text, bool isHeader) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
        color: Colors.grey[800],
      ),
    ),
  );
}
