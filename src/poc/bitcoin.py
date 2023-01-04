import struct
import sys
class SHA256:
    def __init__(self) -> None:
        self.round = "FIRST"
        self.H = [
                0x6a09e667,
                0xbb67ae85,
                0x3c6ef372,
                0xa54ff53a,
                0x510e527f,
                0x9b05688c,
                0x1f83d9ab,
                0x5be0cd19
                ]

        self.K = [
            0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
            0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
            0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
            0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
            0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
            0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
            0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
            0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
        ]

        self.reset()

    def reset(self):
        self.block_start = 0
        self.H = [
                0x6a09e667,
                0xbb67ae85,
                0x3c6ef372,
                0xa54ff53a,
                0x510e527f,
                0x9b05688c,
                0x1f83d9ab,
                0x5be0cd19
                ]

        

        

    def __init_msg_block(self, input):
        if len(input) == 80:
            self.mblock_size = 128
            self.mblock = [0] * self.mblock_size
            self.mblock[0:80] = input
            self.mblock[80] = 128

            length = 80 << 3
            self.mblock[120:] = length.to_bytes(8, byteorder='big', signed=False)

        elif len(input) == 32:
            self.mblock_size = 64
            self.mblock = [0] * self.mblock_size
            self.mblock[0:32] = input
            self.mblock[32] = 128

            length = 32 << 3
            self.mblock[56:] = length.to_bytes(8, byteorder='big', signed=False)
        else:
            print("ERROR")
            quit()
        

    def __init_msg_schedule(self):
        self.W = [0] * 64
        for i in range(16):
            start = i*4 + self.block_start
            end = i*4+4 + self. block_start
            self.W[i] = struct.unpack('>I', bytearray(self.mblock[start:end]))[0]

    def ror (self, data, bits):
        return ((data >> bits) | (data << (32 - bits))) & 0xffffffff

    def rshift(self, data, bits):
        return data >> bits

    def sigma_0(self, data):
        return self.ror(data, 7) ^ self.ror(data,18) ^ self.rshift(data, 3)

    def sigma_1(self, data):
        return self.ror(data, 17) ^ self.ror(data,19) ^ self.rshift(data, 10)


    def SIGMA_0(self):
        return self.ror(self.a,2) ^ self.ror(self.a,13) ^ self.ror(self.a,22)

    def SIGMA_1(self):
        return self.ror(self.e, 6) ^ self.ror(self.e,11) ^ self.ror(self.e,25)

    def choice(self):
        return (self.e & self.f) ^ ((~self.e) & self.g)

    def majority(self):
        return (self.a & self.b) ^ (self.a & self.c) ^ (self.b & self.c)

    
    def process_W(self):
        for i in range(0, 48):
            self.W[i+16] = self.W[i] + self.sigma_0(self.W[i+1]) + self.W[i+9] + self.sigma_1(self.W[i+14]) & 0xFFFFFFFF

    def compress(self):
        self.a = self.H[0]
        self.b = self.H[1]
        self.c = self.H[2]
        self.d = self.H[3]
        self.e = self.H[4]
        self.f = self.H[5]
        self.g = self.H[6]
        self.h = self.H[7]
        self.Temp1 = 0
        self.Temp2 = 0

        for i in range(64):
            self.Temp1 = self.h + self.SIGMA_1() + self.choice() + self.K[i] + self.W[i] & 0xFFFFFFFF
            self.Temp2 = self.SIGMA_0() + self.majority()
        

            self.h = self.g
            self.g = self.f
            self.f = self.e
            self.e = self.d + self.Temp1 & 0xFFFFFFFF
            self.d = self.c
            self.c = self.b
            self.b = self.a
            self.a = self.Temp1 + self.Temp2 & 0xFFFFFFFF
        
        # self.print_working_vars()
        # self.print_h_values()

        self.H[0] = (self.H[0] + self.a) & 0xFFFFFFFF
        self.H[1] = (self.H[1] + self.b) & 0xFFFFFFFF
        self.H[2] = (self.H[2] + self.c) & 0xFFFFFFFF
        self.H[3] = (self.H[3] + self.d) & 0xFFFFFFFF
        self.H[4] = (self.H[4] + self.e) & 0xFFFFFFFF
        self.H[5] = (self.H[5] + self.f) & 0xFFFFFFFF
        self.H[6] = (self.H[6] + self.g) & 0xFFFFFFFF
        self.H[7] = (self.H[7] + self.h) & 0xFFFFFFFF

        self.block_start += 64

    def get_bytes_digest(self):
        buf = b""
        for i in range(8):
            print(i)
            buf += self.H[i].to_bytes(4, 'big', signed=False)
             
        print(len(buf))
        return buf

    def get_digest(self):
        buf = ""
        for i in range(8):
            buf += "%s" %  "{:04x}".format(self.H[i])

        return buf


    def hash(self, input):
        self.reset()
        self.__init_msg_block(input)

        self.__init_msg_schedule()
        self.process_W()
        self.compress()

        self.__init_msg_schedule()
        self.process_W()
        self.compress()

        digest = self.get_bytes_digest()

        self.reset()
        self.__init_msg_block(digest)
        self.__init_msg_schedule()
        self.print_w_block()
        self.process_W()
        self.compress()

        

        



        return self.get_digest()

    def print_mblock(self):
        print(self.mblock_size)
        print(self.mblock)
        print(len(self.mblock))
        output = ""
        for i in range(self.mblock_size):
            if i % 4 == 0:
                output += "\n %s:\t" % i

            output += "%s " % "{0:08b} ".format(self.mblock[i])
        print(output)

    def print_w_block(self):
        print("=================== W =====================")
        for i in range(64):
            print("%s:\t%s %s" % (i, "{0:032b}".format(self.W[i]), "{0:04x}".format(self.W[i])))

    def print_h_values(self):
        print("=================== H =====================")
        for i in range(8):
            print("%i: %s %s" % (i, "{:04x}".format(self.H[i]),  "{0:032b} ".format(self.H[i])))

    def print_working_vars(self):
        print("=================== WV ====================")
        print("a: %s %s" % ("{:04x}".format(self.a),  "{0:032b} ".format(self.a)))
        print("b: %s %s" % ("{:04x}".format(self.b),  "{0:032b} ".format(self.b)))
        print("c: %s %s" % ("{:04x}".format(self.c),  "{0:032b} ".format(self.c)))
        print("d: %s %s" % ("{:04x}".format(self.d),  "{0:032b} ".format(self.d)))
        print("e: %s %s" % ("{:04x}".format(self.e),  "{0:032b} ".format(self.e)))
        print("f: %s %s" % ("{:04x}".format(self.f),  "{0:032b} ".format(self.f)))
        print("g: %s %s" % ("{:04x}".format(self.g),  "{0:032b} ".format(self.g)))
        print("h: %s %s" % ("{:04x}".format(self.h),  "{0:032b} ".format(self.h)))

sha256 = SHA256()


# Mock block header input
input = "12345678123456781234567812345678123456781234567812345678123456781234567812345678".encode('utf-8')


hash = sha256.hash(input)
print(hash)

# Expected 
# a9a1bb77 2b44d320 262d9acc f044c9d3 508a83fb e4d52d6b 4e974055 970c81d5

#  echo -n "12345678123456781234567812345678123456781234567812345678123456781234567812345678" | sha256sum | cut -d' ' -f1 | xxd -r -p | sha256sum
# 6e5a17f692f993a6b19a33fe299bca70fafc449822e31b5b2460423556d48167