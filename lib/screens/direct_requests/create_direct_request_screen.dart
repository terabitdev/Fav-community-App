import 'package:flutter/material.dart';

class CreateDirectRequestScreen extends StatefulWidget {
  const CreateDirectRequestScreen({super.key});

  @override
  State<CreateDirectRequestScreen> createState() => _CreateDirectRequestScreenState();
}

class _CreateDirectRequestScreenState extends State<CreateDirectRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Direct Request'),
      ),
      body: const Center(
        child: Text('Create Direct Request Screen'),
      ),
    );
  }
}
