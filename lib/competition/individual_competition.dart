import 'package:flutter/material.dart';

class IndividualCompetitionsScreen extends StatefulWidget {
  final String id;

  const IndividualCompetitionsScreen({required this.id, super.key});

  @override
  State<IndividualCompetitionsScreen> createState() =>
      _IndividualCompetitionsScreenState();
}

class _IndividualCompetitionsScreenState
    extends State<IndividualCompetitionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text(widget.id),
      ),
    );
  }
}
