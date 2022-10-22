import { MongoClient, ObjectId } from 'mongodb'
import { DB_URL } from '../config/db_url.js'

const mongo = new MongoClient(DB_URL)
export const createObjectId = ObjectId;

mongo.connect().catch(() => console.log("Database unreachable"))

const database = mongo.db('lust')
export const users = database.collection("users")
export const hobbies = database.collection("hobbies")
export const settings = database.collection("settings")
export const steps = database.collection("steps")