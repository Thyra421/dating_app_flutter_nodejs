const express = require('express')
const cors = require('cors')
const bodyParser = require("body-parser")
const jwt = require("jsonwebtoken")
const { MongoClient } = require('mongodb')

const PORT = 8080
const SECRET = "123"
const MONGO_URL = "mongodb://localhost:27017/"

const app = express()
const mongo = new MongoClient(MONGO_URL)

app.use(cors())
app.use(bodyParser.json())

mongo.connect()

const database = mongo.db('lust')
const users = database.collection("users")

app.listen(PORT, () => {
    console.log(`Server listening at http://localhost:${PORT}`)
})

app.get('/', (req, res) => {
    return res.send("OK")
})

app.post('/login', async (req, res) => {
    const query = {
        username: req.body.username,
        password: req.body.password
    }

    if (await users.countDocuments(query) === 0)
        return res.status(401).send("KO")

    const cursor = await users.findOne(query)
    console.log(cursor)

    const token = jwt.sign(cursor, SECRET, { expiresIn: 20 })
    return res.send(token)
})

app.post('/register', async (req, res) => {
    const newUser = {
        username: req.body.username,
        password: req.body.password
    }
    const result = await users.insertOne(newUser)
    return res.send("OK")
})