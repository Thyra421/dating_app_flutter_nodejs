import { verifyToken } from "./token.js"

export function checkAuthorization(headers) {
    if (headers.authorization === null)
        return null

    return verifyToken(headers.authorization)
}