
const express = require('express');
const admin = require('firebase-admin');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// Initialize Firebase Admin SDK
const serviceAccount = require('./path-to-your-service-account-key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Send notification endpoint
app.post('/send-notification', async (req, res) => {
  const { token, title, body } = req.body;

  try {
    const message = {
      notification: {
        title: title,
        body: body
      },
      token: token
    };

    await admin.messaging().send(message);
    res.status(200).send('Notification sent successfully');
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).send('Error sending notification');
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});