const express = require('express');
const Product = require('../models/product');
const productRouter = express.Router();
const { auth, vendorAuth } = require('../middleware/auth');

productRouter.post('/api/products', auth, vendorAuth, async (req, res) => {
    // productRouter.post('/api/products', async (req, res) => {
    try {
        const { productName, productPrice, quantity, description, category, vendorId, fullName, subCategory, images } = req.body;
        const product = new Product({ productName, productPrice, quantity, description, category, vendorId, fullName, subCategory, images });
        await product.save();
        res.status(201).send(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

productRouter.get('/api/popular-products', async (req, res) => {
    try {
        const popularProducts = await Product.find({ popular: true });
        if (!popularProducts || popularProducts.length === 0) {
            return res.status(404).json({ msg: "No popular products found" });
        } else {
            res.status(200).json(popularProducts);
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

productRouter.get('/api/recommend-products', async (req, res) => {
    try {
        const recommendedProduct = await Product.find({ recommended: true });
        if (!recommendedProduct || recommendedProduct.length === 0) {
            return res.status(404).json({ msg: "No recommended product found" });
        } else {
            res.status(200).json(recommendedProduct);
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});
// new route for retrieving products by category(showing products according to categories..)
productRouter.get('/api/products-by-category/:category', async (req, res) => {
    try {
        const { category } = req.params;
        const products = await Product.find({ category, popular: true });
        if (!products || products.length == 0) {
            return res.status(404).json({ msg: "No products found in this category" });
        } else {
            return res.status(200).json(products);
        }
    } catch (e) {
        res.status(500).json({ error: e.message })
    }
});

// new route for retrieving related products by subcategory...
productRouter.get('/api/related-products-by-subcategory/:productId', async (req, res) => {
    try {
        const { productId } = req.params;
        // first, find the product to get its subcategory..
        const product = await Product.findById(productId);
        if (!product) {
            return res.status(404).json({ msg: "Product Not Found" });
        } else {
            // find related products base on the subategory of the retrieved product...
            const relatedProducts = await Product.find({
                subcategory: product.subcategory, _id: { $ne: productId }//Exclude the current product...
            });
            if (!relatedProducts || relatedProducts.length == 0) {
                return res.status(404).json({ msg: "No related products found" });
            } else {
                return res.status(200).json(relatedProducts);
            }
        }
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

// route for retrieving the top 10 hightest- rated products

// productRouter.get('/api/top-rated-products', async (req, res) => {
//     try {
//         // fetch all products and sort them by avarage rating in decending order(highest rating)
//         // sort product by averageRating, with -1 indicating decending....
//         const topRatedProducts = await Product.find({}).sort({ averageRating: -1 }).limit(1);//limit the result top 10 highest rated products only...

//         // check if there are any top-rated products returned..
//         if (!topRatedProducts || topRatedProducts.length == 0) {
//             return res.status(404).json({ msg: "No top-rated Products Found" });
//         }
//     } catch (e) {
//         return res.status(500).json({ error: e.message });
//     }
// });


productRouter.get('/api/products-by-subcategory/:subCategory', async (req, res) => {
    try {
        const { subCategory } = req.params;
        const products = await Product.find({ subCategory: subCategory });
        if (!products || products.length == 0) {
            return res.status(404).json({ msg: "No products found in this subcategory" });
        }
        return res.status(200).json(products);

    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

// Router for searching products by nae or description

productRouter.get('/api/search-products', async (req, res) => {
    try {
        // Extract the 'query' parameter from the request query string
        const { query } = req.query;
        // Validate that a query parameter is provided;
        // if missing, return a 400 status with an error message

        if (!query) {
            return res.status(400).json({ msg: "Query parameter required" });

        }

        // search for the Product collection for documents where either 'productName' or "description"
        // contains the specified query string;
        const products = await Product.find({
            $or: [
                // Regex will match any productName containing the query String
                // for example, if the user search for "apple", the regex will check
                // if "apple" is part of any productName, so product name"Green Aooke pie",
                // or "Fresh Apples", would all match beacuse they contain the words "apple".  
                { productName: { $regex: query, $options: 'i' } },
                { description: { $regex: query, $options: 'i' } },
                { subCategory: { $regex: query, $options: 'i' } },
                { category: { $regex: query, $options: 'i' } },
            ]
        });
        // check if any products were found, if no product match the query
        // return a 404 status with an error message
        if (!products || products.length == 0) {
            return res.status(404).json({ msg: "No products found matching your search" });
        }
        // if products were found, return a 200 status with the products
        return res.status(200).json(products);
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});
// // Route to edit an existion product
// productRouter.put('/api/edit-product/:id', auth, vendorAuth, async (req, res) => {
//     try {
//         // Extract Product Id from the request parameter
//         const { productId } = req.params;

//         // Check if the product exists and if the vendor is authorized to edit it..
//         const product = await Product.findById(productId);
//         if (!product) {
//             return res.status(404).json({ msg: "Product not found" });
//         }
//         // Check if the vendor is authorized to edit the product
//         if (product.vendorId.toString() !== req.user.id) {
//             return res.status(403).json({ msg: "You are not authorized to edit this product" });

//         }
//         // Destructure req.body to exclude vendorid
//         const { vendorId, ...updateData } = req.body;
//         // update the product with the fields provided in updateData..

//         const updatedProduct = await Product.findByIdAndUpdate(
//             productId,
//             { $set: updateData },//update only fields in the updateData
//             { new: true },//return the updated product document in the response

//         );
//         // return the updated product with 200 ok status..
//         return res.status(200).json(updatedProduct);
//     } catch (e) {
//         return res.status(500).json({ error: e.message });

//     }
// });
module.exports = productRouter;