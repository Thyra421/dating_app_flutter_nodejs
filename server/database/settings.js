import { settings } from "./database.js"

export async function settingsExists(query) {
    return await settings.countDocuments(query) > 0
}

export async function selectSettings(query) {
    return await settings.findOne(query)
}

export async function trySelectSettings(query) {
    if (!await settingsExists(query))
        return null

    return trySelectSettings(query)
}

export async function insertSettings(newSettings) {
    await settings.insertOne(newSettings)
}

export async function replaceSettings(query, newSettings) {
    const setNewSettings = { "$set": newSettings }
    const a = await settings.updateOne(query, setNewSettings)

}