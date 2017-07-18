#!/usr/bin/env python3

import os
import signal
import subprocess
import sys
import threading

from RPi import GPIO
from queue import Queue

DEBUG = False

# SETTINGS
# ========

# The two pins that the encoder uses (BCM numbering).
GPIO_A = 17   
GPIO_B = 27

# The amount you want one click of the knob to increase or decrease to be.
INCREMENT_STEP = 1

# (END SETTINGS)
# 


# When the knob is turned, the callback happens in a separate thread. If
# those turn callbacks fire erratically or out of order, we'll get confused
# about which direction the knob is being turned, so we'll use a queue to
# enforce FIFO. The callback will push onto a queue, and all the actual
# volume-changing will happen in the main thread.
QUEUE = Queue()

# When we put something in the queue, we'll use an event to signal to the
# main thread that there's something in there. Then the main thread will
# process the queue and reset the event. If the knob is turned very quickly,
# this event loop will fall behind, but that's OK because it consumes the
# queue completely each time through the loop, so it's guaranteed to catch up.
EVENT = threading.Event()

def debug(str):
  if not DEBUG:
    return
  print(str)

class RotaryEncoder:
  
  def __init__(self, gpioA, gpioB, callback=None):
    self.lastGpio = None
    self.gpioA    = gpioA
    self.gpioB    = gpioB
    self.callback = callback
    
    self.levA = 0
    self.levB = 0
    
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(self.gpioA, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.setup(self.gpioB, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    
    GPIO.add_event_detect(self.gpioA, GPIO.BOTH, self._callback)
    GPIO.add_event_detect(self.gpioB, GPIO.BOTH, self._callback)
    
  def destroy(self):
    GPIO.remove_event_detect(self.gpioA)
    GPIO.remove_event_detect(self.gpioB)
    GPIO.cleanup()
    
  def _callback(self, channel):
    level = GPIO.input(channel)
    if channel == self.gpioA:
      self.levA = level
    else:
      self.levB = level
    
    # Debounce.
    if channel == self.lastGpio:
      return
    
    # When both inputs are at 1, we'll fire a callback. If A was the most
    # recent pin set high, it'll be forward, and if B was the most recent pin
    # set high, it'll be reverse.
    self.lastGpio = channel
    if channel == self.gpioA and level == 1:
      if self.levB == 1:
        self.callback(1)
    elif channel == self.gpioB and level == 1:
      if self.levA == 1:
        self.callback(-1)
        
gpioA = GPIO_A
gpioB = GPIO_B

# This callback runs in the background thread. All it does is put turn
# events into a queue and flag the main thread to process them. The
# queueing ensures that we won't miss anything if the knob is turned
# extremely quickly.
def on_turn(delta):
  QUEUE.put(delta)
  EVENT.set()
  
def on_exit(a, b):
  print("Exiting...")
  encoder.destroy()
  sys.exit(0)
  
encoder = RotaryEncoder(GPIO_A, GPIO_B, callback=on_turn)
signal.signal(signal.SIGINT, on_exit)
inc = 0
while True:
  # This is the best way I could come up with to ensure that this script
  # runs indefinitely without wasting CPU by polling. The main thread will
  # block quietly while waiting for the event to get flagged. When the knob
  # is turned we're able to respond immediately, but when it's not being
  # turned we're not looping at all.
  # 
  # The 1200-second (20 minute) timeout is a hack; for some reason, if I
  # don't specify a timeout, I'm unable to get the SIGINT handler above to
  # work properly. But if there is a timeout set, even if it's a very long
  # timeout, then Ctrl-C works as intended. No idea why.
  #EVENT.wait(1200)
  while not QUEUE.empty():
    delta = QUEUE.get()
    inc = inc + delta
  print(inc)
  EVENT.clear()
