#!/usr/bin/python3
import sys

def ror (data, bits):
        return ((data >> bits) | (data << (32 - bits))) & 0xffffffff

def rshift(data, bits):
        return data >> bits

def sigma_0(data):
    ror_1 = ror(data,2)
    ror_2 = ror(data,13)
    ror_3 = ror(data, 22)
    xored1 = ror_1 ^ ror_2
    xored_2 = xored1 ^ ror_3

    result = ror(data, 2) ^ ror(data,13) ^ ror(data, 22)

    print("ror_1:   {0:032b} ".format(ror_1))
    print("ror_2:   {0:032b} ".format(ror_2))
    print("ror_3:   {0:032b} ".format(ror_3))
    print("xored1:  {0:032b} ".format(xored1))
    print("xored2:  {0:032b} ".format(xored_2))
    print("result:  {0:032b} ".format(result))

    
sigma_0(int(sys.argv[1], 2))