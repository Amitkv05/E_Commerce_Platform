import 'package:flutter/material.dart';
import 'package:web_admin_for_fullstack/controllers/buyer_controller.dart';
import 'package:web_admin_for_fullstack/models/buyer.dart';

class BuyerWidget extends StatefulWidget {
  const BuyerWidget({super.key});

  @override
  State<BuyerWidget> createState() => _BuyerWidgetState();
}

class _BuyerWidgetState extends State<BuyerWidget> {
  // A Future that will hold the list of Buyer once loaded from the API
  late Future<List<Buyer>> futureBuyers;
  @override
  void initState() {
    //
    super.initState();
    futureBuyers = BuyerController().loadBuyers();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buyerData(int flex, Widget widget) {
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
        future: futureBuyers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error loading banners: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No Banners"),
            );
          } else {
            final buyers = snapshot.data!;
            return Container(
              height: MediaQuery.of(context).size.height * 0.54,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: buyers.length,
                  itemBuilder: (context, index) {
                    final buyer = buyers[index];
                    return Row(
                      children: [
                        _buyerData(
                          1,
                          CircleAvatar(
                            child: Text(
                              buyer.fullName[0],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        _buyerData(
                          3,
                          Text(
                            buyer.fullName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buyerData(
                          2,
                          Text(
                            buyer.email,
                            style: TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buyerData(
                          2,
                          Text(
                            "${buyer.state} ${buyer.city}",
                            style: TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buyerData(
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
