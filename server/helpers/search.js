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
    const matches = await searchCommonHobbies(hobbies.hobbies, id, req.params.max ?? 5)
    const result = await Promise.all(matches.map(async match => {
        const query = { userId: match.userId }
        const identity = await selectIdentity(query)
        return {
            commonHobbiesCount: match.commonHobbiesCount,
            commonHobbies: match.commonHobbies,
            identity: identity.identity
        }
    }))

    return success(res, result)
}