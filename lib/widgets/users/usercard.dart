import 'package:auto_size_text/auto_size_text.dart';
import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/utl/theme.dart';
import 'package:flutter/material.dart';

Card userData(UserModel user) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoSizeText(
                    maxLines: 3,
                    user.id,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Icon(
                  Icons.edit,
                  color: textColor,
                  size: 16,
                ),
              ],
            ),
            AutoSizeText(
              textAlign: TextAlign.left,
              user.name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            AutoSizeText(
              textAlign: TextAlign.left,
              user.type,
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
              user.email,
              style: TextStyle(color: Colors.grey[700]),
            ),
            AutoSizeText(
              maxLines: 3,
              user.phone,
              style: TextStyle(color: Colors.grey[700]),
            ),
            AutoSizeText(
              maxLines: 3,
              user.address,
              style: TextStyle(color: Colors.grey[700]),
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
