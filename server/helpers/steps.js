import { selectSteps, replaceSteps } from "../models/steps.js"
import { ErrorCodes } from "../config/error_codes.js"
import { checkAuthorization } from "../utils/header.js"
import { error, success } from "../utils/responses.js"

export async function getSteps(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }

    const steps = await selectSteps(query)
    return success(res, steps.steps)
}

export async function setSteps(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const newSteps = req.body

    await replaceSteps(query, newSteps)
    return success(res, "OK")
}