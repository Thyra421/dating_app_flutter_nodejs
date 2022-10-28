import { trySelectUser } from "../models/users.js"
import { ErrorCodes } from "../config/error_codes.js"
import { error, success } from "../utils/responses.js"
import { generateToken } from "../utils/token.js"
import bcrypt from 'bcryptjs'

export async function login(req, res) {
    /// Find the user
    const query = { mail: req.body.mail }
    const user = await trySelectUser(query)
    if (user === null)
        return error(res, ErrorCodes.USER_NOT_FOUND)

    /// Verify password
    if (!bcrypt.compareSync(req.body.password, user.password))
        return error(res, ErrorCodes.WRONG_CREDENTIALS)

    /// Generate jwt
    const userId = user._id.toString()
    const token = generateToken(userId)
    return success(res, token)
}