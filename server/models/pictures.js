import { pictures } from "./database.js"

export async function selectPictures(query) {
    return await pictures.findOne(query)
}

export async function insertPictures(newPictures) {
    await pictures.insertOne(newPictures)
}

export async function updateRemovePicture(query, pictureToRemove) {
    const pullPictures = { $pull: { 'pictures.pictures': pictureToRemove } }

    await pictures.updateOne(query, pullPictures)
}

export async function updateAddPictures(query, newPictures) {
    const newPicturesEntries = Object.entries(newPictures)

    const setNewPicturesEntries = newPicturesEntries.map(s => {
        s[0] = `pictures.${s[0]}`
        s[1] = { $each: s[1] }
        return s
    })

    const pushPictures = { $push: Object.fromEntries(setNewPicturesEntries) }

    await pictures.updateOne(query, pushPictures)
}

export async function replacePictures(query, newPictures) {
    const newPicturesEntries = Object.entries(newPictures)

    const setNewPicturesEntries = newPicturesEntries.map(s => {
        s[0] = `pictures.${s[0]}`
        return s
    })

    const setNewPictures = { $set: Object.fromEntries(setNewPicturesEntries) }

    await pictures.updateOne(query, setNewPictures)
}