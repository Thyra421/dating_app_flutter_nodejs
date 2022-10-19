import { insertHobbies } from "../models/hobbies.js"
import { insertSettings } from "../models/settings.js"
import { insertUser, userExists } from "../models/users.js"
import { DEFAULT_SETTINGS } from "../config/default_settings.js"
import { ErrorCodes } from "../config/error_codes.js"
import { error, success } from "../utils/responses.js"
import { generateToken } from "../utils/token.js"

export async function register(req, res) {
    const query = {
        mail: req.body.mail
    }

    if (await userExists(query))
        return error(res, ErrorCodes.USER_ALREADY_EXISTS)

    const newUser = {
        mail: req.body.mail,
        password: req.body.password
    }

    const userId = await insertUser(newUser)

    const newHobbies = {
        user_id: userId,
        hobbies: []
    }

    await insertHobbies(newHobbies)

    const newSettings = {
        user_id: userId,
        settings: DEFAULT_SETTINGS
    }

    await insertSettings(newSettings)

    const token = generateToken(userId)

    return success(res, token)
}