import os
import uuid
import logging
from io import BytesIO
from typing import Optional
from PIL import Image, ImageOps, ImageDraw

logger = logging.getLogger(__name__)


def crop_image(
    image_bytes: bytes,
    x: float,
    y: float,
    w: float,
    h: float,
    mode: str = "xywh",  # "xywh" -> x,y is top-left normalized; "cxcywh" -> center YOLO style
    save_debug_dir: Optional[str] = None,
) -> bytes:
    """
    Crop an image from bytes using normalized coords.
    - mode="xywh": x,y is top-left normalized (Flutter style).
    - mode="cxcywh": x,y is center normalized (YOLO style).
    Returns PNG bytes of the cropped region.

    If save_debug_dir is provided, saves:
      - oriented original image
      - overlay image (rectangle drawn)
      - the cropped png
    """
    if not image_bytes:
        raise ValueError("No image bytes provided")

    # small helper
    def clamp01(v: float) -> float:
        try:
            fv = float(v)
        except Exception:
            raise ValueError("Coordinates must be numbers")
        return max(0.0, min(1.0, fv))

    x = clamp01(x)
    y = clamp01(y)
    w = clamp01(w)
    h = clamp01(h)

    try:
        with Image.open(BytesIO(image_bytes)) as img:
            # Fix EXIF orientation first
            img = ImageOps.exif_transpose(img)
            if not img:
                raise ValueError("Failed to open image")
            img = img.convert("RGB")
            width, height = img.size

            if mode == "cxcywh":
                # center x,y (YOLO)
                x_center = x * width
                y_center = y * height
                box_w = w * width
                box_h = h * height
                left = int(round(x_center - box_w / 2.0))
                top = int(round(y_center - box_h / 2.0))
                right = left + int(round(box_w))
                bottom = top + int(round(box_h))
            else:
                # top-left x,y (Flutter snippet): x,y are top-left normalized
                left = int(round(x * width))
                top = int(round(y * height))
                right = left + int(round(w * width))
                bottom = top + int(round(h * height))

            # Clamp to image bounds
            left = max(0, left)
            top = max(0, top)
            right = min(width, right)
            bottom = min(height, bottom)

            if right <= left or bottom <= top:
                raise ValueError(
                    f"Invalid crop box after clamping: left={left}, top={top}, right={right}, bottom={bottom}"
                )

            cropped = img.crop((left, top, right, bottom))

            # Optionally save debug images
            if save_debug_dir:
                os.makedirs(save_debug_dir, exist_ok=True)
                uid = uuid.uuid4().hex
                orig_path = os.path.join(save_debug_dir, f"orig_{uid}.png")
                overlay_path = os.path.join(save_debug_dir, f"overlay_{uid}.png")
                crop_path = os.path.join(save_debug_dir, f"crop_{uid}.png")

                # save oriented original
                img.save(orig_path, format="PNG")

                # save overlay with rectangle
                overlay = img.copy()
                draw = ImageDraw.Draw(overlay)
                # draw rectangle (red, width 4)
                draw.rectangle([left, top, right, bottom], outline="red", width=4)
                overlay.save(overlay_path, format="PNG")

                # save crop
                cropped.save(crop_path, format="PNG")

                logger.info(
                    "Saved debug images: %s, %s, %s", orig_path, overlay_path, crop_path
                )

            out = BytesIO()
            cropped.save(out, format="PNG")
            return out.getvalue()

    except Exception as e:
        raise ValueError(f"Failed to open/crop image: {e}")
