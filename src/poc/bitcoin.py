import struct
from threading import Timer
import hashlib


class RepeatedTimer(object):
    def __init__(self, interval, function, *args, **kwargs):
        self._timer     = None
        self.interval   = interval
        self.function   = function
        self.args       = args
        self.kwargs     = kwargs
        self.is_running = False
        self.start()

    def _run(self):
        self.is_running = False
        self.start()
        self.function(*self.args, **self.kwargs)

    def start(self):
        if not self.is_running:
            self._timer = Timer(self.interval, self._run)
            self._timer.start()
            self.is_running = True

    def stop(self):
        self._timer.cancel()
        self.is_running = False
class SHA256:
    def __init__(self) -> None:
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

    def get_bytes_digest(self):
        buf = b""
        for i in range(8):
            buf += self.H[i].to_bytes(4, 'big', signed=False)
             
        return buf

    def get_digest(self):
        buf = ""
        for i in range(8):
            buf += "%s" %  "{:04x}".format(self.H[i])

        return buf



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

    def init_msg_block(self, input):
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
        

    def init_msg_schedule(self):
        self.W = [0] * 64
        for i in range(16):
            start = i*4 + self.block_start
            end = i*4+4 + self. block_start
            self.W[i] = struct.unpack('>I', bytearray(self.mblock[start:end]))[0]

    
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

    def print_mblock(self):
        output = ""
        for i in range(len(self.mblock)):
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


class SHA256_naieve(SHA256):
    def hash(self, input):
        self.reset()
        self.init_msg_block(input)

        self.print_mblock()
        quit()

        self.init_msg_schedule()
        self.process_W()
        self.compress()

        self.init_msg_schedule()
        self.process_W()
        self.compress()

        digest = self.get_bytes_digest()

        self.reset()
        self.init_msg_block(digest)
        self.init_msg_schedule()
        self.process_W()
        self.compress()



# This implementation runs slower than the naive implementation, but 
# should run faster when implemented in hardware, due to the parallelization
# of process_W()
class SHA256_opt1(SHA256_naieve):
    def __init__(self) -> None:
        super().__init__()

        self.a = 0
        self.b = 0
        self.c = 0
        self.d = 0
        self.e = 0
        self.f = 0
        self.g = 0
        self.h = 0

        self.w = [0] * 16


    def __reset_regs(self):
        self.a = self.H[0]
        self.b = self.H[1]
        self.c = self.H[2]
        self.d = self.H[3]
        self.e = self.H[4]
        self.f = self.H[5]
        self.g = self.H[6]
        self.h = self.H[7]
        self.w = [0] * 16

    def hash(self, input):
        self.reset()
        self.init_msg_block(input)

        self.init_msg_schedule()
        self.__reset_regs()
        self.process_W()

        self.init_msg_schedule()
        self.__reset_regs()
        self.process_W()

        digest = self.get_bytes_digest()

        self.reset()
        self.init_msg_block(digest)
        self.init_msg_schedule()
        self.__reset_regs()
        self.process_W()


    def __compress(self, i, data):
        self.Temp1 = self.h + self.SIGMA_1() + self.choice() + self.K[i] + data & 0xFFFFFFFF
        self.Temp2 = self.SIGMA_0() + self.majority()

        self.h = self.g
        self.g = self.f
        self.f = self.e
        self.e = self.d + self.Temp1 & 0xFFFFFFFF
        self.d = self.c
        self.c = self.b
        self.b = self.a
        self.a = self.Temp1 + self.Temp2 & 0xFFFFFFFF


    def process_W(self):
        for i in range(0, 64):
            data = self.__process_W(i)
            # print("%s:\t%s %s" % (i, "{0:032b}".format(self.w[15]), "{0:04x}".format(self.w[15])))
            self.__compress(i, data)

        self.H[0] = (self.H[0] + self.a) & 0xFFFFFFFF
        self.H[1] = (self.H[1] + self.b) & 0xFFFFFFFF
        self.H[2] = (self.H[2] + self.c) & 0xFFFFFFFF
        self.H[3] = (self.H[3] + self.d) & 0xFFFFFFFF
        self.H[4] = (self.H[4] + self.e) & 0xFFFFFFFF
        self.H[5] = (self.H[5] + self.f) & 0xFFFFFFFF
        self.H[6] = (self.H[6] + self.g) & 0xFFFFFFFF
        self.H[7] = (self.H[7] + self.h) & 0xFFFFFFFF

        self.block_start += 64


    def __process_W(self, i):
        if (i < 16):
            d_out = self.W[i]
        else:
            s0 = self.sigma_0(self.w[1])
            s1 = self.sigma_1(self.w[14])
            d_out = self.w[0] + s0 + self.w[9] + s1 & 0xFFFFFFFF

        for i in range(15):
            self.w[i] = self.w[(i+1)]
        self.w[15] = d_out

        

        return d_out

            
