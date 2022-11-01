import { selectHobbies, replaceHobbies } from "../models/hobbies.js"
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

export async function setHobbies(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const newHobbies = req.body

    await replaceHobbies(query, newHobbies)
    return success(res, "OK")
}