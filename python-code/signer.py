from web3 import Web3, IPCProvider
from getpass import getpass
import sys
import json

#####
# Author: Postables
# Description: Used to sign a message with the given account, display `vrs` from the signature, and submit the data to a smart contract to verify the source (signer) address
# Notes: Includes web3 monkey patch (from @dongsam) for the way PoA networks are currently handled
#        The address used as the unlock account address, but correspond to the address for the private key from the decrypted key file
####

# special web 3 overrides to work on a PoA network
from web3.middleware.pythonic import (
    pythonic_middleware,
    to_hexbytes,
)

size_extraData_for_poa = 200   # can change
pythonic_middleware.__closure__[2].cell_contents['eth_getBlockByNumber'].args[1].args[0]['extraData'] = to_hexbytes(size_extraData_for_poa, variable_length=True)
pythonic_middleware.__closure__[2].cell_contents['eth_getBlockByHash'].args[1].args[0]['extraData'] = to_hexbytes(size_extraData_for_poa, variable_length=True)
#####

if len(sys.argv) > 5 or len(sys.argv) < 5:
	print("Improper invocation")
	print("python3.6 signer.py <encrypted_key_file> <ipc-path> <contract-abi> <contract-address>")
	exit(1)

w3 = Web3(IPCProvider())
encryptedKeyFile = sys.argv[1]
ipcPath = sys.argv[2]
contractAbi = sys.argv[3]
contractAddress = sys.argv[4]
password = getpass("Enter Password:")
with open(contractAbi, 'r') as fh:
	abi = json.load(fh)
with open(encryptedKeyFile, 'r') as fh:
	encrypted = json.load(fh)


w3.personal.unlockAccount("0xf043735ed92de5e0B98a59Ef07Cc607ea7AD8151", password, 0)
contract = w3.eth.contract(contractAddress, abi=abi)
decryptedPrivateKey = w3.eth.account.decrypt(encrypted, password)
attribDict = w3.eth.account.sign(message_text="testmessage", private_key=decryptedPrivateKey)
msgHash = Web3.toHex(attribDict['messageHash'])
v = attribDict['v']
r = attribDict['r']
s = attribDict['s']
r = Web3.toHex(r)
s = Web3.toHex(s)
vrs = (v,r,s)
print("v:\t",v,"\nr:\t",r,"\ns:\t",s,"\nmsgHsh:\t",msgHash)
recoveredAddress = w3.eth.account.recover(msgHash,vrs=vrs)
print("Recovered address:\t", recoveredAddress)
#print(contract.functions.testRecovery(msgHash,v,r,s).transact({'from': w3.eth.accounts[0], 'gasPrice': 91000000000}))
print(contract.functions.recover(msgHash, attribDict['signature']).transact({'from': "0xf043735ed92de5e0B98a59Ef07Cc607ea7AD8151", 'gasPrice': 91000000000}))
