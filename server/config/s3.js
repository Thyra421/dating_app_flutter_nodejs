import { S3Client } from "@aws-sdk/client-s3"

const s3Region = process.env.AWS_BUCKET_REGION
const s3AccessKeyId = process.env.AWS_ACCESS_KEY_ID
const s3SecretAccessKey = process.env.AWS_SECRET_ACCESS_KEY
export const s3BucketName = process.env.AWS_BUCKET_NAME

export const s3 = new S3Client({
    credentials: {
        accessKeyId: s3AccessKeyId,
        secretAccessKey: s3SecretAccessKey
    },
    region: s3Region
})