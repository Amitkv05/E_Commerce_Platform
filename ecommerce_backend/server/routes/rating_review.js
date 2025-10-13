const express = require('express');
const ProductReview = require('../models/rating_review');
const Product = require('../models/product');

const productReviewRouter = express.Router();

productReviewRouter.post('/api/product-reviews', async (req, res) => {
    try {
        const { buyerId, email, fullName, productId, rating, review } = req.body;
        // Check if the user has alreadu reviewed the product
        const existingReview = await ProductReview.findOne({ buyerId, productId });
        if (existingReview) {
            return res.status(400).json({ message: "You have already reviewed this product" });
        }
        // Create a new review

        const reviews = new ProductReview({ buyerId, email, fullName, productId, rating, review });
        await reviews.save();

        // find the product associated with the review using the productId
        const product = await Product.findById(productId);
        // if the product was not found, return 404 error response
        if (!product) {
            return res.status(404).json({ msg: "Product not found" });
        }
        // update the totalRatings by incrementing it by 1
        product.totalRatings += 1;
        // update the averageRating by calculating the new average
        product.averageRating = ((product.averageRating * (product.totalRatings - 1)) + rating) / product.totalRatings;
        // save the updated product
        await product.save();

        res.status(201).send(reviews);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

productReviewRouter.get('/api/product-reviews', async (req, res) => {
    try {
        const productReviews = await ProductReview.find();
        return res.status(200).json(productReviews);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = productReviewRouter;