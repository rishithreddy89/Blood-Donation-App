const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const session = require('express-session');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

// Session configuration
app.use(
    session({
        secret: process.env.SESSION_SECRET,
        resave: false,
        saveUninitialized: false,
        cookie: { secure: false, maxAge: 24 * 60 * 60 * 1000 }, // 24 hours
    })
);

// Connect to MongoDB (updated)
mongoose.connect(process.env.MONGODB_URI)
    .then(() => console.log('Connected to MongoDB'))
    .catch((err) => console.error('Failed to connect to MongoDB:', err));


// Schemas
const UserSchema = new mongoose.Schema({
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    phone: { type: String, required: true },
    age: { type: Number, required: true },
    role: { type: String, enum: ['donor', 'requester'], default: 'donor' },
    createdAt: { type: Date, default: Date.now },
});

const DonorSchema = new mongoose.Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    fullName: { type: String, required: true },
    bloodType: { type: String, required: true },
    location: { type: String, required: true },
    gender: { type: String, required: true },
    healthStatus: { type: Boolean, default: false },
    lastDonation: Date,
    available: { type: Boolean, default: true },
});

const BloodRequestSchema = new mongoose.Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    patientName: { type: String, required: true },
    age: { type: Number, required: true },
    bloodType: { type: String, required: true },
    hospitalName: { type: String, required: true },
    location: { type: String, required: true },
    urgency: { type: String, required: true },
    unitsRequired: { type: Number, required: true },
    contactPerson: { type: String, required: true },
    contactPhone: { type: String, required: true },
    status: { type: String, enum: ['pending', 'fulfilled'], default: 'pending' },
    createdAt: { type: Date, default: Date.now },
});

// Models
const User = mongoose.model('User', UserSchema);
const Donor = mongoose.model('Donor', DonorSchema);
const BloodRequest = mongoose.model('BloodRequest', BloodRequestSchema);

// Middleware to check if user is authenticated
const authMiddleware = (req, res, next) => {
    if (!req.session.userId) {
        return res.status(401).send({ error: 'Please log in to access this resource' });
    }
    next();
};

// Routes

// User Registration
app.post('/api/register', async (req, res) => {
    try {
        const { email, password, phone, age } = req.body;
        const hashedPassword = await bcrypt.hash(password, 10);

        const user = new User({
            email,
            password: hashedPassword,
            phone,
            age,
        });

        await user.save();
        res.status(201).send({ user });
    } catch (error) {
        res.status(400).send({ error: error.message });
    }
});

// User Login
app.post('/api/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });

        if (!user || !(await bcrypt.compare(password, user.password))) {
            throw new Error('Invalid login credentials');
        }

        // Store user ID in session
        req.session.userId = user._id;
        res.send({ user });
    } catch (error) {
        res.status(400).send({ error: error.message });
    }
});

// User Logout
app.post('/api/logout', (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            return res.status(500).send({ error: 'Could not log out, please try again' });
        }
        res.send({ message: 'Logged out successfully' });
    });
});

// Blood Requests
app.post('/api/requests', authMiddleware, async (req, res) => {
    try {
        const request = new BloodRequest({
            ...req.body,
            user: req.session.userId,
        });

        await request.save();
        res.status(201).send(request);
    } catch (error) {
        res.status(400).send({ error: error.message });
    }
});

// Donor Registration
app.post('/api/donors', authMiddleware, async (req, res) => {
    try {
        const donor = new Donor({
            ...req.body,
            user: req.session.userId,
        });

        await donor.save();
        res.status(201).send(donor);
    } catch (error) {
        res.status(400).send({ error: error.message });
    }
});

// Get Nearby Donors
app.get('/api/donors', async (req, res) => {
    try {
        const { location, bloodType } = req.query;
        const donors = await Donor.find({
            location: new RegExp(location, 'i'),
            bloodType,
            available: true,
        }).populate('user');

        res.send(donors);
    } catch (error) {
        res.status(500).send({ error: error.message });
    }
});

// Get Blood Requests
app.get('/api/requests', async (req, res) => {
    try {
        const requests = await BloodRequest.find().populate('user');
        res.send(requests);
    } catch (error) {
        res.status(500).send({ error: error.message });
    }
});

// Get Current User
app.get('/api/me', authMiddleware, async (req, res) => {
    try {
        const user = await User.findById(req.session.userId);
        if (!user) {
            return res.status(404).send({ error: 'User not found' });
        }
        res.send(user);
    } catch (error) {
        res.status(500).send({ error: error.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));