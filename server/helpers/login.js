import { trySelectUser } from "../models/users.js"
import { ErrorCodes } from "../config/error_codes.js"
import { error, success } from "../utils/responses.js"
import { generateToken } from "../utils/token.js"
import { selectSteps } from "../models/steps.js"

export async function login(req, res) {
    /// Find the user
    const query = { mail: req.body.mail, password: req.body.password }
    const user = await trySelectUser(query)
    if (user === null)
        return error(res, ErrorCodes.USER_NOT_FOUND)
    const userId = user._id.toString()

    /// Find steps of the user
    const steps = selectSteps({ userId: userId })

    /// Generate jwt
    const token = generateToken(userId)
    return success(res, token)
}