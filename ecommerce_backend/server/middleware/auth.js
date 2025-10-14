// In middleware/auth.js

// const admin = require('firebase-admin');

const auth = async (req, res, next) => {
    try {
        // 1. Get the token from the 'Authorization' header sent by Flutter.
        const authHeader = req.header('Authorization');

        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            // This message matches the server log you received, but now it's for the correct header.
            return res.status(401).json({ msg: 'No authentication token, authorization denied.' });
        }

        // 2. Extract the token from the "Bearer <token>" string.
        const token = authHeader.split(' ')[1];

        // 3. Verify the token using the Firebase Admin SDK. This is the crucial step.
        const decodedToken = await admin.auth().verifyIdToken(token);

        if (!decodedToken) {
            return res.status(401).json({ msg: 'Token is not valid, authorization denied.' });
        }

        // 4. Attach the Firebase User ID (uid) to the request.
        // Your route handler can now access the user's ID via `req.user`.
        req.user = decodedToken.uid;

        next(); // The token is valid, proceed to the actual route (e.g., get orders).

    } catch (e) {
        // This will catch errors for expired tokens, malformed tokens, etc.
        res.status(401).json({ error: 'Token verification failed.', details: e.message });
    }
};


// You can keep your vendorAuth middleware if you have a way to determine roles from Firebase
const vendorAuth = (req, res, next) => {
    // Note: You will need to adjust your vendor logic.
    // The `decodedToken` from firebase can contain custom claims if you set them.
    // For now, we'll just let it pass to fix the main issue.
    next();
};


module.exports = { auth, vendorAuth };