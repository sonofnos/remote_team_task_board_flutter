import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Task Board';
  static const String appVersion = '1.0.0';

  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double buttonElevation = 1.0;
  static const double spacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double largeSpacing = 24.0;

  // Padding constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Spacing constants
  static const double defaultSpacing = 16.0;

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimation = Duration(milliseconds: 150);

  // Task priorities
  static const List<String> taskPriorities = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  // Default column names
  static const List<String> defaultColumns = [
    'To Do',
    'In Progress',
    'Review',
    'Done',
  ];

  // Colors
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFF8B5CF6);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);

  // Task status colors
  static const Map<String, Color> priorityColors = {
    'Low': Color(0xFF6B7280),
    'Medium': Color(0xFFF59E0B),
    'High': Color(0xFFEF4444),
    'Critical': Color(0xFF7C2D12),
  };
}
