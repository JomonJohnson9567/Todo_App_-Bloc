import 'package:flutter/material.dart';

class PrefferedSized extends StatelessWidget {
  const PrefferedSized({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: const Color(0xFF667EEA),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorPadding: const EdgeInsets.only(
          left: 1,
          right: 1,
          top: 8,
          bottom: 8,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF718096),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: const [
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('In Progress'),
            ),
          ),
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Completed'),
            ),
          ),
        ],
      ),
    );
  }
}
