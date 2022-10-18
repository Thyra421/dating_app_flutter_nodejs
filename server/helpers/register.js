import { insertHobbies } from "../database/hobbies.js"
import { insertSettings } from "../database/settings.js"
import { insertUser, userExists } from "../database/users.js"
import { DEFAULT_SETTINGS } from "../default_settings.js"
import { ErrorCodes } from "../error_codes.js"
import { error, success } from "../utils/response.js"

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

    return success(res, "OK")
}