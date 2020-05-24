"""
Documentation

Some handy texts
"""
import sys
from logzero import logger


class Template:
    def __init__(self):
        logger.debug("Initializing the value to 1")
        self.value = 1

    def inc(self):
        logger.debug("Incrementing the value")
        self.value += 1

    @staticmethod
    def hello_world():
        print("Hello World!")

    @staticmethod
    def raise_systemerror():
        logger.error("Raising a SystemError!")
        logger.info("Logging info is not captured in pytest.")
        print("Standard print output is captured in pytest.")
        sys.exit(1)

