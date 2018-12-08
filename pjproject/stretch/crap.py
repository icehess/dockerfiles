import pjsua2 as pj
import time

# Subclass to extend the Account and get notifications etc.
class Account(pj.Account):
    def onRegState(self, prm):
        print("***OnRegState: " + prm.reason)

class Endpoint(pj.Endpoint):
    def __init__(self):
        pj.Endpoint.__init__(self)

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
    def __init__(self):
        print("Init config")

        self.epConfig = pj.EpConfig()
        self.udp = SipTransportConfig(pj.PJSIP_TRANSPORT_UDP, 5060, True)

        print("transport created")

        self.accounts = []
        self.accounts.append(self._test_account())

        print("test account configured")

        self._configureEndpoint()

    def _configureEndpoint(self):
        print("configuring endpoint")

        # UaConfig
        self.epConfig.uaConfig.maxCalls = 4 #default is 4, max is 32
        # self.epConfig.uaConfig.threadCnt = 1
        # self.epConfig.uaConfig.mainThreadOnly = False
        self.epConfig.uaConfig.userAgent = "mkBusy UA {}".format(pj.Endpoint().libVersion().full)

        # LogConfig
        # self.epConfig.logConfig.msgLogging = 1
        # self.epConfig.logConfig.level = 5
        # self.epConfig.logConfig.consoleLevel = 5
        # self.epConfig.logConfig.writer = self.pjLogWriter

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

        return acfg

# pjsua2 test function
def pjsua2_test():
    # Create and initialize the library
    appConfig = AppConfig()
    ep = Endpoint()
    ep.libCreate()
    ep.libInit(appConfig.epConfig)

    ep.transportCreate(appConfig.udp.type, appConfig.udp.config)

    # Start the library
    ep.libStart();

    accList = []
    for account in appConfig.accounts:
        if account.enabled:
            print("creating account '{}'".format(account.config.idUri))
            acct = Account()
            acct.create(account.config)
            accList.appenda(accList)

    # Here we don't have anything else to do..
    time.sleep(10);

    # Destroy the library
    ep.libDestroy()

#
# main()
#
if __name__ == "__main__":
    pjsua2_test()

