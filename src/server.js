'use strict'

const express = require('express')

// Constants
const NODE_ENV = process.env.NODE_ENV || 'development'
const HOST = (NODE_ENV === 'production') ? 'example.com' : 'localhost'
const PORT = process.env.PORT || 5000

if (NODE_ENV !== 'production') {
  require('dotenv').config()
}

// App
const app = express()
app.get('/', (req, res) => res.status(200).type('html').send('Hello World'))


// app.listen(PORT, HOST)
// console.log(`Running on http://${HOST}:${PORT}`)
app.listen(PORT, HOST, () => console.log(`Running on http://${HOST}:${PORT}`))
