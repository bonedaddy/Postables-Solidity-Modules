from web3 import Web3
# most basic implementation of a merkle proof for a binary tree
a = 0x3ac225168df54212a25c1c01fd35bebfea408fdac2e31ddd6f80a4bbf9a5f1cb
b = 0xb5553de315e0edf504d9150af82dafa5c4667fa618ed0a6f19c69b41166c5510
ab = 0x5f532725975999c811ae13be41fb93a2dc961d792aabec5b07b1d961cddfded2

# This is the actual hash for c that will generate the valid abcd
#c = 0x0b42b6393c1f53060fe3ddbfcd7aadcca894465a5a438f69c87d790b2299b9b2
d = 0xf1918e8562236eb17adc8502332f4c9c82bc14e19bfc0aa10ab674ff75b3d2f3
# valid merkle root
abcd = 0xec5859a8693913943977a3f54b3b4a8ff95f8a69e7f299642bb4340f20ef2245


#print("Merkle root: ", abcd)

txC = str(input('enter hash of transaction c: '))
print('Computing hash of branch cd')
cd = Web3.sha3(text=(txC + Web3.toHex(d)))

print("Hash of branch cd: ", cd)

print('Computing hash of merkle root abcd')
merkleRoot = Web3.sha3(text=(Web3.toHex(ab) + Web3.toHex(cd)))

print(Web3.toHex(merkleRoot))
print(Web3.toHex(abcd))

if str(Web3.toHex(merkleRoot)) == str(Web3.toHex(abcd)):
    print('True')
else:
    print('False')
