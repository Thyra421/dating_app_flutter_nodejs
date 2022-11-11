
import { s3, s3BucketName } from "../config/s3.js"
import { PutObjectCommand, GetObjectCommand, DeleteObjectCommand } from "@aws-sdk/client-s3"
import { getSignedUrl } from "@aws-sdk/s3-request-presigner"

export async function deleteFile(name) {
    const params = {
        Bucket: s3BucketName,
        Key: name
    }

    const command = new DeleteObjectCommand()

    await s3.send(command)
}

export async function downloadFile(name) {
    const params = {
        Bucket: s3BucketName,
        Key: name
    }

    const command = new GetObjectCommand(params)
    const url = await getSignedUrl(s3, command, { expiresIn: 3600 })
    return url
}

export async function uploadFile(file, name) {
    const params = {
        Bucket: s3BucketName,
        Key: name,
        Body: file.buffer,
        ContentType: file.mimetype
    }
    const command = new PutObjectCommand(params)

    await s3.send(command)
}