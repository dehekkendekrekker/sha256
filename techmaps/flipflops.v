module \$dffe (CLK, EN, D, Q);


parameter CLK_POLARITY = 0;
parameter EN_POLARITY = 0;
parameter WIDTH = 0;


input CLK;
input EN;
input  [WIDTH-1:0] D;
output reg [WIDTH-1:0] Q;


if (CLK_POLARITY && EN_POLARITY)
    DFFE_PN _TECHMAP_REPLACE_(.C(CLK), .E(~EN), .D(D), .Q(Q));
if (CLK_POLARITY && !EN_POLARITY)
    DFFE_PN _TECHMAP_REPLACE_(.C(CLK), .E(EN), .D(D), .Q(Q));
if (!CLK_POLARITY && EN_POLARITY)
    DFFE_PN _TECHMAP_REPLACE_(.C(~CLK), .E(~EN), .D(D), .Q(Q));
if (!CLK_POLARITY && !EN_POLARITY)
    DFFE_PN _TECHMAP_REPLACE_(.C(~CLK), .E(EN), .D(D), .Q(Q));


endmodule



// module DFFE_PN (D, C, E, Q);

// parameter \CLK_POLARITY = 0;
// parameter \EN_POLARITY = 0;
// parameter \WIDTH = 1;

// output Q;
// input E;
// input C;
// input D;


// \74AC377_8x1DFFE _TECHMAP_REPLACE_(.D(D), .CP(C), .CE(E), .Q(Q));
// endmodule