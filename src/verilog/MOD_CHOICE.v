module MOD_CHOICE(
    input [0:31] E,
    input [0:31] F,
    input [0:31] G,
    output [0:31] Y
);

assign Y = (E & F) ^ ((~E) & G);


    
endmodule
