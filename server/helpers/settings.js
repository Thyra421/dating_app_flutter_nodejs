import { selectSettings, replaceSettings } from "../models/settings.js"
import { ErrorCodes } from "../config/error_codes.js"
import { checkAuthorization } from "../utils/header.js"
import { error, success } from "../utils/responses.js"

export async function getSettings(req, res) {
    const id = checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { user_id: id }

    const settings = await selectSettings(query)
    if (settings === null)
        return error(res, ErrorCodes.NOT_FOUND)
    return success(res, settings.settings)
}

export async function setSettings(req, res) {
    const id = checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { user_id: id }
    const newSettings = req.body

    await replaceSettings(query, newSettings)
    return success(res, "OK")
}