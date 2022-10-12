import { MongoClient } from 'mongodb'

const MONGO_URL = "mongodb://localhost:27017/"

const mongo = new MongoClient(MONGO_URL)
mongo.connect()

const database = mongo.db('lust')
const users = database.collection("users")
const hobbies = database.collection("hobbies")

export async function userExists(query) {
    return await users.countDocuments(query) > 0
}

export async function selectUser(query) {
    const cursor = await users.findOne(query)
    return cursor
}

export async function trySelectUser(query) {
    if (!await userExists(query))
        return null

    const cursor = await users.findOne(query)
    return cursor
}

export async function insertUser(query) {
    await users.insertOne(query)
}

/// HOBBIES ///

export async function hobbiesExists(query) {
    return await hobbies.countDocuments(query) > 0
}

export async function selectHobbies(query) {
    await hobbies.findOne(query)
}

export async function trySelectHobbies(query) {
    if (!await hobbiesExists(query))
        return null

    const cursor = await hobbies.findOne(query)
    return cursor
}

export async function insertHobbies(query) {
    await hobbies.insertOne(query)
}

export async function updateHobbies(query, newHobbies) {
    await hobbies.findOneAndReplace(query, newHobbies)
}