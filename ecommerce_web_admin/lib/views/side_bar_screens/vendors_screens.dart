import 'package:flutter/material.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/widget/vendor_widget.dart';

class VendorsScreens extends StatefulWidget {
  static const String id = "/vendors-screens"; // Corrected the backslash
  const VendorsScreens({super.key});

  @override
  State<VendorsScreens> createState() => _VendorsScreensState();
}

class _VendorsScreensState extends State<VendorsScreens> {
  @override
  Widget build(BuildContext context) {
    Widget rowHeader(int flex, String text) {
      return Expanded(
        flex: flex,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            color: Color(0xFF3c55EF),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Manage Vendors",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                rowHeader(1, "Image"),
                rowHeader(3, "Full Name"),
                rowHeader(2, "Email"),
                rowHeader(2, "Address"),
                rowHeader(1, "Delete"),
              ],
            ),
            VendorWidget(),
          ],
        ),
      ),
    );
  }
}
