const express = require('express')
const cors = require('cors')
const uuid = require('uuid')
const bodyParser = require("body-parser");

const PORT = 8080

const app = express()
app.use(cors())
app.use(bodyParser.json())

app.listen(PORT, () => {
    console.log(`Server listening at http://localhost:${PORT}`)
})

app.get('/', (req, res) => {
    res.send("OK")
})