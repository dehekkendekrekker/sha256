`include "./src/verilog/MOD_MEM128K.v"
`include "./src/verilog/MOD_EEPROM32K.v"
`include "./src/verilog/7400/MOD_74x393.v"


// This module implements an abstraction of a 32 bits wide RAM module
// This RAM module holds the initial H-values as well as K-constants
// These values are stored in a ROM module, that are copied to the RAM when COPY_ROM is high.
// When copying is done, RDY is pulled high, indicating the module is ready for use.
// H and K value can be retrieved by applying 0 and 1 to HK_SELECTOR respectively.
// By applying the correct address to H_ADDR and K_ADDR respectively, the requested value will be presented on RAM_DR when CLK is low.
module MOD_HK_MEM(
    input CLK,
    input COPY_ROM,
    input HK_SELECTOR,
    input [2:0] H_ADDR,
    input [5:0] K_ADDR,
    output [31:0] RAM_DR,
    output reg RDY
);

MOD_EEPROM32K ROM(ROM_A, ROM_D, ROM_E, 1'b0, 1'b1); // Output enabled, write disabled;
MOD_MEM128K RAM(RAM_A, RAM_DR, RAM_DW, RAM_clk, ~RAM_WE, RAM_WE);
MOD_74x393 ctr(ctr_clk,ctr_clr, ctr_output[3],ctr_clr, ctr_output[3:0], ctr_output[7:4]);


// Data bus
// The write bus of the HK RAM module must be tied to the ROM data bus
reg [31:0] ROM_D;
reg [31:0] RAM_DW;
assign RAM_DW = ROM_D;


// Address bus
reg [14:0] RAM_A;
reg [14:0] hk_selected_addr;


// Address bus selection
localparam HSEL=0;
localparam KSEL=1;

assign hk_selected_addr = (HK_SELECTOR == HSEL) ? {12'b000000000000, H_ADDR} : {9'b000000001, K_ADDR};
assign RAM_A = (st_copying_ROM) ? {7'b0000000, cpy_addr} : hk_selected_addr;


// CTR related
reg ctr_clr;
reg ctr_clk;
reg [7:0] ctr_output;
reg [7:0] add_buf; // Buffer to hold value to add to address when copying
reg [7:0] cpy_addr; // The address used when copying
reg st_copying_ROM; // Is true when the ctr_clk can be used

// Tie the ctr_clk to the clock signal
assign ctr_clk = CLK & st_copying_ROM;
assign cpy_addr = add_buf + ctr_output;


// ROM related
reg ROM_E;
reg [12:0] ROM_A;

// RAM related
reg RAM_clk;
reg RAM_WE;

// Tie counter output to ROM/RAM address
assign ROM_A = {5'b00000, ctr_output};
assign ROM_E = ~st_copying_ROM; // ROM is enabled when copying, otherwise disabled

// RAM is write enabled when copying
assign RAM_WE = ~st_copying_ROM;

// The counter is in clear mode when not copying
assign ctr_clr = ~st_copying_ROM;

assign RAM_clk = (st_copying_ROM) ? ~ctr_clk : CLK;

initial begin
    RDY = 0;
    st_copying_ROM = 0;
    add_buf = 0;
end


// We determine when the ROM copy should end
always @(negedge CLK) begin
    if (COPY_ROM == 1) begin
        st_copying_ROM <= 1;  // We enable the ROM copy counter
    end
    if (ctr_output == 71) begin
        st_copying_ROM <= 0; // Disable copying
        RDY <= 1;
    end
    if (cpy_addr == 7) begin
        add_buf <= 56;
    end
end

// *** DEBUG ***
// On positive edges a write should occur
// always @(posedge ctr_clk) begin
//     $display("CTR: %d: ROM ADDR: %b   ROM VALUE: %h", ctr_output, ROM_A, ROM_D);
// end


/// **** DEBUG *****
// always @(negedge ctr_clk) begin
//     // Debug info
//     $display("CTR: %d: RAM ADDR: %b RAM VALUE: %h", ctr_output, RAM_Aess, {RAM.bank_1.buffer[RAM_Aess],RAM.bank_2.buffer[RAM_Aess],RAM.bank_3.buffer[RAM_Aess],RAM.bank_4.buffer[RAM_Aess]});

    
// end

endmodule