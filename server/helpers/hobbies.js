import { insertHobbies, selectHobbies } from "../database/database.js";
import { ErrorCodes } from "../error_codes.js";
import { checkAuthorization } from "../utils/header.js";
import { error, success } from "../utils/response.js";

export async function getHobbies(req, res) {
    const id = checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.UNAUTHORIZED)
    const hobbies = await selectHobbies({ "_id": id })
    return success(res, hobbies)
}

export async function addHobbies(req, res) {
    const id = checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.UNAUTHORIZED)

    await insertHobbies({ "hobbies": ["helllo", "pizza"], "user_id": id })

    return success(res, "gg")
}