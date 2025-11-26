import logging
from datetime import datetime
import pytz
import functools

_singleton_cache = {}

def singleton(obj):
    """
    Singleton decorator for classes and functions.
    For classes: returns the same instance for every instantiation.
    For functions: returns the same result for every call (no args supported).
    """
    if isinstance(obj, type):
        # obj is a class
        @functools.wraps(obj)
        def wrapper(*args, **kwargs):
            key = (obj, args, frozenset(kwargs.items()))
            if key not in _singleton_cache:
                _singleton_cache[key] = obj(*args, **kwargs)
            return _singleton_cache[key]
        return wrapper
    else:
        # obj is a function
        @functools.wraps(obj)
        def wrapper(*args, **kwargs):
            key = (obj, args, frozenset(kwargs.items()))
            if key not in _singleton_cache:
                _singleton_cache[key] = obj(*args, **kwargs)
            return _singleton_cache[key]
        return wrapper

@singleton
def get_logger(name: str = __name__):
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)
    ch = logging.StreamHandler()
    logger.addHandler(ch)

    formatter = logging.Formatter(
            "{asctime} - {levelname} - {message}", style="{", datefmt="%Y-%m-%d %H:%M"
        )
    
    formatter.converter = lambda *args: datetime.now(pytz.timezone("America/Lima")).timetuple()
    ch.setFormatter(formatter)

    logger.info("Logger %s iniciado", name)

    return logger