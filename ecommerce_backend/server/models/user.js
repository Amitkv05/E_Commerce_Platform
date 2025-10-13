const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    fullName: {
        type: String,
        required: true,
        trim: true
    },
    email: {
        type: String,
        required: true,
        trim: true,
        validate: {
            validator: (value) => {
                const result = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                return result.test(value);
            },
            message: "Please enter a valid email address",
        }
    },
    state: {
        type: String,
        default: "",
    },
    city: {
        type: String,
        default: "",
    },
    locality: {
        type: String,
        default: "",
    },
    password: {
        type: String,
        required: true,
        validate: {
            validator: (value) => {
                // check if password contains at least 4 characters long
                return value.length >= 4;
            },
            message: "Password must be at least 4 characters long",
            // validator: (value) => {
            //     const result = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,20}$/;
            //     return result.test(value);
            // },
            // message: "Password must contain at least one numeric digit, one uppercase and one lowercase letter, and at least 6 or more characters",
        }
    }
});

const User = mongoose.model('User', userSchema);
module.exports = User;