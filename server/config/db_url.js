const DB_PORT = process.env.DB_PORT || "27017"
const DB_HOST = process.env.DB_HOST || "127.0.0.1"

export const DB_URL = `mongodb://${process.env.MONGO_INITDB_ROOT_USERNAME}:${process.env.MONGO_INITDB_ROOT_PASSWORD}@${DB_HOST}:${DB_PORT}/?authMechanism=DEFAULT`