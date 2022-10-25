import express from 'express'
import cors from 'cors'
import bodyParser from 'body-parser'
import { login } from './helpers/login.js'
import { register } from './helpers/register.js'
import { setHobbies, getHobbies } from './helpers/hobbies.js'
import { getSettings, setSettings } from './helpers/settings.js'
import { SERVER_PORT } from './config/port.js'
import { getSteps, setSteps } from './helpers/steps.js'
import { getIdentity, setIdentity } from './helpers/identity.js'
import { search } from './helpers/search.js'

const app = express()
app.use(cors())
app.use(bodyParser.json())

app.listen(SERVER_PORT, () => {
    console.log(`Server listening at http://localhost:${SERVER_PORT}`)
})

app.get('/', (req, res) => {
    return res.send("Server online")
})

app.post('/login', login)

app.post('/register', register)

app.get('/hobbies', getHobbies)
app.put('/hobbies', setHobbies)

app.get('/settings', getSettings)
app.put('/settings', setSettings)

app.get('/steps', getSteps)
app.put('/steps', setSteps)

app.get('/identity', getIdentity)
app.put('/identity', setIdentity)

app.get('/search', search)