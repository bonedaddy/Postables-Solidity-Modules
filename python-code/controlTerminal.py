from web3 import Web3, IPCProvider
from getpass import getpass
import web3
import sys
import json
from getpass import getpass
from time import sleep


# Author: Postables
# Version: 0.0.1alpha
# Warnings: Not suitable for production use (yet)
# Description: Python control script to create a quick and effective method of controlling crowdsale contracts
#              It is designed to be used from headless servers that have been hardened and secured to ensure
#              That you are operating, and controlling your crowdsale contracts safely.

class ControlHub():
    
    def __init__(self):
        self.command_list = ['broadcast withdrawals', 'pause crowdsale', 'resume crowdsale']
        