class SHA256_opt2(SHA256):
    def __init__(self) -> None:
        super().__init__()

        self.BH = [0] * 8
        self.BM = [0] * 80

    def init_msg_block_hdr(self):
        self.mblock = [0] * 128 # 128 bytes buffer
        self.mblock[80] = 128

        length = 80 << 3
        self.mblock[120:] = length.to_bytes(8, byteorder='big', signed=False)
        

    def backup_M(self):
        self.BM = self.mblock.copy() # backup

    def restore_M(self):
        self.mblock = self.BM.copy()

    def backup_H(self):
        self.BH = self.H.copy()

    def restore_H(self):
        self.H = self.BH.copy()

    def set_first_block_payload(self, buffer):
        self.mblock[0:64] = buffer

    def hash_first_block(self):
        self.reset()
        self.init_msg_schedule()
        self.process_W()
        self.compress()

        self.backup_H()
        self.backup_M()
        pass

    def set_second_block_payload(self, buffer):
        self.restore_M()
        self.mblock[64:80] = buffer

    def hash_second_block(self):
        self.restore_H()
        self.init_msg_schedule()
        self.process_W()
        self.compress()

        self.print_working_vars()
        self.print_h_values()
        quit()


        # self.print_w_block()
        # self.print_h_values()

    def hash_digest(self):
        digest = self.get_bytes_digest()

        self.reset()
        self.init_msg_block(digest)
        self.init_msg_schedule()
        self.process_W()
        self.compress()


        


    






class BTCMiner:
    def __init__(self) -> None:
        self.hashes = 0
        self.sha256 = SHA256_naieve()

        self.ver = None,  # 4 bytes
        self.prev_block = None,  # 32 bytes
        self.mrkl_root = None, # 32 bytes
        self.time = None, # 4 bytes
        self.bits = None, # 4 bytes
        self.nonce = None # 4 bytes

        self.target = None

    def set_ver(self, ver):
        self.ver = ver.to_bytes(4, 'little', signed=True)
        pass

    def set_prev_block(self, prev_block):
        self.prev_block = bytearray.fromhex(prev_block)
        self.prev_block.reverse()

        pass
    def set_mrkl_root(self, mrkl_root):
        self.mrkl_root = bytearray.fromhex(mrkl_root)
        self.mrkl_root.reverse()
        

    def set_time(self, time : int):
        self.time = time.to_bytes(4, 'little', signed=False)
        pass

    def set_bits(self, bits: int):
        self.bits = bits.to_bytes(4, 'little', signed=False)
        a = bytearray(self.bits)
        a.reverse()

        i = a[0]
        c = int.from_bytes(a[1:4],'big')

        self.target = bytearray((c * pow(2, (8*(i-3)))).to_bytes(32, 'big'))

    def set_nonce(self, nonce : int):
        self.nonce = nonce.to_bytes(4, 'little', signed=False)
        pass

    def inc_nonce(self):
        nonce = int.from_bytes(self.nonce, 'little')
        nonce += 1
        self.set_nonce(nonce)

    def get_hdr(self):
        hdr = bytearray(self.ver + self.prev_block + self.mrkl_root  + self.time + self.bits + self.nonce)
        return hdr


    def display_hashrate(self):
        print("Hash-rate: %s H/s" % self.hashes)
        self.hashes = 0


    def mine(self):
        # rt = RepeatedTimer(1, self.display_hashrate)
        success = False

        while not success:
            hdr = self.get_hdr()
            print(hdr.hex())
            # Naieve
            # self.sha256.hash("12345678123456781234567812345678123456781234567812345678123456781234567812345678".encode("utf-8"))
            self.sha256.hash(hdr)
            hash = bytearray(self.sha256.get_bytes_digest())
            hash.reverse()
            self.hashes += 1

            if (hash <= self.target):
                success = True
                # rt.stop()
            else:
                self.inc_nonce()

        return hash

class BTCMiner2(BTCMiner):
    def __init__(self) -> None:
        super().__init__()
        self.sha256 = SHA256_opt2()


    def get_block_1(self):
        return self.get_hdr()[0:64]

    def get_block_2(self):
        return self.get_hdr()[64:80]

    def mine(self):
        rt = RepeatedTimer(1, self.display_hashrate)
        success = False


        # Setup message block for hdr hashing sequence
        self.sha256.init_msg_block_hdr()

        # First, load and hash the first block
        self.sha256.set_first_block_payload(self.get_block_1())

        # hash the first block
        self.sha256.hash_first_block()

        while not success:
            # Send second block
            self.sha256.set_second_block_payload(self.get_block_2())

            # Hash second block
            self.sha256.hash_second_block()

            # Hash digest
            self.sha256.hash_digest()

            hash = bytearray(self.sha256.get_bytes_digest())
            hash.reverse()
            self.hashes += 1

            if (hash <= self.target):
                    success = True
                    rt.stop()
            else:
                    self.inc_nonce()

        return hash

        

        





        

miner = BTCMiner2()
miner.set_ver(1)
miner.set_prev_block("0000000000000000000000000000000000000000000000000000000000000000")
miner.set_mrkl_root("4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b")
miner.set_time(1231006505)
miner.set_bits(486604799)

miner.set_nonce(2083236893) # On the mark
#miner.set_nonce(0)

hash = miner.mine()
print("=== DONE ===")
print(hash.hex())

# Should yield this hash
# 000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f



    



# sha256 = SHA256()


# # Mock block header input
# input = "12345678123456781234567812345678123456781234567812345678123456781234567812345678".encode('utf-8')


# hash = sha256.hash(input)
# print(hash)

# Expected 
# a9a1bb77 2b44d320 262d9acc f044c9d3 508a83fb e4d52d6b 4e974055 970c81d5

#  echo -n "12345678123456781234567812345678123456781234567812345678123456781234567812345678" | sha256sum | cut -d' ' -f1 | xxd -r -p | sha256sum
# 6e5a17f692f993a6b19a33fe299bca70fafc449822e31b5b2460423556d48167


# echo -n "AAAABBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCDDDDEEEEFFFF" | sha256sum | cut -d' ' -f1 | xxd -r -p | sha256sum