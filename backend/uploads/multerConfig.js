// const multer = require('multer');

// const storage = multer.memoryStorage(); // Stores files in memory buffer
// const upload = multer({
//   storage: storage,
//   limits: { fileSize: 5 * 1024 * 1024 }, // 5 MB limit
//   fileFilter: (req, file, cb) => {
//     if (!['audio/', 'video/'].some(type => file.mimetype.startsWith(type))) {
//       return cb(new Error('Only audio and video files are allowed!'), false);
//     }
//     cb(null, true);
//   },
// });

// module.exports = upload;

const multer = require('multer');

const storage = multer.memoryStorage();
const upload = multer({
  storage: storage,
  limits: { fileSize: 100 * 1024 * 1024 }, // Increase limit to 100 MB
  fileFilter: (req, file, cb) => {
    const allowedTypes = ['audio/', 'video/', 'model/'];
    if (
      allowedTypes.some(type => file.mimetype.startsWith(type)) ||
      file.mimetype === 'application/octet-stream' // For `.obj` files
    ) {
      cb(null, true);
    } else {
      cb(new Error('Only audio, video, and .obj model files are allowed!'), false);
    }
  },
});

module.exports = upload;

