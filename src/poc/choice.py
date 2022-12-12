#!/usr/bin/python3
import sys

def ror (data, bits):
        return ((data >> bits) | (data << (32 - bits))) & 0xffffffff

def rshift(data, bits):
        return data >> bits

def choice(e,f,g):
    and_e_f = e & f
    not_e = ~e
    not_e_g = not_e & g
    xor_1 = and_e_f ^ not_e_g

    result = (e & f) ^ ((~e) & g)

    print("and_e_f: {0:032b} ".format(and_e_f))
    print("not_e:   {0:032b} ".format(not_e))
    print("not_e_g: {0:032b} ".format(not_e_g))
    print("xor_1:   {0:032b} ".format(xor_1))
    print("result:  {0:032b} ".format(result))

    
print("==========================")
print ("e: %s" % sys.argv[1])
print ("f: %s" % sys.argv[2])
print ("g: %s" % sys.argv[3])

choice(e = int(sys.argv[1], 2),
       f = int(sys.argv[2], 2),
       g = int(sys.argv[3], 2))


a = int()