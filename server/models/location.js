import { location } from "./database.js"

export async function selectLocation(query) {
    return await location.findOne(query)
}

export async function insertLocation(newLocation) {
    await location.insertOne(newLocation)
}

export async function replaceLocation(query, newLocation) {
    const newLocationEntries = Object.entries(newLocation)

    const setNewLocationEntries = newLocationEntries.map(s => {
        s[0] = `location.${s[0]}`
        return s
    })

    const setNewLocation = { "$set": Object.fromEntries(setNewLocationEntries) }

    await location.updateOne(query, setNewLocation)

}