const express = require('express');
const orderRouter = express.Router();
const Order = require('../models/order');
const stripe = require('stripe')('sk_test_51QoeC8DBCyjMZ7oIKvR1LifFNtanU4UfThxa2P9pyMRvN8rbd0mDkO0YzHfVoeKCPUX2despfip4mj6RsV3jxFzg00UyUIuOMV');
const { auth, vendorAuth } = require('../middleware/auth');

// Post route for creating orders

// orderRouter.post('/api/orders', auth, async (req, res) => {
orderRouter.post('/api/orders', async (req, res) => {
    try {
        const { fullName, email, state, city, locality, productId, productName, productPrice, quantity, category, image, vendorId, buyerId, paymentStatus, paymentIntentId, paymentMethod, } = req.body;
        const createdAt = new Date().getMilliseconds();//Get the current date..

        // create new order instance with the extracted field...
        const order = new Order({ fullName, email, state, city, locality, productId, productName, productPrice, quantity, category, image, vendorId, buyerId, paymentStatus, paymentIntentId, paymentMethod, createdAt });
        // save the order instance to the database
        await order.save();
        return res.status(201).json(order);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


//payment api
// orderRouter.post('/api/payment-intent', auth, async (req, res) => {
orderRouter.post('/api/payment-intent', async (req, res) => {
    try {
        const { amount, currency } = req.body;

        const paymentIntent = await stripe.paymentIntents.create({
            amount,
            currency,
        });

        return res.status(200).json(paymentIntent);
    }
    catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

// orderRouter.get('/api/payment-intent/:id', auth, async (req, res) => {
orderRouter.get('/api/payment-intent/:id', async (req, res) => {
    try {
        const paymentIntent = await stripe.paymentIntents.retrieve(req.params.id);
        return res.status(200).json(paymentIntent);
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
})
//payment api advance...
// orderRouter.post('/api/payment', async (req, res) => {
//     try {
//         const { orderId, paymentMethodId, currency = 'usd' } = req.body;
//         // validate the presence of the required fields
//         if (!orderId || !paymentMethodId || !currency) {
//             return res.status(400).json({ msg: "Missing required fields" });
//         }
//         // Query for the order by orderId
//         const order = await Order.findById(orderId);
//         if (!order) {
//             console.log("Order Not Found", orderId);
//             return res.status(404).json({ msg: "Order Not Found" });
//         }

//         // calculate the total amount(price*quantity)
//         const totalAmount = order.productPrice * order.quantity;

//         // Ensure the amount is at least $0,50 USD or its equivalent
//         const minimumAmount = 0.50;
//         if (totalAmount < minimumAmount) {
//             return res.status(400).json({ msg: "Amount must be at least $0.50 USD" });
//         }
//         // convert total amoint to cents(Stripe requires the amount in cents)
//         const amountInCents = Math.round(totalAmount * 100);

//         // now create the Payment intent with the correct amount..
//         const paymentIntent = await stripe.paymentIntents.create({
//             amount: amountInCents,
//             currency: currency,
//             payment_method: paymentMethodId,
//             automatic_payment_methods: { enabled: true },
//         });
//         console.log("payment Status", paymentIntent.status);
//         return res.json({
//             status: "success",
//             paymentIntent: paymentIntent.id,
//             amount: paymentIntent.amount / 100,
//             currency: paymentIntent.currency,
//         });

//     } catch (e) {
//         return res.status(500).json({ error: e.message });
//     }
// });




// Get  route for fetching orders by buyer ID
// orderRouter.get('/api/orders/:buyerId', auth, async (req, res) => {
orderRouter.get('/api/orders/:buyerId', async (req, res) => {
    try {
        // Extract the buyer ID from the request parameter
        const { buyerId } = req.params;
        // Find all orders in the database that match the buyer ID
        const orders = await Order.find({ buyerId });
        // If no orders are found, return a 404 status code with a msg
        if (orders.length === 0) {
            return res.status(404).json({ msg: 'No orders found for this buyer ID' }
            )
        }
        // if order are found, return them with a 200 status code
        return res.status(200).json(orders);

    } catch (e) {
        // Handle any errors that occure during the order retrieval process...
        res.status(500).json({ error: e.message })
    }
});

// Delete Route For deleting a specific order by _id

// orderRouter.delete('/api/orders/:id', auth, async (req, res) => {
orderRouter.delete('/api/orders/:id', async (req, res) => {
    try {
        // extract the id from the request parameter
        const { id } = req.params;
        // find and delete the order from the data base using the extracted _id
        const deletedOrder = await Order.findByIdAndDelete(id);
        // Check if an order was found and deleted
        if (!deletedOrder) {
            // ifno order was found, return a 404 status code with a msg
            return res.status(404).json({ msg: 'Order not found' })
        } else {
            // if order was found and deleted, return a 200 status code with a msg
            return res.status(200).json({ msg: 'Order deleted successfully' })
        }
    } catch (e) {
        // Handle any errors that occur during the order deletion process...
        res.status(500).json({ error: e.message })

    }
});

// Get  route for fetching orders by vendor ID
// orderRouter.get('/api/orders/vendor/:vendorId', auth, vendorAuth, async (req, res) => {
orderRouter.get('/api/orders/vendor/:vendorId', vendorAuth, async (req, res) => {
    try {
        // Extract the vendor ID from the request parameter
        const { vendorId } = req.params;
        // Find all orders in the database that match the vendor ID
        const orders = await Order.find({ vendorId });
        // If no orders are found, return a 404 status code with a msg
        if (orders.length === 0) {
            return res.status(404).json({ msg: 'No orders found for this vendor ID' }
            )
        }
        // if order are found, return them with a 200 status code
        return res.status(200).json(orders);

    } catch (e) {
        // Handle any errors that occure during the order retrieval process...
        res.status(500).json({ error: e.message })
    }
});

orderRouter.patch('/api/orders/:id/delivered', async (req, res) => {
    try {
        const { id } = req.params;
        // const { status } = req.body;
        const updatedOrder = await Order.findByIdAndUpdate(id, { delivered: true, processing: false }, { new: true });
        if (!updatedOrder) {
            return res.status(404).json({ msg: 'Order not found' })
        } else {
            return res.status(200).json(updatedOrder);
        }
    } catch (e) {
        res.status(500).json({ error: e.message })
    }
}
);
orderRouter.patch('/api/orders/:id/processing', async (req, res) => {
    try {
        const { id } = req.params;
        // const { status } = req.body;
        const updatedOrder = await Order.findByIdAndUpdate(id, { processing: false, delivered: false }, { new: true });
        if (!updatedOrder) {
            return res.status(404).json({ msg: 'Order not found' })
        } else {
            return res.status(200).json(updatedOrder);
        }
    } catch (e) {
        res.status(500).json({ error: e.message })
    }
}
);

orderRouter.get('/api/orders', async (req, res) => {
    try {
        const orders = await Order.find();
        res.status(200).json(orders);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


module.exports = orderRouter;