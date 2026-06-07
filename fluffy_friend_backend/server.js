if (process.env.NODE_ENV !== 'production') {
  require('dotenv').config();
}

const express = require('express');
const cors = require('cors');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

const app = express();

app.use(cors()); 
app.use(express.json()); 

app.post('/create-payment-intent', async (req, res) => {
  try {
    const { amount, currency } = req.body;

    console.log(`Received checkout request for: ${amount} ${currency}`);

    const paymentIntent = await stripe.paymentIntents.create({
      amount: parseInt(amount), 
      currency: currency || 'MYR',
      automatic_payment_methods: { enabled: true },
    });

    res.json({ client_secret: paymentIntent.client_secret });
    
  } catch (error) {
    console.error("Stripe Engine Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Fluffy Friend Backend running on port ${PORT}`);
});