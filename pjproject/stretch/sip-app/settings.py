import pjsua2 as pj
from log import PJLogWriter

# Transport setting
class SipTransportConfig:
    def __init__(self, type, port, enabled):
        self.type = type
        self.enabled = enabled
        self.config = pj.TransportConfig()
        self.config.port = port

# Account setting with buddy list
class AccountConfig:
    def __init__(self, enabled=False):
        self.enabled = enabled
        self.config = pj.AccountConfig()

class AppConfig:
    def __init__(self, logger):
        logger.debug("Init config")

        self.epConfig = pj.EpConfig()
        self.udp = SipTransportConfig(pj.PJSIP_TRANSPORT_UDP, 5060, True)

        logger.debug("transport created")

        self.accounts = []
        self.accounts.append(self._test_account())

        logger.debug("test account configured")

        self.logger = logger
        self.pjLogWriter = PJLogWriter()
        self._configureEndpoint()

    def _configureEndpoint(self):
        self.logger.debug("configuring endpoint")

        # UaConfig
        self.epConfig.uaConfig.maxCalls = 4 #default is 4, max is 32
        self.epConfig.uaConfig.threadCnt = 0
        self.epConfig.uaConfig.mainThreadOnly = True
        self.epConfig.uaConfig.userAgent = "mkBusy UA {}".format(pj.Endpoint().libVersion().full)

        # LogConfig
        self.epConfig.logConfig.msgLogging = 1
        self.epConfig.logConfig.level = 5
        self.epConfig.logConfig.consoleLevel = 5
        self.epConfig.logConfig.writer = self.pjLogWriter

        # MediaConfig
        self.epConfig.medConfig.clockRate = 16000
        # self.epConfig.medConfig.tcDropPct = 0 # Percentage of RTP packet to drop in TX direction (to simulate packet lost).
        # self.epConfig.medConfig.rxDropPct = 0 # Percentage of RTP packet to drop in RX direction (to simulate packet lost).

    def _test_account(self):
        acfg = AccountConfig(enabled=True)
        acfg.config.idUri = "sip:user_6kk5hzm2tf@4a6863.sip.sandbox.2600hz.com"

        # regConfig
        acfg.config.regConfig.registrarUri = "sip:us-west.sb.2600hz.com"
        acfg.config.regConfig.registerOnAdd = True
        # acfg.config.regConfig.headers = # [{K, V}] The optional custom SIP headers to be put in the registration request.
        # acfg.config.regConfig.contactParams = # Additional parameters that will be appended in the Contact header of the registration requests.
        acfg.config.regConfig.timeoutSec = 300
        acfg.config.regConfig.dropCallsOnFail = False
        acfg.config.regConfig.proxyUse = 3

        # sipConfig
        cred = pj.AuthCredInfo("digest", "4a6863.sip.sandbox.2600hz.com", "user_6kk5hzm2tf", 0, "wxhjrvuwf8ph")
        acfg.config.sipConfig.authCreds.append(cred)
        acfg.config.sipConfig.proxies.append("sip:us-west.sb.2600hz.com;lr")
        # acfg.config.sipConfig.contactParams = ";my-param=X;another-param=Hi%20there"

        # callConfig
        # ....

        # presConfig
        # .....

        # mwiConfig
        # acfg.config.mwiConfig.enabled = True # subscribe

        # natConfig
        # ....

        # mediaConfig
        # ....

        # videConfig
        # ....

        # ipChangeConfig
        # ....

        return acfg

