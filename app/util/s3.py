import logging
from pydantic import BaseModel

import boto3
from botocore.client import Config

logger = logging.getLogger("app." + __name__)


class S3PresignedUrlRequest(BaseModel):
    filename: str
    bucket: str
    expires_in: int


class S3PresignedUrlCredentialsRequest(BaseModel):
    filename: str
    bucket: str
    expires_in: int
    access_key: str
    secret_key: str


class S3Client:
    def __init__(self):
        self.s3 = boto3.client(
            "s3",
            region_name="ap-northeast-1",
            config=Config(s3={"addressing_style": "path"}, signature_version="s3v4"),
        )

    def generate_presigned_url(self, filename, bucket, expires_in) -> dict:
        try:
            print("filename", filename + "bucket", bucket + "expires_in", expires_in)
            self.s3.upload_file(
                Filename=filename,
                Bucket=bucket,
                Key="test/" + filename,
            )
            print("uploaded")
            presigned_url = self.s3.generate_presigned_url(
                ClientMethod="get_object",
                Params={
                    "Bucket": bucket,
                    "Key": "test/" + filename,
                },
                ExpiresIn=expires_in,
                HttpMethod="GET",
            )
            print("presigned_url", presigned_url)
            return {"presigned_url": presigned_url}
        except Exception as e:
            print(e)
            return {"error": "Failed to generate presigned URL"}


class S3ClientWithCredentials:
    def __init__(self, access_key, secret_key):
        self.s3 = boto3.client(
            "s3",
            region_name="ap-northeast-1",
            access_key=access_key,
            secret_key=secret_key,
            config=Config(s3={"addressing_style": "path"}, signature_version="s3v4"),
        )

    def generate_presigned_url(self, filename, bucket, expires_in) -> str:
        self.s3.upload_file(
            Filename=filename,
            Bucket=bucket,
            Key="test/" + filename,
        )
        presigned_url = self.s3.generate_presigned_url(
            ClientMethod="get_object",
            Params={
                "Bucket": bucket,
                "Key": "test/" + filename,
            },
            ExpiresIn=expires_in,
            HttpMethod="GET",
        )
        return presigned_url
