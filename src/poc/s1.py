#!/usr/bin/python3
import sys

def ror (data, bits):
        return ((data >> bits) | (data << (32 - bits))) & 0xffffffff

def rshift(data, bits):
        return data >> bits

def s1(data):
    ror_1 = ror(data,17 )
    ror_2 = ror(data,19)
    xored = ror_1 ^ ror_2
    shifted = rshift(data, 10)
    xored_2 = xored ^ shifted

    result = ror(data, 17) ^ ror(data,19) ^ rshift(data, 10)

    print("ror_1:   {0:032b} ".format(ror_1))
    print("ror_2:   {0:032b} ".format(ror_2))
    print("xored1:  {0:032b} ".format(xored))
    print("shifted: {0:032b} ".format(shifted))
    print("xored2:  {0:032b} ".format(xored_2))
    print("result:  {0:032b} ".format(result))

    
s1(int(sys.argv[1], 2))