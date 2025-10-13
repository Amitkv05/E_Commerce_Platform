import 'package:http/http.dart' as http;
import 'package:shopgram/core/constants/app_constants.dart';
import 'package:shopgram/models/product_review.dart';
import 'package:shopgram/server/manage_http_responses.dart';

class ProductReviewController {
  uploadReview({
    required String buyerId,
    required String email,
    required String fullName,
    required String productId,
    required double rating,
    required String review,
    required context,
  }) async {
    try {
      final ProductReview productReview = ProductReview(
        id: '',
        buyerId: buyerId,
        email: email,
        fullName: fullName,
        productId: productId,
        rating: rating,
        review: review,
      );

      http.Response response = await http.post(
        Uri.parse(AppConstants.productReviewEndpoint),
        body: productReview.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponses(
        response: response,
        context: context,
        onSuccess: () async {
          showSnackBar(context, "Review uploaded successfully");
        },
      );
    } catch (e) {
      showSnackBar(context, "Error While uploading review");
    }
  }
}
