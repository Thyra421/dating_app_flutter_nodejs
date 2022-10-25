import { selectIdentity, replaceIdentity } from "../models/identity.js"
import { ErrorCodes } from "../config/error_codes.js"
import { checkAuthorization } from "../utils/header.js"
import { error, success } from "../utils/responses.js"

export async function getIdentity(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }

    const identity = await selectIdentity(query)
    return success(res, identity.identity)
}

export async function setIdentity(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const newIdentity = req.body

    await replaceIdentity(query, newIdentity)
    return success(res, "OK")
}