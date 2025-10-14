// Import necessary modules
require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const admin = require('firebase-admin'); // <-- 1. IMPORT FIREBASE ADMIN

// Import your routers
const authRouter = require('./routes/auth');
const bannerRouter = require('./routes/banner');
const categoryRouter = require('./routes/category');
const subCategoryRouter = require('./routes/sub_category');
const productRouter = require('./routes/product');
const productReviewRouter = require('./routes/rating_review');
const vendorRouter = require('./routes/vendor');
const orderRouter = require('./routes/order');


// --- 2. INITIALIZE FIREBASE ADMIN SDK ---
// IMPORTANT: Make sure the path to your service account key is correct.
const serviceAccount = require('./config/serviceAccountKey.json');
// const serviceAccount = require(process.env.FIREBASE_KEY_PATH);

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});
// ------------------------------------------


// Create an instance of the express application
const app = express();
// Define the Port number the server will listen on
const DB = process.env.MONGO_URI;
const PORT = process.env.PORT || 3000;


// Apply middleware
app.use(express.json());
app.use(cors()); // Enable CORS for all routes and origins

// Register your routers
app.use(authRouter);
app.use(bannerRouter);
app.use(categoryRouter);
app.use(subCategoryRouter);
app.use(productRouter);
app.use(productReviewRouter);
app.use(vendorRouter);
app.use(orderRouter);

// Connect to the MongoDB database
mongoose.connect(DB, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => {
    console.log("MongoDB connection successful");
}).catch((err) => console.log("MongoDB connection failed:", err));

// Start the server and listen on the specified port
app.listen(PORT, "0.0.0.0", function () {
    console.log(`Server started on http://localhost:${PORT}`);
});