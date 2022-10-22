import { createObjectId } from "../models/database.js"
import { userExists } from "../models/users.js"
import { verifyToken } from "./token.js"

export async function checkAuthorization(headers) {
    if (headers.authorization === null)
        return null

    const id = verifyToken(headers.authorization)

    if (id === null || !(await userExists({ _id: createObjectId(id) })))
        return null

    return id
}