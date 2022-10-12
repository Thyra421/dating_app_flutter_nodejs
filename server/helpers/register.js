import { insertUser, userExists } from "../database/database.js"
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

    insertUser(newUser)

    return success(res, "OK")
}