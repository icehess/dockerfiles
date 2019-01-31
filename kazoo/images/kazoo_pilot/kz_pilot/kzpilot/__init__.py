import sys
import json
import docker

from magiclog import log

handle_types = ['container']
stop_status = ['stop']
container_status = ['start']

log_events = ['config',
              'container',
              'network',
              'secret',
              'service',
              'volume']


class KzPilot:
    def __init__(self,
                 url='unix:///var/run/docker.sock'):
        self.url = url
        self.data = dict()

    def start(self):
        self.client = self.clientConnect()
        for event in self.client.events(decode=True):
            event_type = get_event_type(event)
            if event_type in log_events:
                self.logEvent(event, event_type)

    def clientConnect(self):
        try:
            return docker.DockerClient(base_url=self.url)
        except

    def logEvent(self, event, event_type):
        if 'Actor' in event:
            actor = event['Actor']
        else:
            actor = ''
        log.debug('{} {}: {}'.format(event['Action'], event_type, actor))


    def shutdown(self):
        if self.client is not None:
            self.client.close()

def get_event_type(event):
    event['Type']

def get_event_time(event):
    event['time']
