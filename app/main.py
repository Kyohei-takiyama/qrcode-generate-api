from fastapi import FastAPI
from fastapi.responses import Response
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum
import qrcode
from io import BytesIO


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/qrcode")
def generate_qrcode(url: str):

    # Generate QR code
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(url)
    qr.make(fit=True)

    img = qr.make_image(fill_color="black", black_color="white")

    img_bytes = BytesIO()
    img.save(img_bytes, format="PNG")
    img_bytes.seek(0)

    print("QR code generated")
    print("URL: ", url)
    print("QR code: ", img_bytes.getvalue())
    print("QR code type: ", type(img_bytes.getvalue()))
    print("QR code length: ", len(img_bytes.getvalue()))

    return Response(content=img_bytes.getvalue(), media_type="image/png")


handler = Mangum(app)

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
