import { insertHobbies } from "../models/hobbies.js"
import { insertSettings } from "../models/settings.js"
import { insertUser, userExists } from "../models/users.js"
import { DEFAULT_SETTINGS, DEFAULT_STEPS } from "../config/default.js"
import { ErrorCodes } from "../config/error_codes.js"
import { error, success } from "../utils/responses.js"
import { generateToken } from "../utils/token.js"
import { insertSteps } from "../models/steps.js"

export async function register(req, res) {
    /// Check if user alread exists    
    const query = { mail: req.body.mail }
    if (await userExists(query))
        return error(res, ErrorCodes.USER_ALREADY_EXISTS)

    /// Create new user
    const newUser = { mail: req.body.mail, password: req.body.password }
    const newUserId = await insertUser(newUser)

    /// Create resources for the user
    const newHobbies = { userId: newUserId, hobbies: [] }
    const newSettings = { userId: newUserId, settings: DEFAULT_SETTINGS }
    const newSteps = { userId: newUserId, steps: DEFAULT_STEPS }
    await insertHobbies(newHobbies)
    await insertSettings(newSettings)
    await insertSteps(newSteps)

    /// Generate jwt 
    const token = generateToken(newUserId)
    return success(res, token)
}