import { selectHobbies, updateAddHobbies, updateRemoveHobbies, replaceHobbies } from "../models/hobbies.js"
import { ErrorCodes } from "../config/error_codes.js"
import { checkAuthorization } from "../utils/header.js"
import { error, success } from "../utils/responses.js"

export async function getHobbies(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }

    const hobbies = await selectHobbies(query)
    return success(res, hobbies.hobbies)
}

export async function removeHobbies(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const hobbiesToRemove = req.body

    await updateRemoveHobbies(query, hobbiesToRemove)
    return success(res, "OK")
}


export async function addHobbies(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const hobbiesToAdd = req.body

    await updateAddHobbies(query, hobbiesToAdd)
    return success(res, "OK")
}

export async function setHobbies(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const newHobbies = req.body

    await replaceHobbies(query, newHobbies)
    return success(res, "OK")
}