const { S3Client, GetObjectCommand } = require('@aws-sdk/client-s3');
require('dotenv').config();

// Initialize the S3 client with AWS SDK v3
const s3 = new S3Client({
  region: process.env.AWS_REGION, // AWS region (e.g., us-east-1)
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY, // Access key from .env
    secretAccessKey: process.env.AWS_SECRET_KEY, // Secret key from .env
  },
});

/**
 * Function to generate a public file URL for S3
 * @param {string} bucketName - Name of the S3 bucket
 * @param {string} key - Key (file path) in the S3 bucket
 * @returns {string} - Public URL of the file
 */
const getFileUrl = (bucketName, key) => {
  const url = `https://${bucketName}.s3.${process.env.AWS_REGION}.amazonaws.com/${key}`;
  return url;
};

// Export the S3 client and the helper function
module.exports = { s3, getFileUrl };
