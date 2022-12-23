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


// D-type FlipFlop with enable, Positive clock, negative enable
module DFFE_PN (D, C, E, Q);

parameter \CLK_POLARITY = 0;
parameter \EN_POLARITY = 0;
parameter \WIDTH = 0;

output Q;
input E;
input C;
input D;


DFFE_PN_8BIT _TECHMAP_REPLACE_(.D(D), .CP(C), .CE(E), .Q(Q));
endmodule