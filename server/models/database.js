import { MongoClient, ObjectId } from 'mongodb'
import { DB_URL } from '../config/db_url.js'

const mongo = new MongoClient(DB_URL)
export const createObjectId = ObjectId

mongo.connect()

const database = mongo.db('lust')
export const users = database.collection("users")
export const hobbies = database.collection("hobbies")
export const settings = database.collection("settings")
export const steps = database.collection("steps")
export const identity = database.collection("identity")
export const location = database.collection("location")
export const relations = database.collection("relations")
export const pictures = database.collection("pictures")