const express = require('express')
const cors = require('cors')
const bodyParser = require("body-parser")
const jwt = require("jsonwebtoken")
const mongo = require('mongodb')

const PORT = 8080
const SECRET = "123"
const MONGO_URL = "mongodb://localhost:27017/";

const app = express()
app.use(cors())
app.use(bodyParser.json())


const mongo_client = new mongo.MongoClient(MONGO_URL);
const database = mongo_client.db("lust");
const collection = database.collection("user");

app.listen(PORT, () => {
    console.log(`Server listening at http://localhost:${PORT}`)
})

app.get('/', (req, res) => {
    res.send("OK")
})

app.get('/login', (req, res) => {
    var token = jwt.sign({ "username": "bob", "password": "pass1234" }, SECRET, { expiresIn: 20 })
    res.send(token)
})

app.post('/register', async (req, res) => {
    try {
        const newUser = {
            username: req.body.username,
            password: req.body.password,
        }
        await collection.insertOne(newUser);
    } finally {
        await mongo_client.close()
    }
    res.send("OK")
})

app.get('/test', (req, res) => {
    jwt.verify(req.headers.authorization, SECRET, (err, token) => {
        if (err) {
            res.send("Error")
        } else {
            res.send("OK")
        }
    })
})