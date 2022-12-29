import sys
from sha256 import SHA256

hasher = SHA256()
input = sys.argv[1].encode("utf-8")

hasher.hash(input, len(input))


for idx, val in enumerate(hasher.K):
    print("K[%s] = 32'h%s;" %(idx, hex(val).replace("0x",'')))
