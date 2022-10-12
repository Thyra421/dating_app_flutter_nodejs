import jwt from 'jsonwebtoken'
const SECRET = "123"

export function generateToken(payload) {
    const token = jwt.sign(payload, SECRET)
    return token
}

export function verifyToken(token) {
    try {
        const payload = jwt.verify(token, SECRET)
        return payload
    } catch (error) {
        return null
    }
} 