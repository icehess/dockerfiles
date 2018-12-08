import sys
import re
import logging
from rainbow_logging_handler import RainbowLoggingHandler
import pjsua2 as pj

class Logger:
    """
    Log Logger
    """

    instance = None

    def __init__(self):
        Logger.instance = self
        self.level = logging.DEBUG
        self.logger = self._createAppLogger()
        self.pjLogger = self._createpjLogger()

    def _createAppLogger(self):
        return self._createLogger(name='mkbusy-ua')

    def _createpjLogger(self):
        return self._createLogger(name='pjsip') #, __name__)

    def _createLogger(self, name):
        formatter = logging.Formatter(fmt='(%(levelname)s) [%(asctime)s,%(msecs)03d] %(name)s %(filename)s:%(lineno)d\t%(message)s',
                                      datefmt='%H:%M:%S')
        logger = logging.getLogger(name)
        logger.setLevel(self.level)

        handler = RainbowLoggingHandler(sys.stdout, datefmt='%H:%M:%S')
        handler.setLevel(self.level)

        handler.setFormatter(formatter)
        logger.addHandler(handler)
        return logger

    def write_pj(self, pjLogEntry):
        """
        PJ log entry fields:
            int     level;
            string  msg;
            long    threadId;
            string  threadName;
        """
        level = pjLogEntry.level
        if level == 3:
            (levelno, levelname) = (30, 'INFO') # 'info'
        elif level == 2:
            (levelno, levelname) = (30, 'WARNING') # 'warning'
        elif level <= 1:
            (levelno, levelname) = (40, 'ERROR') # 'error'
        else:
            (levelno, levelname) = (10, 'DEBUG') # 'debug'

        (msg_type, module, msg) = self.normalize_pj_log(pjLogEntry.msg)
        if msg_type is "pjsip":
            return
        record = logging.makeLogRecord({'name': 'pjsip',
                                        'levelno': levelno,
                                        'levelname': levelname,
                                        'lineno': 0,
                                        'msg': msg,
                                        'filename': module})

        self.pjLogger.handle(record)

    def normalize_pj_log(self, msg):
        msg = re.sub(r'^[0-9:.]+ +', '', msg).strip('\n\r ')
        splitfilemsg = re.split(r' ', msg, maxsplit=1)
        file = splitfilemsg[0]
        msg = splitfilemsg[1].lstrip('. ')
        if re.match(r'(TX|RX) [0-9]+ bytes (Request|Response) msg', msg) is not None:
            lines = msg.splitlines()
            firstline = '{}'.format(lines[0])
            for line in lines[1:]:
                if line.startswith('Call-ID:'):
                    callId = re.sub(r'^Call-ID:\s*', '', line)
                    break
            siplines = ""
            if callId is not None:
                for line in lines[1:]:
                    siplines = siplines + callId + ':' + line + '\n'
            else:
                siplines = lines[1:].join('\n')
            return ("sip", file, firstline + '\n' + siplines.rstrip('\n'))
        else:
            return ("pjsip", file, msg)

def write_pj_log(entry):
    if Logger.instance:
        Logger.instance.write_pj(entry)
    else:
        sys.stdout.write(entry.msg + "\r\n")

class PJLogWriter(pj.LogWriter):
    """
    Logger to receive log messages from pjsua2
    """

    def __init__(self):
        pj.LogWriter.__init__(self)

    def write(self, entry):
        write_pj_log(entry)

