import { insertHobbies } from "../models/hobbies.js"
import { insertSettings } from "../models/settings.js"
import { insertUser, userExists } from "../models/users.js"
import { DEFAULT_HOBBIES, DEFAULT_IDENTITY, DEFAULT_LOCATION, DEFAULT_RELATIONS, DEFAULT_SETTINGS, DEFAULT_STEPS } from "../config/default.js"
import { ErrorCodes } from "../config/error_codes.js"
import { error, success } from "../utils/responses.js"
import { generateToken } from "../utils/token.js"
import { insertSteps } from "../models/steps.js"
import { insertIdentity } from "../models/identity.js"
import { insertLocation } from "../models/location.js"
import bcrypt from "bcryptjs"
import { insertRelations } from "../models/relations.js"

export async function register(req, res) {
    /// Check if user alread exists    
    const query = { mail: req.body.mail }
    if (await userExists(query))
        return error(res, ErrorCodes.USER_ALREADY_EXISTS)

    /// Create new user
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(req.body.password, salt);

    const newUser = { mail: req.body.mail, password: hash }

    const newUserId = await insertUser(newUser)

    /// Create resources for the user
    const newHobbies = { userId: newUserId, hobbies: DEFAULT_HOBBIES }
    const newSettings = { userId: newUserId, settings: DEFAULT_SETTINGS }
    const newSteps = { userId: newUserId, steps: DEFAULT_STEPS }
    const newIdentity = { userId: newUserId, identity: DEFAULT_IDENTITY }
    const newLocation = { userId: newUserId, location: DEFAULT_LOCATION }
    const newRelations = { userId: newUserId, relations: DEFAULT_RELATIONS }
    await insertHobbies(newHobbies)
    await insertSettings(newSettings)
    await insertSteps(newSteps)
    await insertIdentity(newIdentity)
    await insertLocation(newLocation)
    await insertRelations(newRelations)

    /// Generate jwt 
    const token = generateToken(newUserId)
    return success(res, token)
}