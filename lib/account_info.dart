import 'package:flutter/material.dart';

class AccountInfo extends StatelessWidget {
  const AccountInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Name:',
            style: TextStyle(fontSize: 16)
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your name',
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Mail:',
            style: TextStyle(fontSize: 16),
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
        ],
      ),
    );
  }
}
