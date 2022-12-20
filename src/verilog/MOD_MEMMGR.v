`include "./src/verilog/MOD_MEM128K.v"
`include "./src/verilog/MOD_EEPROM32K.v"
`include "./src/verilog/7400/MOD_74x393.v"

module MOD_MEMMGR(
    input CLK,
    input INIT,
    output reg INIT_COMPLETE
);

MOD_EEPROM32K rom (rom_address, rom_output, rom_enable, 1'b0, 1'b1); // Output enabled, write disabled;
MOD_MEM128K ram(ram_address, ram_io, ram_enable, 1'b0, ram_write);
MOD_74x393 ctr(ctr_clk,ctr_clr, ctr_output[3],ctr_clr, ctr_output[3:0], ctr_output[7:4]);

// CTR related
reg ctr_clr;
reg ctr_clk;
reg [7:0] ctr_output;

// ROM related
reg rom_enable;
reg [31:0] rom_output;
reg [12:0] rom_address;

// RAM related
reg ram_enable;
reg ram_write;
reg [14:0] ram_address;
wire [31:0] ram_io;
reg [31:0]  ram_io_driver;

assign ram_io = rom_output;

// Tie counter output to ROM/RAM address
assign rom_address = {5'b00000, ctr_output[7:0]};
assign ram_address = {7'b0000000, ctr_output[7:0]};


initial begin
    ctr_clr = 1; // Start in memory clearing mode
    ctr_clk = 0; // Setup counter clock for trigger, it does things when low.
    INIT_COMPLETE = 0; // INIT_COMPLETE is low by default
    ram_write = 0; // PUT RAM in write mode by default
    rom_enable = 0; // Pull rom_enable low, this makes sure the databus contains data by default
    ram_enable = 1; // Disable writing
end




// Handles positive clock triggers
always @(posedge CLK) begin 
    if (INIT && ~INIT_COMPLETE) begin
        ctr_clr <= 0 ;
        ctr_clk <= ~ctr_clk; // Toggle counter clock
    end
end

// On positive edges a write should occur
always @(posedge ctr_clk) begin
    $display("CTR: %d: ROM ADDR: %b   ROM VALUE: %h", ctr_output, rom_address, rom_output);
    ram_enable <= 0;
end

always @(negedge ctr_clk) begin
    ram_enable <= 1;
    $display("CTR: %d: RAM ADDR: %b RAM VALUE: %h", ctr_output, ram_address, {ram.bank_1.buffer[ram_address],ram.bank_2.buffer[ram_address],ram.bank_3.buffer[ram_address],ram.bank_4.buffer[ram_address]});

    if (ctr_output == 71) begin
        INIT_COMPLETE <= 1;
    end
end

endmodule