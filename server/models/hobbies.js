import { hobbies } from "./database.js"

export async function hobbiesExists(query) {
    return await hobbies.countDocuments(query) > 0
}

export async function selectHobbies(query) {
    return await hobbies.findOne(query)
}

export async function trySelectHobbies(query) {
    if (!await hobbiesExists(query))
        return null

    return trySelectHobbies(query)
}

export async function insertHobbies(newHobbies) {
    await hobbies.insertOne(newHobbies)
}

export async function replaceHobbies(query, newHobbies) {
    const setNewHobbies = { "$set": newHobbies }
    await hobbies.updateOne(query, setNewHobbies)
}