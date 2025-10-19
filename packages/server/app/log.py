import logging
from threading import Lock

# Internal storage for created loggers
_loggers = {}
_logger_lock = Lock()


def get_logger(name: str) -> logging.Logger:
    """
    Returns a singleton logger with the specified name.
    Ensures logger is only configured once.
    """
    with _logger_lock:
        if name in _loggers:
            return _loggers[name]

        logger = logging.getLogger(name)
        logger.setLevel(logging.DEBUG)

        if not logger.hasHandlers():
            handler = logging.StreamHandler()
            # handler.setLevel(logging.DEBUG)
            formatter = logging.Formatter(
                "%(asctime)s - %(name)s - [%(levelname)s] - %(message)s"
            )
            handler.setFormatter(formatter)
            logger.addHandler(handler)

        _loggers[name] = logger
        return logger
