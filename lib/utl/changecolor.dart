import 'dart:ui';

import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange;
    case 'inprogress':
      return Colors.blue;
    case 'completed':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    case 'onhold':
      return Colors.grey;
    case 'delivered':
      return Colors.purple;
    case 'returned':
      return Colors.brown;
    case 'refunded':
      return Colors.teal;
    case 'exchanged':
      return Colors.indigo;
    default:
      return Colors.black;
  }
}
