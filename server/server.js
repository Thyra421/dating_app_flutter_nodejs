import express from 'express'
import cors from 'cors'
import bodyParser from 'body-parser'

import { SERVER_PORT } from './config/port.js'

import { login } from './helpers/login.js'
import { register } from './helpers/register.js'
import { getHobbies, removeHobbies, addHobbies, setHobbies } from './helpers/hobbies.js'
import { getSettings, setSettings } from './helpers/settings.js'
import { getSteps, setSteps } from './helpers/steps.js'
import { getIdentity, setIdentity } from './helpers/identity.js'
import { getLocation, setLocation } from './helpers/location.js'
import { addRelations, getRelations, removeRelations } from './helpers/relations.js'
import { search } from './helpers/search.js'

const app = express()
app.use(cors())
app.use(bodyParser.json())

app.listen(SERVER_PORT, () => {
    console.log(`Server listening at http://localhost:${SERVER_PORT}`)
})

app.get('/', (_, res) => {
    return res.send("Server online")
})

app.post('/login', login)

app.post('/register', register)

app.get('/hobbies', getHobbies)
app.put('/hobbies', setHobbies)
app.patch('/hobbies/add', addHobbies)
app.patch('/hobbies/remove', removeHobbies)

app.get('/settings', getSettings)
app.put('/settings', setSettings)

app.get('/steps', getSteps)
app.put('/steps', setSteps)

app.get('/identity', getIdentity)
app.put('/identity', setIdentity)

app.get('/location', getLocation)
app.put('/location', setLocation)

app.get('/relations', getRelations)
app.patch('/relations/add', addRelations)
app.patch('/relations/remove', removeRelations)

app.get('/search', search)