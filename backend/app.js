const express = require('express');
const dotenv = require('dotenv');
const plantsRoutes = require('./routes/plants');
const cors = require('cors');

// Load environment variables from .env file
dotenv.config();

const app = express();

// Middleware to parse JSON requests
app.use(express.json());

// Enable Cross-Origin Resource Sharing (CORS)
app.use(cors());

// Plant routes
app.use('/plants', plantsRoutes); // Routes for managing plants

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
