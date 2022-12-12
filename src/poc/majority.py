#!/usr/bin/python3
import sys

def ror (data, bits):
        return ((data >> bits) | (data << (32 - bits))) & 0xffffffff

def rshift(data, bits):
        return data >> bits

def majority(a,b,c):
    a_and_b = (a & b)
    a_and_c = (a & c)
    b_and_c = (b & c)
    xor_1 = a_and_b ^ a_and_c
    xor_2 = xor_1 ^ b_and_c

    result = (a & b) ^ (a & c) ^ (b & c)

    print("a_and_b: {0:032b} ".format(a_and_b))
    print("a_and_c: {0:032b} ".format(a_and_c))
    print("b_and_c: {0:032b} ".format(b_and_c))
    print("xor_1:   {0:032b} ".format(xor_1))
    print("xor_2:   {0:032b} ".format(xor_2))
    print("result:  {0:032b} ".format(result))

    
print("==========================")
print ("a: %s" % sys.argv[1])
print ("b: %s" % sys.argv[2])
print ("c: %s" % sys.argv[3])

majority(a = int(sys.argv[1], 2),
       b = int(sys.argv[2], 2),
       c = int(sys.argv[3], 2))


a = int()