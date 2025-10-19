class DuplicateArchivoError(Exception):
    """Raised when trying to create a duplicate Archivo entry."""

    def __init__(self, image_url: str, image_path: str):
        self.image_url = image_url
        self.image_path = image_path
        super().__init__(f"Archivo with image_url '{image_url}' already exists.")


class BajaConfianzaError(Exception):
    """Raised when the confidence level is too low."""

    def __init__(self, image_url: str):
        super().__init__(
            f"Baja confianza en la predicción para la imagen '{image_url}'"
        )
