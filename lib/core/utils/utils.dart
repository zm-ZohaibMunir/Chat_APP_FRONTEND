import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showError(BuildContext context, dynamic message) {
  String msg = getReadableError(message);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      // This forces the SnackBar to appear at the top
      margin: const EdgeInsets.all(16),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ),
  );
}

String getReadableError(dynamic e) {
  final error = e.toString().toLowerCase();

  if (error.contains('socketexception') || error.contains('network')) {
    return "Check your internet connection and try again.";
  }
  if (error.contains('timeout')) {
    return "The server is taking too long to respond. Please try again later.";
  }
  if (error.contains('401') ||
      error.contains('unauthorized') ||
      error.contains('session expired')) {
    return "Your session has expired. Please log in again.";
  }
  if (error.contains('403') || error.contains('forbidden')) {
    return "You do not have permission to access this feature.";
  }
  if (error.contains('500')) {
    return "Server error. We are working on fixing it!";
  }

  return e.toString().replaceAll('Exception:', '').trim();
}

String formatLastSeen(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 2) return "just now";
  if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
  if (diff.inHours < 24) return "${diff.inHours}h ago";
  return "${diff.inDays}d ago";
}


String formatTimeOnly(DateTime dateTime) {
  return DateFormat.jm().format(dateTime.toLocal());
}