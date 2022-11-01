import { selectRelations, updateAddRelations, updateRemoveRelations } from "../models/relations.js"
import { ErrorCodes } from "../config/error_codes.js"
import { checkAuthorization } from "../utils/header.js"
import { error, success } from "../utils/responses.js"

export async function getRelations(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }

    const relations = await selectRelations(query)
    return success(res, relations.relations)
}

export async function removeRelations(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const relationsToRemove = req.body

    await updateRemoveRelations(query, relationsToRemove)
    return success(res, "OK")
}


export async function addRelations(req, res) {
    const id = await checkAuthorization(req.headers)
    if (id === null)
        return error(res, ErrorCodes.FORBIDDEN)

    const query = { userId: id }
    const relationsToAdd = req.body

    await updateAddRelations(query, relationsToAdd)
    return success(res, "OK")
}