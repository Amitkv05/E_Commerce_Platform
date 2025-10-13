// // import the express module
// const express = require('express');
// // const bcrypt = require('bcryptjs');
// // const dotenv = require("dotenv");
// const connectDB = require("./config/db");
// // const otpRoutes = require("./routes/otpRoutes");
// const mongoose = require('mongoose');
// const authRouter = require('./routes/auth');
// const bannerRouter = require('./routes/banner');
// const categoryRouter = require('./routes/category');
// const subCategoryRouter = require('./routes/sub_category');
// const productRouter = require('./routes/product');
// const productReviewRouter = require('./routes/rating_review');
// const vendorRouter = require('./routes/vendor');
// const orderRouter = require('./routes/order');
// const cors = require('cors');

// // Define the Port number the server will listen on
// const PORT = 3000;

// // dotenv.config(); // Load environment variables
// // connectDB(); // Connect to MongoDB

// // Create an instance of the express application
// // because it give us the starting point for the server
// const app = express();
// // mongodb String
// const DB = "mongodb+srv://amitkumar:amitkvfullstack@cluster0.okb0k.mongodb.net/"
// // middleware - to register routes or to mount routes
// app.use(express.json());
// app.use(cors());///enable cores for all routes and origin
// // app.use("/api/otp", otpRoutes); // Use OTP routes
// app.use(authRouter);
// app.use(bannerRouter);
// app.use(categoryRouter);
// app.use(subCategoryRouter);
// app.use(productRouter);
// app.use(productReviewRouter);
// app.use(vendorRouter);
// app.use(orderRouter);
// // Connect to the database..
// mongoose.connect(DB, {
//     useNewUrlParser: true,
//     useUnifiedTopology: true
// }).then(() => {
//     console.log("connection successful");
// }).catch((err) => console.log("no connection"));

// // Start the server and listen on the specified port
// app.listen(PORT, "0.0.0.0", function () {
//     // Log The Number
//     console.log(`Server started on http://localhost:${PORT}`);
// });