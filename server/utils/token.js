import jwt from 'jsonwebtoken'
import { JWT_SECRET } from '../config/jwt_secret.js'

export function generateToken(payload) {
    const token = jwt.sign(payload, JWT_SECRET)
    return token
}

export function verifyToken(token) {
    try {
        const payload = jwt.verify(token, JWT_SECRET)
        return payload
    } catch (error) {
        return null
    }
} 