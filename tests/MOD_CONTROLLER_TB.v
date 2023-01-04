module MOD_CONTROLLER_TB;
`INIT

MOD_CONTROLLER mut(
    CLK, RDY, D, RXF, TXE, RD, WR
);

wire [7:0] D;
wire RD, WR;
reg RDY, TXE, RXF;




localparam period = 20;  

initial begin
    `SET_MOD("MOD_CONTROLLER_TB");
    $dumpfile("./build/MOD_CONTROLLER_TB.vcd");
    $dumpvars(0, MOD_CONTROLLER_TB);
    $timeformat(-6, 0, " us", 20);

    #20000
    `FAILED("TIMEOUT");
    $finish;
end


/* 
========================
    D-bus behavior
========================
*/
reg [7:0] input_buffer, output_buffer;

initial output_buffer = 8'hFF;

// If write is enabled, D should be assigned to the output buffer
assign D = (!RD) ? output_buffer : 8'hz;
assign input_buffer = (!WR) ? D: 8'hx;

always @(CLK) begin
    // Clear output buffer when writing is disabled
    if (WR) output_buffer = 8'hz;
end


// Setup clock signal
reg CLK;
initial CLK = 0;
always #period CLK = ~CLK;


// Setup test state

reg [7:0] test_state;

localparam ST_SETUP = 0;
localparam ST_TEST_RDY = 10;
localparam ST_CHECK_RDY = 20; // Check if the sytem behaves correctly after RDY == 1
localparam ST_SEND_PAYLOAD_LOAD = 30;
localparam ST_SEND_PAYLOAD_SEND = 40;


// Payload related
reg [7:0] payload [14];
reg [7:0] payload_ctr;



initial begin
    payload[0] = 8'h01;
    payload[1] = 8'd12;
    payload[2] = "H";
    payload[3] = "e";
    payload[4] = "l";
    payload[5] = "l";
    payload[6] = "o";
    payload[7] = " ";
    payload[8] = "w";
    payload[9] = "o";
    payload[10] = "r";
    payload[11] = "l";
    payload[12] = "d";
    payload[13] = "!";

    payload_ctr = 0;
end

reg [7:0] stage_buffer;

assign stage_buffer = payload[payload_ctr];

initial begin
    RDY = 0;
    RXF = 1;
    TXE = 1;
    test_state <= ST_SETUP;
end



/* 
========================
    WRITE DATA BEHAVIOR
========================
*/

reg [7:0] written_data [256];
reg [7:0] written_data_ctr;

initial begin
    written_data_ctr = 0;
end

always @(negedge WR) begin
    TXE = 1;
end

always @(posedge TXE) begin
    written_data[written_data_ctr] = input_buffer;
    TXE = 0;
    written_data_ctr += 1;
end





always @(negedge CLK) begin
    case(test_state)
    ST_SETUP: begin
        test_state <= ST_TEST_RDY;
    end
    ST_TEST_RDY: begin
        RDY = 1;
        test_state <= ST_CHECK_RDY;
    end
    ST_CHECK_RDY: begin
        if (!WR) begin
            if (input_buffer !== mut.READY_BYTE) begin
                `FAILED("Expected READY_BYTE");
            end else begin
                test_state <= ST_SEND_PAYLOAD_LOAD;
            end

        end

    end
    ST_SEND_PAYLOAD_LOAD: begin
        if(!RD) begin
            output_buffer = stage_buffer;
            payload_ctr += 1;
            RXF = 1;
        end
    end
    
    endcase
end


always @(posedge CLK) begin
    case(test_state)
    ST_SEND_PAYLOAD_LOAD: begin
        RXF = 0; // Tell mut that there is data to be read
    end
    endcase
end






endmodule

