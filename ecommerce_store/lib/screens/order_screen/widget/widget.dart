  // Widget _buildStatusIndicator() {
  //   // maybe show a progress bar with steps: Processing → Shipped → Delivered
  //   // For now simple
  //   bool isDelivered = widget.order.delivered == true;
  //   bool isProcessing = widget.order.processing == true;

  //   return Row(
  //     children: [
  //       _statusStep("Processing", isProcessing || isDelivered),
  //       _statusLine(isDelivered),
  //       _statusStep("Delivered", isDelivered),
  //     ],
  //   );
  // }

  // Widget _statusStep(String label, bool done) {
  //   return Row(
  //     children: [
  //       Container(
  //         width: 20,
  //         height: 20,
  //         decoration: BoxDecoration(
  //           color: done ? Colors.green : Colors.grey[300],
  //           shape: BoxShape.circle,
  //         ),
  //         child: done
  //             ? Icon(Icons.check, size: 14, color: Colors.white)
  //             : SizedBox(),
  //       ),
  //       SizedBox(width: 8),
  //       Text(label, style: TextStyle(color: done ? Colors.black : Colors.grey)),
  //     ],
  //   );
  // }

  // Widget _statusLine(bool done) {
  //   return Expanded(
  //     child: Container(
  //       height: 2,
  //       color: done ? Colors.green : Colors.grey[300],
  //     ),
  //   );
  // }
