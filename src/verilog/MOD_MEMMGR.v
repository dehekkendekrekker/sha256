`include "./src/verilog/MOD_MEM128K.v"
`include "./src/verilog/MOD_EEPROM32K.v"
`include "./src/verilog/7400/MOD_74x393.v"

module MOD_MEMMGR(
    input CLK,
    input COPY_ROM,
    output reg COPY_ROM_COMPLETE,
    input RE,
    input WR,
    input [7:0] ADDR,
    inout [31:0] DATA
);

MOD_EEPROM32K rom (rom_address, DATA, rom_enable, 1'b0, 1'b1); // Output enabled, write disabled;
MOD_MEM128K ram({7'b0000000, ram_address}, DATA, ram_clk, 1'b0, ram_write);
MOD_74x393 ctr(ctr_clk,ctr_clr, ctr_output[3],ctr_clr, ctr_output[3:0], ctr_output[7:4]);



// CTR related
reg ctr_clr;
reg ctr_clk;
reg [7:0] ctr_output;
reg [7:0] add_buf; // Buffer to hold value to add to address when copying
reg [7:0] cpy_addr; // The address used when copying
reg st_copying_rom; // Is true when the ctr_clk can be used

// Tie the ctr_clk to the clock signal
assign ctr_clk = CLK & st_copying_rom;
assign cpy_addr = add_buf + ctr_output;


// ROM related
reg rom_enable;
reg [12:0] rom_address;

// RAM related
reg ram_clk;
reg ram_write;
reg [7:0] ram_address;

// Tie counter output to ROM/RAM address
assign rom_address = {5'b00000, ctr_output};
assign rom_enable = ~st_copying_rom; // ROM is enabled when copying, otherwise disabled

assign ram_address = st_copying_rom ? cpy_addr : ADDR;

// When copying, the RAM data bus is tied to the ROM data bus, otherwise DATA

// RAM is write enabled when copying, otherwise it takes the port value
assign ram_write = st_copying_rom ? 1'b0 : WR; 

// The counter is in clear mode when not copying
assign ctr_clr = ~st_copying_rom;


assign ram_clk = ~ctr_clk;

initial begin
    COPY_ROM_COMPLETE = 0;
    st_copying_rom = 0;
    add_buf = 0;
end











// We determine when the ROM copy should end
always @(negedge CLK) begin
    if (COPY_ROM == 1) begin
        st_copying_rom <= 1;  // We enable the ROM copy counter
    end
    if (ctr_output == 71) begin
        st_copying_rom <= 0; // Disable copying
        COPY_ROM_COMPLETE <= 1;
    end
    if (cpy_addr == 7) begin
        add_buf <= 56;
    end
end

// *** DEBUG ***
// On positive edges a write should occur
// always @(posedge ctr_clk) begin
//     //$display("CTR: %d: ROM ADDR: %b   ROM VALUE: %h", ctr_output, rom_address, DATA);
// end


/// **** DEBUG *****
// This block disables writing to RAM
// always @(negedge ctr_clk) begin
//     // Debug info
//     //$display("CTR: %d: RAM ADDR: %b RAM VALUE: %h", ctr_output, ram_address, {ram.bank_1.buffer[ram_address],ram.bank_2.buffer[ram_address],ram.bank_3.buffer[ram_address],ram.bank_4.buffer[ram_address]});

    
// end

endmodule