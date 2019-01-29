import sys
from magiclog import log

from . import KzPilot

def holaPilot():
    kzpilot = KzPilot()
    try:
        kzpilot.start()
    except KeyboardInterrupt:
        kzpilot.shutdown()
        log.warning("It's CTRL-C!")

def main():
    log.configure(stderr='debug')
    log.info('Piloting Kazoo now, Woooohooooo!')
    try:
        holaPilot()
    except Exception as e:
        log.error('It wasn\'t expected!')
        log.exception(e)
        sys.exit(2)
    except:
        log.error('python f-ed up')
        log.exception(e)
        sys.exit(2)
    log.info("What now?")

if __name__ == '__main__':
    main()
