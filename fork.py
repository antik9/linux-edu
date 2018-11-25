import os
import time
import signal
import sys

def sigchld_handler(_signal, frame):
    print(f'Wait child... signal: {_signal}')
    os.wait()

def sigint_handler(*args, **kwargs):
    os.killpg(os.getpgrp(), signal.SIGTERM)
    exit(0)

signal.signal(signal.SIGCHLD, sigchld_handler)
signal.signal(signal.SIGINT, sigint_handler)

print('Hello! I am an example')
pid = os.fork()
print('pid of my child is %s' % pid)
if pid == 0:
    print('I am a child. Im going to sleep')
    for i in range(1,40):
      print('mrrrrr')
      a = 2**i
      print(a)
      pid = os.fork()
      if pid == 0:
            print('my name is %s' % a)
            sys.exit(0)
      else:
            print("my child pid is %s" % pid)
      time.sleep(1)
    print('Bye')
    sys.exit(0)

else:
    for i in range(1,200):
        print('HHHrrrrr')
        time.sleep(1)
        print(3**i)
    print('I am the parent')
