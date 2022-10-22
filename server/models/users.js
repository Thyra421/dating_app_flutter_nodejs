import { users } from "./database.js"

export async function userExists(query) {
    const count = await users.countDocuments(query)
    return count > 0
}

export async function selectUser(query) {
    return await users.findOne(query)
}

export async function trySelectUser(query) {
    if (!await userExists(query))
        return null

    return selectUser(query)
}

export async function insertUser(query) {
    return (await users.insertOne(query)).insertedId.toString()

}