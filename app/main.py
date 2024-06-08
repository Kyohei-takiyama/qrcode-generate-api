from fastapi import FastAPI, HTTPException
from fastapi.responses import Response
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum
import qrcode
from io import BytesIO
import os
import sys

sys.path.append(os.path.dirname(os.path.abspath(__file__)) + "/..")
search_path = sys.path
print("search_path: main ", search_path)

from .util.s3 import S3Client, S3PresignedUrlRequest, S3ClientWithCredentials

app = FastAPI(docs_url=None, redoc_url=None, openapi_url=None)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/qrcode")
def generate_qrcode(url: str):
    # check url is blank
    if not url:
        raise HTTPException(status_code=400, detail="URL is required")

    # generate qrcode
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(url)
    qr.make(fit=True)

    img = qr.make_image(fill_color="black", back_color="white")

    # save qrcode as bytes
    img_bytes = BytesIO()
    img.save(img_bytes, format="PNG")
    img_bytes.seek(0)

    # return png image with response
    return Response(content=img_bytes.getvalue(), media_type="image/png")


@app.post("/presigned-url")
def generate_presigned_url(request: S3PresignedUrlRequest):
    s3_client = S3Client()
    presigned_url = s3_client.generate_presigned_url(
        request.filename, request.bucket, request.expires_in
    )
    return {"presigned_url": presigned_url}


@app.post("/presigned-url/credentials")
def generate_presigned_url(request: S3PresignedUrlRequest):
    s3_client = S3ClientWithCredentials()
    presigned_url = s3_client.generate_presigned_url(
        request.filename, request.bucket, request.expires_in
    )
    return {"presigned_url": presigned_url}


handler = Mangum(app, "off")
