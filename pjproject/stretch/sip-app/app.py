import sys
import time
import pjsua2 as pj

from log import Logger
from settings import AppConfig
from endpoint import Endpoint
from account import Account

class Application:
    """
    The Application main entry
    """
    def __init__(self, argv):
        logger = Logger().logger
        self.appConfig = AppConfig(logger)
        self.logger = logger
        self.quitting = False
        self.handling_events = False
        self.accounts = {}

        self.logger.debug("Creating the Endpoint")
        self.endpoint = Endpoint(self)

    def start(self):
        self.logger.debug("starting up")

        self.endpoint.libCreate()
        self.endpoint.libInit(self.appConfig.epConfig)

        self.logger.debug("lib initialized")

        self.endpoint.transportCreate(self.appConfig.udp.type, self.appConfig.udp.config)

        self.logger.debug("transport created")

        self.endpoint.libStart()

        self.logger.debug("lib started")

        for account in self.appConfig.accounts:
            if account.enabled:
                self._createAccount(account.config)

    def _createAccount(self, config):
        self.logger.debug("creating account '{}'".format(config.idUri))
        account = Account(self, config)
        account.create(account.config)
        self.accounts[config.idUri] = account
        self.logger.debug("created account '{}'".format(config.idUri))

    def onSelectAccount(self, param):
        """
        params is:
            SipRxData rdata    The incoming request.
            int accountIndex   Upon entry, this will be filled by the account index chosen by the library. Application may change it to another value to use another account.

        SipRxData is:
            string        info         A short info string describing the request, which normally contains the request method and its CSeq.
            string        wholeMsg     The whole message data as a string, containing both the header section and message body section.
            SocketAddress srcAddress   Source address of the message. (This is a string containing "host[:port]")
        """
        self.logger.debug("recieved msg {} for {}".format(param.rdata.info, param.accountIndex))
        return 0


    def make_call(self):
        while True and not self.quitting:
            self.logger.debug("handling events")
            self.handling_events= True
            self.endpoint.libHandleEvents(10)
            self.handling_events= False
            self.logger.debug("finished handling events")
            time.sleep(.50)
            self.logger.debug("pretending making call")

    def os_signal_handler(self, signal, frame):
        self.shutdown()

    def shutdown(self):
        self.quitting = True
        self.logger.debug("shutting down")
        self.endpoint.libDestroy()
        # self.endpoint = None

def main(argv):
    app = Application(argv)
    app.start()
    app.make_call()
    app.shutdown()

# Get things started
if __name__ == '__main__':
    main(sys.argv[1:])
