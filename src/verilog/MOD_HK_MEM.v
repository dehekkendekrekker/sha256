`include "./src/verilog/MOD_MEM128K.v"
`include "./src/verilog/MOD_EEPROM32K.v"
`include "./src/verilog/7400/MOD_74x393.v"


// This module implements an abstraction of a 32 bits wide RAM module
// This RAM module holds the initial H-values as well as K-constants
// These values are stored in a ROM module, that are copied to the RAM when RST is high.
// When copying is done, RDY is pulled high, indicating the module is ready for use.
// H and K value can be retrieved by applying 0 and 1 to HK_SELECTOR respectively.
// By applying the correct address to H_ADDR and K_ADDR respectively, the requested value will be presented on RAM_DR when CLK is low.
module MOD_HK_MEM(
    input CLK,
    input RST,
    input HK_SELECTOR,
    input [2:0] H_ADDR,
    input [5:0] K_ADDR,
    output [31:0] RAM_DR,
    output reg RDY
);

MOD_EEPROM32K ROM(ROM_A, ROM_D, ~resetting, 1'b0, 1'b1); // Output enabled, write disabled;
MOD_MEM128K RAM({7'b0000000,RAM_A}, RAM_DR, ROM_D, RAM_clk, resetting, ~resetting);
MOD_74x393 addr_ctr(addr_clk,~resetting, ctr_output[3],~resetting, ctr_output[3:0], ctr_output[7:4]);
MOD_74x393 delay(CLK,~resetting, delay_output[3],~resetting, delay_output[3:0], delay_output[7:4]);


// Data bus
// The write bus of the HK RAM module must be tied to the ROM data bus
reg [31:0] ROM_D;

// Address bus
reg [7:0] RAM_A;
reg [7:0] RAM_SEL_A;


// Address bus selection
localparam HSEL=0;
localparam KSEL=1;

assign RAM_SEL_A = (HK_SELECTOR == HSEL) ? {5'b00000, H_ADDR} : {2'b01, K_ADDR};
assign RAM_A = (resetting) ? {cpy_addr} : RAM_SEL_A;


// CTR related
reg ctr_clr;
reg addr_clk;
reg [7:0] ctr_output;
reg [7:0] add_buf; // Buffer to hold value to add to address when copying
reg [7:0] cpy_addr; // The address used when copying
reg resetting; // Is true when the addr_clk can be used

// Delay related
reg [7:0] delay_output;
reg delay_clk;

// Tie the addr_clk to the clock signal
// assign addr_clk = CLK & resetting;
assign cpy_addr = add_buf + ctr_output;




reg [12:0] ROM_A;

// RAM related
reg RAM_clk;

// Tie counter output to ROM/RAM address
assign ROM_A = {5'b00000, ctr_output};

// The addr clock is slowed down when initializing
assign RAM_clk = (resetting) ? addr_clk : CLK;







initial begin
    RDY = 0;
    resetting = 0;
    add_buf = 0;
    addr_clk = 0;
end


// We determine when the ROM copy should end
always @(negedge CLK) begin
    if (RST == 1) begin
        resetting <= 1;  // We enable the ROM copy counter
    end
    if (ctr_output == 71) begin
        resetting <= 0; // Disable copying
        RDY <= 1;
    end
    if (cpy_addr == 7) begin
        add_buf <= 56;
    end
    // This is a delay control to compensate for the ROM's slow acces time. 16 means that every 32 
    // clock ticks RAM will be written
    if (delay_output % 16 == 0) begin
        addr_clk <= ~addr_clk;
    end
end

// *** DEBUG ***
// On positive edges a write should occur
// always @(posedge addr_clk) begin
//     $display("CTR: %d: ROM ADDR: %b   ROM VALUE: %h", ctr_output, ROM_A, ROM_D);
// end


/// **** DEBUG *****
// always @(negedge addr_clk) begin
//     // Debug info
//     $display("CTR: %d: RAM ADDR: %b RAM VALUE: %h", ctr_output, RAM_Aess, {RAM.bank_1.buffer[RAM_Aess],RAM.bank_2.buffer[RAM_Aess],RAM.bank_3.buffer[RAM_Aess],RAM.bank_4.buffer[RAM_Aess]});

    
// end

endmodule