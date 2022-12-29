import sys
from sha256 import SHA256

hasher = SHA256()
input = sys.argv[1].encode("utf-8")

hasher.hash(input, len(input))

for idx, val in enumerate(hasher.W):
    print("expectation[%s] = 32'b%s;" %(idx, format(val, 'b').zfill(32)))
