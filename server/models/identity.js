import { identity } from "./database.js"

export async function selectIdentity(query) {
    return await identity.findOne(query)
}

export async function insertIdentity(newIdentity) {
    await identity.insertOne(newIdentity)
}

export async function replaceIdentity(query, newIdentity) {
    const newIdentityEntries = Object.entries(newIdentity)

    const setNewIdentityEntries = newIdentityEntries.map(s => {
        s[0] = `identity.${s[0]}`
        return s
    })

    const setNewIdentity = { "$set": Object.fromEntries(setNewIdentityEntries) }

    await identity.updateOne(query, setNewIdentity)

}