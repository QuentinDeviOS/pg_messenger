import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pg_messenger/Models/timestamp.dart';
import 'package:pg_messenger/generated/l10n.dart';

class TimestampController {
  String previousTimestamp = "";
  Timestamp? formatedTimestamp(DateTime? timestamp, BuildContext context) {
    if (timestamp != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final difference = today.compareTo(timestamp);
      if (difference == 1) {
        return Timestamp(
          DateFormat("d MMM").format(timestamp).toString(),
          DateFormat("Hm").format(timestamp).toString(),
        );
      } else if (difference == -1) {
        return Timestamp(
          DateFormat("d MMM").format(timestamp).toString(),
          DateFormat("Hm").format(timestamp).toString(),
        );
      } else {
        return Timestamp(
          DateFormat("d MMM").format(timestamp).toString(),
          S.of(context).message_just_now,
        );
      }
    } else {
      return null;
    }
  }

  String returnTime(DateTime timestamp) {
    return DateFormat("Hm").format(timestamp).toString();
  }

  bool compareTimestamp(DateTime? timestamp1, DateTime? timestamp2) {
    if (timestamp1 != null && timestamp2 != null) {
      final day1 = DateFormat("d MMM").format(timestamp1).toString();
      final day2 = DateFormat("d MMM").format(timestamp2).toString();
      return (day1 == day2) ? true : false;
    } else {
      return false;
    }
  }
}
