def toMD5Digest(data) -> str:
    """
    Convert data to an MD5 digest.

    :param data: The input data as bytes or string.
    :return: The MD5 digest as a hexadecimal string.
    """
    import hashlib

    if isinstance(data, str):
        data = data.encode("utf-8")

    return hashlib.md5(data).hexdigest()
