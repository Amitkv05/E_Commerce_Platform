// server/index.js
require('dotenv').config(); // Load environment variables

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
// const admin = require('firebase-admin');

// Import routers
const authRouter = require('./routes/auth');
const bannerRouter = require('./routes/banner');
const categoryRouter = require('./routes/category');
const subCategoryRouter = require('./routes/sub_category');
const productRouter = require('./routes/product');
const productReviewRouter = require('./routes/rating_review');
const vendorRouter = require('./routes/vendor');
const orderRouter = require('./routes/order');

// Initialize Firebase Admin SDK
try {
    const serviceAccount = require(process.env.FIREBASE_KEY_PATH);

    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
    });

    console.log('Firebase Admin initialized successfully');
} catch (err) {
    console.error('Error initializing Firebase Admin:', err.message);
}

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 5000;
const DB = process.env.MONGODB_URI;

// Middleware
app.use(express.json());
app.use(cors());

// Routes
app.use('/auth', authRouter);
app.use('/banners', bannerRouter);
app.use('/categories', categoryRouter);
app.use('/subcategories', subCategoryRouter);
app.use('/products', productRouter);
app.use('/reviews', productReviewRouter);
app.use('/vendors', vendorRouter);
app.use('/orders', orderRouter);

// MongoDB Connection
mongoose
    .connect(DB, {
        useNewUrlParser: true,
        useUnifiedTopology: true,
    })
    .then(() => console.log('✅ MongoDB connected successfully'))
    .catch((err) => console.error('❌ MongoDB connection failed:', err.message));

// Start server
app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});
