import { searchCommonHobbies } from "../models/search.js"
import { ErrorCodes } from "../config/error_codes.js"
import { checkAuthorization } from "../utils/header.js"
import { error, success } from "../utils/responses.js"
import { selectHobbies } from "../models/hobbies.js"
import { selectIdentity } from "../models/identity.js"

export async function search(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const hobbies = await selectHobbies(query)
    const identity = await selectIdentity(query)
    const matches = await searchCommonHobbies(hobbies.hobbies, id, parseInt(req.query.maxMatches) ?? 5,
        identity.identity.posX, identity.identity.posY, parseInt(req.query.maxDistance) ?? 3)
    return success(res, matches)
}