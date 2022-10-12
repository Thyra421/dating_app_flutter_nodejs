import express from 'express'
import cors from 'cors'
import bodyParser from 'body-parser'
import { login } from './helpers/login.js'
import { register } from './helpers/register.js'
import { addHobbies, getHobbies } from './helpers/hobbies.js'

const PORT = 8080

const app = express()
app.use(cors())
app.use(bodyParser.json())

app.listen(PORT, () => {
    console.log(`Server listening at http://localhost:${PORT}`)
})

app.get('/', (req, res) => {
    return res.send("Server online")
})

app.post('/login', login)

app.post('/register', register)

app.get('/hobbies', getHobbies)

app.post('/hobbies', addHobbies)