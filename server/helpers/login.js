import { trySelectUser } from "../models/users.js"
import { ErrorCodes } from "../config/error_codes.js"
import { error, success } from "../utils/responses.js"
import { generateToken } from "../utils/token.js"

export async function login(req, res) {
    const query = {
        mail: req.body.mail,
        password: req.body.password
    }

    const user = await trySelectUser(query)

    if (user === null)
        return error(res, ErrorCodes.USER_NOT_FOUND)

    const id = user._id.toString()

    const token = generateToken(id)

    return success(res, token)
}