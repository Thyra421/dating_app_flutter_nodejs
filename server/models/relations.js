import { relations } from "./database.js"

export async function selectRelations(query) {
    return await relations.findOne(query)
}

export async function insertRelations(newRelations) {
    await relations.insertOne(newRelations)
}

export async function updateRemoveRelations(query, newRelations) {
    const newRelationsEntries = Object.entries(newRelations)

    const setNewRelationsEntries = newRelationsEntries.map(s => {
        s[0] = `relations.${s[0]}`
        s[1] = { $in: s[1] }
        return s
    })

    const pullRelations = { $pull: Object.fromEntries(setNewRelationsEntries) }

    await relations.updateOne(query, pullRelations)
}

export async function updateAddRelations(query, newRelations) {
    const newRelationsEntries = Object.entries(newRelations)

    const setNewRelationsEntries = newRelationsEntries.map(s => {
        s[0] = `relations.${s[0]}`
        s[1] = { $each: s[1] }
        return s
    })

    const pushRelations = { $push: Object.fromEntries(setNewRelationsEntries) }

    await relations.updateOne(query, pushRelations)
}