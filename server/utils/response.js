import { ErrorCodes } from "../error_codes.js"

export function success(res, body) {
    return res.send(body)
}

export function error(res, body) {
    return res.status(400).send(body)
}