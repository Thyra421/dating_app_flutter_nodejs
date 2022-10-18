import { selectSettings, replaceSettings } from "../database/settings.js"
import { ErrorCodes } from "../error_codes.js"
import { checkAuthorization } from "../utils/header.js"
import { error, success } from "../utils/response.js"

export async function getSettings(req, res) {
    const id = checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { user_id: id }

    const settings = await selectSettings(query)
    return success(res, settings.settings)
}

export async function setSettings(req, res) {
    const id = checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { user_id: id }
    const newSettings = { settings: req.body }

    await replaceSettings(query, newSettings)
    return success(res, "OK")
}