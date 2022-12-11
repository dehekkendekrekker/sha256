class SHA256:
    def __init__(self) -> None:
        self.input_len = 0
        self.mblock = [0] * 64
        self.W = [[0] * 4] * 64
        

    def _init_msg_block(self, input, input_len):
        self.mblock[0:input_len] = input
        self.mblock[input_len] = 1

        # Add bitlength of input at the end of the message block as 64 bit big endian block
        length = input_len << 3
        self.mblock[56:] = length.to_bytes(8, byteorder='big')

    def __init_msg_schdedule(self):
        for i in range(16):
            self.W[i] = self.mblock[i*4:i*4+4]
        

    
    

        

    def hash(self, input, length):
        self._init_msg_block(input, length)
        self.__init_msg_schdedule()

        self.print_mblock()
        self.print_w_block()

        
        
        

    def print_mblock(self):
        output = ""
        for i in range(64):
            if i % 4 == 0:
                output += "\n"

            output += "%s " % "{0:08b} ".format(self.mblock[i])
        print(output)

    def print_w_block(self):
        print("=================== W =====================")
        for i in range(64):
            print("%s:\t%s" % (i, "".join(["{0:08b} ".format(x) for x in self.W[i]])))
            


            
                


sha256 = SHA256()
input = "Hello world!".encode("utf-8")


hash = sha256.hash(input, len(input))
print(hash)