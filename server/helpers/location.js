import { selectLocation, replaceLocation } from "../models/location.js"
import { ErrorCodes } from "../config/error_codes.js"
import { checkAuthorization } from "../utils/header.js"
import { error, success } from "../utils/responses.js"

export async function getLocation(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }

    const location = await selectLocation(query)
    return success(res, location.location)
}

export async function setLocation(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const newLocation = req.body

    await replaceLocation(query, newLocation)
    return success(res, "OK")
}