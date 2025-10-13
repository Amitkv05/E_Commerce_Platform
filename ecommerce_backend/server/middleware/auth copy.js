// const jwt = require('jsonwebtoken');
// const User = require('../models/user');
// const Vendor = require('../models/vendor');

// // authentication middleware
// // this middleware function checks if the user is authenticated

// // const auth = async (req, res, next) => {
// //     try {
// //         // extract the token from the request header
// //         const token = req.header('x-auth-token');

// //         // if no tokken is provided, return 401(unauthorized) response with an error message
// //         if (!token) return res.status(401).json({ msg: 'No authentication token, authorization denied.' });

// //         // verify the jwt token using the secret key
// //         const verified = jwt.verified(token, "passwordKey");
// //         // if the tokenn verification failed, return 401,
// //         if (!verified) return res.status(401).json({ msg: 'Token verification failed, authorization denied.' });

// //         // find the user or vendor in the database using the id stored in the token payload...
// //         const user = await User.findById(verified.id) || await Vendor.findById(verified.id);
// //         // if the user or vendor is not found, return 401
// //         if (!user) return res.status(401).json({ msg: 'User or Vendor not found, authorization denied.' });

// //         // attact the authenticated user (whether a normal user or a vendor) to the request object
// //         // this makes the user's data available to any subsequent middleware or route handler
// //         req.user = user;
// //         // also attact the token to the request object in case is needed later
// //         req.token = token;

// //         // proceed to the next middleware or route handler
// //         next();

// //     } catch (e) {
// //         // handle any errors that occur during the authentication process
// //         res.status(500).json({ error: e.message });
// //     }
// // };
// const auth = async (req, res, next) => {
//     try {
//         const token = req.header('x-auth-token');
//         console.log("Received Token in Backend:", token); // Debugging

//         if (!token) return res.status(401).json({ msg: 'No authentication token, authorization denied.' });

//         const verified = jwt.verify(token, "passwordKey");
//         console.log("Verified Payload:", verified); // Debugging

//         const user = await User.findById(verified.id) || await Vendor.findById(verified.id);
//         if (!user) return res.status(401).json({ msg: 'User or Vendor not found, authorization denied.' });

//         req.user = user;
//         req.token = token;
//         next();

//     } catch (e) {
//         console.error("Authentication Error:", e.message);
//         res.status(500).json({ error: e.message });
//     }
// };
// // vendor authentication middleware
// // this middleware ensures that the user making the request is a vendor.
// // it should be used for routes that only vendor can access.

// const vendorAuth = (req, res, next) => {
//     try {

//         // if the user making the request is not a vendor, return 401
//         if (!req.user.role || req.user.role != 'vendor') {
//             // if the user is not a vendor, return 403(Forbidden)response with an error message
//             return res.status(403).json({ msg: 'Vendor access only, authorization denied.' });
//         }
//         //If the user is a vendor, proceed to the next middleware or route handler..
//         next();
//     } catch (error) {
//         return res.status(500).json({ error: error.message });
//     }
// };

// module.exports = { auth, vendorAuth };
