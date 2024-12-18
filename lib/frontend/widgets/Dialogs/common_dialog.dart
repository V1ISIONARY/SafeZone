import 'package:flutter/material.dart';

class AlertDialogButton extends StatelessWidget {
  const AlertDialogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Show the AlertDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CurvedAlertDialog();
          },
        );
      },
      child: const Text('Show AlertDialog'),
    );
  }
}

class CurvedAlertDialog extends StatelessWidget {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();

  CurvedAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Curved edges
      ),
      title: const Text(
        'New Contact',
        style: TextStyle(
          fontSize: 17,
          color: Colors.black,
          fontWeight: FontWeight.w500
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: firstName,
                style: const TextStyle(
                  fontSize: 14, // Input text size
                  fontWeight: FontWeight.normal, // Input text weight
                  color: Colors.black, // Input text color
                ),
                decoration: const InputDecoration(
                  hintText: 'First Name',
                  hintStyle: TextStyle(
                    fontSize: 14, // Hint text size
                    fontWeight: FontWeight.w400, // Hint text weight
                    color: Colors.grey, // Hint text color
                  ),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12), // Adjust height
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: lastName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: 'Last Name',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: contactNumber,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: 'Contact Number',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); 
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            print('Field 1: ${firstName.text}');
            print('Field 1: ${lastName.text}');
            print('Field 2: ${contactNumber.text}');
            Navigator.pop(context); 
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}