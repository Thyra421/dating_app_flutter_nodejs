export function success(res, body) {
    return res.send(body)
}

export function error(res, body) {
    return res.status(body.code ?? 400).send(body)
}