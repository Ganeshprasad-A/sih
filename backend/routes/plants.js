const express = require('express');
const connectDB = require('../config/db');
const { getFileUrl } = require('../config/aws');

const router = express.Router();
const bucketName = process.env.S3_BUCKET;

// Get all plants
router.get('/', async (req, res) => {
  console.log('Request received at /plants');
  try {
    const db = await connectDB();
    const plants = await db.collection('plants').find().toArray();

    if (plants.length === 0) {
      return res.status(404).json({ message: 'No plants found' });
    }

    // Add S3 URLs for audio, video, and models to each plant
    const updatedPlants = plants.map((plant) => ({
      ...plant,
      imageUrl: plant.imageKey ? getFileUrl(bucketName, `image/${plant.imageKey}`) : null, // Add image folder prefix
      audioUrl: plant.audioKey ? getFileUrl(bucketName, `audio/${plant.audioKey}`) : null, // Add audio folder prefix
      videoUrl: plant.videoKey ? getFileUrl(bucketName, `video/${plant.videoKey}`) : null, // Add video folder prefix
      modelUrl: plant.modelKey ? getFileUrl(bucketName, `model/${plant.modelKey}`) : null, // Add models folder prefix
    }));
    

    res.status(200).json(updatedPlants);
    console.log(updatedPlants);
  } catch (error) {
    console.error('Error fetching plants:', error);
    res.status(500).json({ error: 'Failed to fetch plants' });
  }
});

module.exports = router;