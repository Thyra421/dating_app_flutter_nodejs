import { MongoClient } from 'mongodb'

const MONGO_URL = "mongodb://localhost:27017/"

const mongo = new MongoClient(MONGO_URL)
mongo.connect()

const database = mongo.db('lust')
export const users = database.collection("users")
export const hobbies = database.collection("hobbies")
export const settings = database.collection("settings")