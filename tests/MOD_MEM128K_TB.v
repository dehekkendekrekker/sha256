module MOD_MEM128K_TB;
`INIT

MOD_MEM128K mut(
    A,D_READ,D_WRITE,CLK,OE,WE
);

reg [14:0] A;
reg [31:0] D_WRITE;
wire [31:0] D_READ;
reg OE;
reg WE;

localparam period = 20;  

initial begin
    `SET_MOD("MOD_MEM128K_TB");
    $dumpfile("./build/MOD_MEM128K_TB.vcd");
    $dumpvars(0, MOD_MEM128K_TB);
    $timeformat(-6, 0, " us", 20);

    #20000
    $finish();

end

reg [31:0] KE [64];

// Setup test data
initial begin
// K-constants
KE[0] = 32'h428a2f98;
KE[1] = 32'h71374491;
KE[2] = 32'hb5c0fbcf;
KE[3] = 32'he9b5dba5;
KE[4] = 32'h3956c25b;
KE[5] = 32'h59f111f1;
KE[6] = 32'h923f82a4;
KE[7] = 32'hab1c5ed5;
KE[8] = 32'hd807aa98;
KE[9] = 32'h12835b01;
KE[10] = 32'h243185be;
KE[11] = 32'h550c7dc3;
KE[12] = 32'h72be5d74;
KE[13] = 32'h80deb1fe;
KE[14] = 32'h9bdc06a7;
KE[15] = 32'hc19bf174;
KE[16] = 32'he49b69c1;
KE[17] = 32'hefbe4786;
KE[18] = 32'hfc19dc6;
KE[19] = 32'h240ca1cc;
KE[20] = 32'h2de92c6f;
KE[21] = 32'h4a7484aa;
KE[22] = 32'h5cb0a9dc;
KE[23] = 32'h76f988da;
KE[24] = 32'h983e5152;
KE[25] = 32'ha831c66d;
KE[26] = 32'hb00327c8;
KE[27] = 32'hbf597fc7;
KE[28] = 32'hc6e00bf3;
KE[29] = 32'hd5a79147;
KE[30] = 32'h6ca6351;
KE[31] = 32'h14292967;
KE[32] = 32'h27b70a85;
KE[33] = 32'h2e1b2138;
KE[34] = 32'h4d2c6dfc;
KE[35] = 32'h53380d13;
KE[36] = 32'h650a7354;
KE[37] = 32'h766a0abb;
KE[38] = 32'h81c2c92e;
KE[39] = 32'h92722c85;
KE[40] = 32'ha2bfe8a1;
KE[41] = 32'ha81a664b;
KE[42] = 32'hc24b8b70;
KE[43] = 32'hc76c51a3;
KE[44] = 32'hd192e819;
KE[45] = 32'hd6990624;
KE[46] = 32'hf40e3585;
KE[47] = 32'h106aa070;
KE[48] = 32'h19a4c116;
KE[49] = 32'h1e376c08;
KE[50] = 32'h2748774c;
KE[51] = 32'h34b0bcb5;
KE[52] = 32'h391c0cb3;
KE[53] = 32'h4ed8aa4a;
KE[54] = 32'h5b9cca4f;
KE[55] = 32'h682e6ff3;
KE[56] = 32'h748f82ee;
KE[57] = 32'h78a5636f;
KE[58] = 32'h84c87814;
KE[59] = 32'h8cc70208;
KE[60] = 32'h90befffa;
KE[61] = 32'ha4506ceb;
KE[62] = 32'hbef9a3f7;
KE[63] = 32'hc67178f2;

end


// Setup clock signal
reg CLK;
initial CLK = 0;
always #period CLK = ~CLK;

// Setup state
reg state;
localparam writing = 0;
localparam reading = 1;
initial state = writing;

// Setup 
initial begin
    A = 0;
    WE = 0;
    OE = 1;
    D_WRITE = KE[A];
end

reg [31:0] value;


always @(posedge CLK) begin
    case(state)
    writing: begin
        // Do write
        A += 1;
        D_WRITE = KE[A];
        if (A == 64) begin
            // Check values in registers
            for (integer i = 0; i <64; i++) begin
                value = {mut.bank_1.buffer[i],mut.bank_2.buffer[i],mut.bank_3.buffer[i],mut.bank_4.buffer[i]} ;
                if (value !== KE[i])
                    `FAILED_EXP(i,value, KE[i])
            end

            // Reset for state transition
            A = 0;
            WE = 1; // Disable writing
            OE = 0; // Enable reading
            state = reading;
        end
    end
    endcase
end

always @(posedge CLK) begin
    case(state)
    reading: begin
        if (D_READ !== KE[A])
            `FAILED_EXP(A, D_READ, KE[A]);
        A += 1;
        if (A==64) $finish;

    end
    endcase
end
    



endmodule