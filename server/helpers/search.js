import { DISTANCES } from '../config/distances.js'
import { searchBestMatch } from "../models/search.js"
import { ErrorCodes } from "../config/error_codes.js"
import { checkAuthorization } from "../utils/header.js"
import { error, success } from "../utils/responses.js"
import { selectHobbies } from "../models/hobbies.js"
import { selectLocation } from "../models/location.js"
import { selectSettings } from "../models/settings.js"
import { selectRelations } from "../models/relations.js"

export async function search(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const hobbies = await selectHobbies(query)
    const location = await selectLocation(query)
    const settings = await selectSettings(query)
    const relations = await selectRelations(query)
    const match = await searchBestMatch(id, hobbies.hobbies.hobbies,
        location.location.posX, location.location.posY,
        DISTANCES[settings.settings.maxDistance],
        relations.relations.blocked, relations.relations.notInterested)
    return success(res, match)
}