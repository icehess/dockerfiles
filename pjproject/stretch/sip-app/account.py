import random
import pjsua2 as pj

# import call

class Account(pj.Account):
    def __init__(self, app, accountConfig):
        pj.Account.__init__(self)
        self.app = app
        self.logger = app.logger
        self.randId = random.randint(1, 9999)
        self.config =  accountConfig

    def statusText(self):
        status = '?'
        if self.isValid():
            accountInfo = self.getInfo()
            if accountInfo.regLastErr:
                status = self.app.endpoint.utilStrError(accountInfo.regLastErr)
            elif accountInfo.regIsActive:
                if accountInfo.onlineStatus:
                    if len(accountInfo.onlineStatusText):
                        status = accountInfo.onlineStatusText
                    else:
                        status = "Online"
                else:
                    status = "Registered"
            else:
                if accountInfo.regIsConfigured:
                    if accountInfo.regStatus / 100 == 2:
                        status = "Unregistered"
                    else:
                        status = accountInfo.regStatusText
                else:
                    status = "Doesn't register"
        else:
            status = '- not created -'
        return status

    def onRegState(self, param):
        self.logger.debug("reg state changed: {} {}".format(param.code, param.reason))

    def onIncomingCall(self, prm):
        # Not Implemented (yet)
        pass
