`include "./src/verilog/MOD_MEM128K.v"
`include "./src/verilog/MOD_EEPROM8K.v"

module MOD_MEMMGR(
    input CLK,
    input INIT,
    output reg INIT_COMPLETE
);

MOD_EEPROM8K rom (rom_address, rom_output, rom_enable, 1'b0, 1'b1);
MOD_MEM128K ram(ram_address, ram_io, ram_enable, 1'b0, ram_write);


// ROM related
reg rom_enable;
reg [0:1] buffer_counter;
reg [0:31] copy_buffer;
reg [0:7] rom_output;
reg [0:12] rom_address;

// RAM related
reg ram_enable;
reg ram_write;
reg [0:14] ram_address;
wire [0:31] ram_io;
reg [0:31]  ram_io_driver;

assign ram_io = ram_io_driver;



// FSM's
reg addr_state;
reg [0:2] copy_state;
reg [0:1] buf_copy_state;

bit inc_rom_addr;

// States for buf_copy_state
localparam READ_BYTE_1 = 0;
localparam READ_BYTE_2 = 1;
localparam READ_BYTE_3 = 2;
localparam READ_BYTE_4 = 3;


// States for copy_state
localparam READ_ROM = 0;
localparam INC_ROM_ADDR = 1;
localparam INIT_DONE = 2;
localparam WRITE_WORD = 3;
localparam INC_RAM_ADDR = 4;
localparam CHECK_DONE = 5;

// States for addr increase
localparam READ = 0;
localparam INC = 1;



initial begin
    copy_state = READ_ROM;
    buf_copy_state = READ_BYTE_1;
    rom_enable = 0;
    buffer_counter = 0;
    INIT_COMPLETE = 0;
    rom_address = 0;
    

    // RAM
    ram_address = 0;
    ram_enable = 1;
    ram_write = 1;
end


// Handling of address state machine
always @(posedge CLK) begin
    if (INIT) begin
        rom_enable <= 1;
        ram_enable <= 1;
    end
    
end

always @(negedge CLK) begin
    if (INIT) begin
        rom_enable <= 0;
        ram_enable <= 0;
    end
end



always @(posedge CLK) begin
    if (INIT) begin
        // $display("State: %d:%d Address: %d Value %h", copy_state, buf_copy_state, rom_address, copy_buffer);
        case (copy_state)
        READ_ROM:
        begin
            case (buf_copy_state)
            READ_BYTE_1: begin
                copy_buffer[0:7] <= rom_output;
                buf_copy_state <= READ_BYTE_2;
            end
            READ_BYTE_2: begin
                copy_buffer[8:15] <= rom_output;
                buf_copy_state <= READ_BYTE_3;
            end
            READ_BYTE_3: begin
                copy_buffer[16:23] <= rom_output;
                buf_copy_state <= READ_BYTE_4;
            end
            READ_BYTE_4: begin
                copy_buffer[24:31] <= rom_output;
                buf_copy_state <= READ_BYTE_1;
                copy_state <= WRITE_WORD;
            end

            endcase

            // Increase the address
            rom_address <= rom_address + 1;
        end
        WRITE_WORD: begin
            ram_write <= 0; // Write pulse
            ram_io_driver <= copy_buffer;
            copy_state <= INC_RAM_ADDR;
        end
        INC_RAM_ADDR: begin
            $display("RAM addr: %d: value %h", ram_address, {ram.bank_1.buffer[ram_address],ram.bank_2.buffer[ram_address],ram.bank_3.buffer[ram_address],ram.bank_4.buffer[ram_address]});
            ram_write <= 1; // Cancel write pulse
            ram_address <= ram_address + 1;
            copy_state <= CHECK_DONE;
        end
        CHECK_DONE: begin
            if (ram_address == 72) begin
                copy_state <= INIT_DONE;
            end else
                copy_state <= READ_ROM;
        end


        INIT_DONE:
        begin
            INIT_COMPLETE <= 1;
        end
        endcase

        

    end
end






endmodule