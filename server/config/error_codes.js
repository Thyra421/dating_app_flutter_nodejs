const ERROR = 400
const FORBIDDEN = 403
const NOT_FOUND = 404
const TIMEOUT = 408
const CONFLICT = 409


export const ErrorCodes = {
    USER_NOT_FOUND: { "type": 0, "value": "User not found", "code": FORBIDDEN },
    USER_ALREADY_EXISTS: { "type": 1, "value": "User already exists", "code": CONFLICT },
    FORBIDDEN: { "type": 2, "value": "Authorization header invalid", "code": FORBIDDEN },
    NOT_FOUND: { "type": 3, "value": "Resource not found", "code": NOT_FOUND }
}