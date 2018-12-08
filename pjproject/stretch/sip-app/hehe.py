import sys
import logging
from rainbow_logging_handler import RainbowLoggingHandler

formatter = logging.Formatter(fmt='(%(levelname)s) [%(asctime)s,%(msecs)03d] %(name)s %(module)s:%(lineno)d\t%(message)s')
# formatter = logging.Formatter(fmt='%(asctime)s,%(msecs)03d [%(levelname)s] | %(name)s[%(process)d] | %(message)s')
logger = logging.getLogger('hehe')
logger.setLevel(logging.DEBUG)

handler = RainbowLoggingHandler(sys.stdout, datefmt='%H:%M:%S')
handler.setLevel(logging.DEBUG)

handler.setFormatter(formatter)
logger.addHandler(handler)

logger.debug("yoohoo")

logger.debug("debug msg")
logger.info("info msg")
logger.warn("warn msg")
logger.error("error msg")
logger.critical("critical msg")


Lrecord = logging.makeLogRecord({'name': 'hehe',
                                 'levelno': 10,
                                 'lineno': 10000,
                                 'msg': 'hehehehhehehehehhe',
                                 'module': 'other_module'})
logger.handle(Lrecord)
try:
    raise RuntimeError("Opa!")
except Exception as e:
    logger.exception(e)
