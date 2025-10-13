import 'package:flutter/material.dart';
import 'package:web_admin_for_fullstack/controllers/vendor_controller.dart';
import 'package:web_admin_for_fullstack/models/vendor.dart';

class VendorWidget extends StatefulWidget {
  const VendorWidget({super.key});

  @override
  State<VendorWidget> createState() => _VendorWidgetState();
}

class _VendorWidgetState extends State<VendorWidget> {
  // A Future that will hold the list of Buyer once loaded from the API
  late Future<List<Vendor>> futureVendors;
  @override
  void initState() {
    //
    super.initState();
    futureVendors = VendorController().loadVendors();
  }

  @override
  Widget build(BuildContext context) {
    Widget _vendorData(int flex, Widget widget) {
      return Expanded(
        flex: flex,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            // color: Color(0xFF3c55EF),
          ),
          child: Padding(padding: const EdgeInsets.all(8.0), child: widget),
        ),
      );
    }

    return FutureBuilder(
        future: futureVendors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error loading vendor: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No Vendor"),
            );
          } else {
            final vendors = snapshot.data!;
            return Container(
              height: MediaQuery.of(context).size.height * 0.54,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    final vendor = vendors[index];
                    return Row(
                      children: [
                        _vendorData(
                          1,
                          CircleAvatar(
                            child: Text(
                              vendor.fullName[0],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        _vendorData(
                          3,
                          Text(
                            vendor.fullName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _vendorData(
                          2,
                          Text(
                            vendor.email,
                            style: TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _vendorData(
                          2,
                          Text(
                            "${vendor.state} ${vendor.city}",
                            style: TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _vendorData(
                          1,
                          TextButton(
                            onPressed: () {},
                            child: Text("Delete"),
                          ),
                        ),
                      ],
                    );
                  }),
            );
          }
        });
  }
}
