import { hobbies } from "./database.js"

export async function selectHobbies(query) {
    return await hobbies.findOne(query)
}

export async function insertHobbies(newHobbies) {
    await hobbies.insertOne(newHobbies)
}

export async function updateRemoveHobbies(query, newHobbies) {
    const newHobbiesEntries = Object.entries(newHobbies)

    const setNewHobbiesEntries = newHobbiesEntries.map(s => {
        s[0] = `hobbies.${s[0]}`
        s[1] = { $in: s[1] }
        return s
    })

    const pullHobbies = { $pull: Object.fromEntries(setNewHobbiesEntries) }

    await hobbies.updateOne(query, pullHobbies)
}

export async function updateAddHobbies(query, newHobbies) {
    const newHobbiesEntries = Object.entries(newHobbies)

    const setNewHobbiesEntries = newHobbiesEntries.map(s => {
        s[0] = `hobbies.${s[0]}`
        s[1] = { $each: s[1] }
        return s
    })

    const pushHobbies = { $push: Object.fromEntries(setNewHobbiesEntries) }

    await hobbies.updateOne(query, pushHobbies)
}

export async function replaceHobbies(query, newHobbies) {
    const newHobbiesEntries = Object.entries(newHobbies)

    const setNewHobbiesEntries = newHobbiesEntries.map(s => {
        s[0] = `hobbies.${s[0]}`
        return s
    })

    const setNewHobbies = { $set: Object.fromEntries(setNewHobbiesEntries) }

    await hobbies.updateOne(query, setNewHobbies)
}
