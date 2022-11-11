import crypto from 'crypto'

import { replacePictures, selectPictures, updateAddPictures, updateRemovePicture } from "../models/pictures.js"
import { ErrorCodes } from "../config/error_codes.js"
import { checkAuthorization } from "../utils/header.js"
import { error, success } from "../utils/responses.js"
import { deleteFile, downloadFile, uploadFile } from "../utils/s3.js"

export async function removePicture(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    await deleteFile(req.body.name)

    const query = { userId: id }
    const pictureToRemove = req.body

    await updateRemovePicture(query, pictureToRemove)
    return success(res, "OK")
}

export async function setPictures(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const newPictures = req.body

    await replacePictures(query, newPictures)
    return success(res, "OK")
}

export async function addPicture(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const originalName = req.file.originalname
    const name = crypto.randomBytes(32).toString('hex')

    await uploadFile(req.file, name)

    const query = { userId: id }
    const newPicture = { name: name, originalName: originalName }
    const picturesToAdd = { pictures: [newPicture] }

    await updateAddPictures(query, picturesToAdd)

    const url = await downloadFile(name)
    return success(res, { ...newPicture, url: url })
}

export async function getPictures(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    var pictures = await selectPictures(query)

    // Insert a url field to all pictures 
    pictures.pictures.pictures = await Promise.all(pictures.pictures.pictures.map(
        async picture => {
            const url = await downloadFile(picture.name)
            return { ...picture, url: url }
        }
    ))

    return success(res, pictures.pictures)
}