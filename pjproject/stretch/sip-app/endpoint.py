import pjsua2 as pj
import signal

class Endpoint(pj.Endpoint):
    """
    This is high level Python object inherited from pj.Endpoint
    """
    instance = None
    def __init__(self, app):
        pj.Endpoint.__init__(self)
        Endpoint.instance = self

        self.app = app
        self.logger = app.logger

        signal.signal(signal.SIGINT, app.os_signal_handler)

    # def OnTimer(self, param):
    #     pass

    def onSelectAccount(self, param):
        self.app.onSelectAccount(param)
