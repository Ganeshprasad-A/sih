const { MongoClient } = require('mongodb');
require('dotenv').config();

// Initialize MongoDB client with the URI from environment variables
const mongoClient = new MongoClient(process.env.MONGO_URI);

/**
 * Function to connect to MongoDB and return the database instance
 * @returns {object} - MongoDB database instance
 */
async function connectDB() {
  try {
    await mongoClient.connect();
    console.log('Connected to MongoDB');
    return mongoClient.db('Herbal'); // Replace 'Herbal' with your database name if needed
  } catch (error) {
    console.error('Error connecting to MongoDB:', error);
    throw error; // Propagate error for handling in calling functions
  }
}

module.exports = connectDB;
