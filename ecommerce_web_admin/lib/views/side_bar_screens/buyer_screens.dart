import 'package:flutter/material.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/widget/buyer_widget.dart';

class BuyersScreens extends StatefulWidget {
  static const String id = "\buyers-screens";
  const BuyersScreens({super.key});

  @override
  State<BuyersScreens> createState() => _BuyersScreensState();
}

class _BuyersScreensState extends State<BuyersScreens> {
  @override
  Widget build(BuildContext context) {
    Widget _rowHeader(int flex, String text) {
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
                "Manage Buyers",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                _rowHeader(1, "Image"),
                _rowHeader(3, "Full Name"),
                _rowHeader(2, "Email"),
                _rowHeader(2, "Address"),
                _rowHeader(1, "Delete"),
              ],
            ),
            BuyerWidget(),
          ],
        ),
      ),
    );
  }
}
