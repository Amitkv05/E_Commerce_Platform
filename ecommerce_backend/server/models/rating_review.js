const mongoose = require('mongoose');

const ratingReviewSchema = mongoose.Schema({
    buyerId: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
    },
    fullName: {
        type: String,
        required: true,
    },
    productId: {
        type: String,
        required: true,
    },
    rating: {
        type: Number,
        required: true,
        min: 1,
        max: 5
    },
    review: {
        type: String,
        required: true,
    }
});

const ProductReview = mongoose.model('ProductReview', ratingReviewSchema);

module.exports = ProductReview;
// createdAt: {
//     type: Date,
//     default: Date.now,
// },