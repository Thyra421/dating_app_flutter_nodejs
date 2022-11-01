import { hobbies } from "./database.js"

export async function selectHobbies(query) {
    return await hobbies.findOne(query)
}

export async function insertHobbies(newHobbies) {
    await hobbies.insertOne(newHobbies)
}

export async function replaceHobbies(query, newHobbies) {
    const newHobbiesEntries = Object.entries(newHobbies)

    const setNewHobbiesEntries = newHobbiesEntries.map(s => {
        s[0] = `hobbies.${s[0]}`
        return s
    })

    const setNewHobbies = { "$set": Object.fromEntries(setNewHobbiesEntries) }

    await hobbies.updateOne(query, setNewHobbies)
}