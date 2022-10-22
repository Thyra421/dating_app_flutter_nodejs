import { steps } from "./database.js"

export async function selectSteps(query) {
    return await steps.findOne(query)
}

export async function insertSteps(newSteps) {
    await steps.insertOne(newSteps)
}

export async function replaceSteps(query, newSteps) {
    const newStepsEntries = Object.entries(newSteps)

    const setNewStepsEntries = newStepsEntries.map(s => {
        s[0] = `steps.${s[0]}`
        return s
    })

    const setNewSteps = { "$set": Object.fromEntries(setNewStepsEntries) }

    await steps.updateOne(query, setNewSteps)
}