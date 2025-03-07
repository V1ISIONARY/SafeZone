import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_bloc.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_event.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            return const CurvedAlertDialog();
          },
        );
      },
      child: const Text('Show AlertDialog'),
    );
  }
}

class CurvedAlertDialog extends StatefulWidget {
  const CurvedAlertDialog({super.key});

  @override
  _CurvedAlertDialogState createState() => _CurvedAlertDialogState();
}

class _CurvedAlertDialogState extends State<CurvedAlertDialog> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  int id = 0;

  @override
  void initState() {
    super.initState();
    getId();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    contactNumberController.dispose();
    super.dispose();
  }

  // Get id from SharedPreferences
  Future<void> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id') ?? 0;
    });
  }

  // Method to show the success dialog after ContactAdded
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 15),
              Text('Contact Added', style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );

    // Automatically dismiss the dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state is ContactAdded) {
          _showSuccessDialog(context);
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text(
          'New Contact',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Name TextField
                TextField(
                  controller: firstNameController,
                  style: const TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.normal, 
                    color: Colors.black, 
                  ),
                  decoration: const InputDecoration(
                    hintText: 'First Name',
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

                // Last Name TextField
                TextField(
                  controller: lastNameController,
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

                // Contact Number TextField
                TextField(
                  controller: contactNumberController,
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
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          
          // Save button
          ElevatedButton(
            onPressed: () async {
              // Trigger AddContact event
              context.read<ContactBloc>().add(
                AddContact(contactNumberController.text, 
                            '${firstNameController.text} ${lastNameController.text}', id),
              );
              Navigator.pop(context); // Close the AddContact dialog
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
