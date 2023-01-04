module MOD_CONTROLLER(CLK, RDY, D, RXF, TXE, RD, WR);

input CLK;
inout [7:0]D;
input RDY;

output reg RD, WR;
input RXF, TXE;

// FSM related
localparam ST_AWAIT_RDY = 0;
localparam ST_SEND_RDY_PRE = 5;
localparam ST_SEND_RDY = 10;
localparam ST_SEND_RDY_POST = 13;
localparam ST_AWAIT_CMD_PRE = 15;
localparam ST_AWAIT_CMD = 20;
localparam ST_AWAIT_CMD_POST = 25;

localparam ST_READ_MSG = 30;
localparam ST_READ_MSG_LEN = 30;
localparam ST_READ_MSG_DATA = 30;

reg [7:0] state;

reg [7:0] msg_len;

initial begin
    WR = 8'bx;
    RD = 1;
    state = ST_AWAIT_RDY;
end


reg [7:0] next_byte_out;


localparam READY_BYTE = 8'hFF;
localparam CMD_READ_MSG = 8'h01;

/* 
========================
    D-bus behavior
========================
*/
reg [7:0] input_buffer;
reg [7:0] output_buffer;
assign D = (!WR) ? output_buffer : 8'hz;
assign input_buffer = (!RD) ? D: 8'hx;



always @(posedge CLK) begin
    case(state)

    // This state deals with waiting for the RDY signal
    ST_AWAIT_RDY: begin
        // Ready pin is pulled high, change state
        if (RDY) state <= ST_SEND_RDY_PRE;
    end

    // These states deal with writing the READY_BYTE to the computer
    ST_SEND_RDY_PRE: begin
        WR = 1; // Setup write
        state <= ST_SEND_RDY;
    end
    ST_SEND_RDY: begin
        WR = 0; // Send the ready byte off
        state <= ST_SEND_RDY_POST;
    end
    ST_SEND_RDY_POST: begin
        WR = 1; // WR strobe HIGH
        state <= ST_AWAIT_CMD_PRE;
    end


    ST_AWAIT_CMD_PRE: begin
        if (!RXF) begin // A byte has arrived
            RD = 0; // Pull RD low to read data;
            state <= ST_AWAIT_CMD; 
        end
    end
    ST_READ_MSG: begin
        if (!RXF) begin
            RD = 0;
            state <= ST_READ_MSG_LEN;
        end
    end
    


    endcase
end

always @(negedge TXE) begin
end

reg [7:0] a;

always @(negedge WR) begin
    $display("WR went down: %d", state);
    case(state)
    ST_SEND_RDY: begin
        output_buffer = READY_BYTE;
    end
    endcase
end

// WR goes up, we're setting up for a write
// always @(posedge WR) begin
//     $display("WR went up: %d", state);
    
//     endcase
// end

// Define the behavior for when data is present in the FIFO buffer to be read
always @(negedge RXF) begin
end

// Defines the behavior for when RD goes down, ie a read should occur
always @(negedge RD) begin
end

always @(negedge CLK) begin
    case(state)
    
    ST_AWAIT_CMD: begin
        // At this point, RD is low and data can be read.
        if (input_buffer === CMD_READ_MSG) begin
            state <= ST_READ_MSG;
            RD = 1;
        end // else Do error sending

    end
    ST_READ_MSG_LEN: begin
        msg_len <= input_buffer;
        RD = 0;
    end

    endcase
end





endmodule