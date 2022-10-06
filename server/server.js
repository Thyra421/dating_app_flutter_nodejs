const express = require('express')
const cors = require('cors')
const bodyParser = require("body-parser")
const jwt = require("jsonwebtoken")
const { MongoClient } = require('mongodb')

const PORT = 8081
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
    res.send("OK")
})

app.post('/login', (req, res) => {
    console.log(req.body);
    if (!((req.body.username ?? "") === 'bob' && (req.body.password ?? "") === 'pwd'))
        return res.status(401).send("Wrong credentials")
    var token = jwt.sign({ "username": "bob", "password": "pwd" }, SECRET, { expiresIn: 20 })
    res.send(token)
})

app.post('/register', async (req, res) => {
    const newUser = {
        username: req.body.username,
        password: req.body.password
    }
    const result = await users.insertOne(newUser)
    res.send(result)
})