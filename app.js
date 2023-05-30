const express = require('express')
const path = require('path')

const app = express()

// Define the public directory path
const publicDirectoryPath = path.join(__dirname, 'public')

// Configure static file serving
app.use(express.static(publicDirectoryPath))

// Start the server
app.listen(3000, () => {
    console.log('Server is running on port 3000')
})
