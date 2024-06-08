import logging
from pydantic import BaseModel
import os
import sys

sys.path.append(os.path.dirname(os.path.abspath(__file__)) + "/..")
search_path = sys.path
print("search_path: s3 ", search_path)

import boto3
from botocore.client import Config

logger = logging.getLogger("app." + __name__)


class S3PresignedUrlRequest(BaseModel):
    filename: str
    bucket: str
    expires_in: int


class S3Client:
    def __init__(self):
        self.s3 = boto3.client(
            "s3",
            region_name="ap-northeast-1",
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


class S3ClientWithCredentials:
    def __init__(self):
        self.s3 = boto3.client(
            "s3",
            region_name="ap-northeast-1",
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
