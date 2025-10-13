const express = require('express');
const User = require('../models/user');
const bcrypt = require('bcryptjs');
const authRouter = express.Router();
const jwt = require('jsonwebtoken');

// res = response, req = request....
authRouter.post('/api/signup', async (req, res) => {
    try {
        const { fullName, email, password } = req.body;
        const existingEmail = await User.findOne({ email });
        if (existingEmail) {
            return res.status(400).json({ msg: "User with Same Email already exists" });
        } else {
            // generate a salt with a cost factor of 10
            const salt = await bcrypt.genSalt(10);
            // hash the password using the generated salt
            const hashedPassword = await bcrypt.hash(password, salt);
            let user = new User({ fullName, email, password: hashedPassword });
            result = await user.save();
            res.json({ result });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

//signin api endpoint
authRouter.post('/api/signin', async (req, res) => {
    try {
        const { email, password } = req.body;
        const findUser = await User.findOne({ email });
        if (!findUser) {
            return res.status(400).json({ msg: "User does not exist" });
        } else {
            const isMatch = await bcrypt.compare(password, findUser.password);
            if (!isMatch) {
                return res.status(400).json({ msg: "Incorrect Password" });
            } else {
                const token = jwt.sign({ id: findUser._id }, "passwordKey");
                // remove sensitive data from the user object...
                const { password, ...userWithoutPassword } = findUser._doc;
                // send the response...   
                res.json({ token, user: userWithoutPassword });
            }
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Put route for updating user;s state, city and locality
authRouter.put('/api/users/:id', async (req, res) => {
    try {
        // Extract the 'id' parameter from the URL
        const { id } = req.params;
        // Ectract the "state","city" and "locality" fields from the request body
        const { state, city, locality } = req.body;
        // Find the user with the specified 'id' and update the state, city, and locality fields
        // the {new:true} option ensures the updated document is returned.
        const updatedUser = await User.findByIdAndUpdate(id, { state, city, locality }, { new: true },);

        // if no user is found, return 4040 page not found status with an error message
        if (!updatedUser) {
            return res.status(404).json({ msg: "User not found" });
        }
        return res.status(200).json(updatedUser);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get route for fetching all users without the password field

authRouter.get('/api/users', async (req, res) => {
    try {
        const users = await User.find().select('-password');
        return  res.status(200).json(users);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
}
);
module.exports = authRouter;