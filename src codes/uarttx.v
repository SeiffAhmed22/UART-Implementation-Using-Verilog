module uarttx #(
    parameter clk_freq = 1000000, // Clock Frequency = 1MHz
    parameter baud_rate = 9600, // Baud Rate = 9600
    parameter IDLE = 2'b00,
    parameter START = 2'b01,
    parameter TRANSFER = 2'b10,
    parameter DONE = 2'b11
    ) (
    input clk, rst,
    input newd,
    input [7:0] tx_data,
    output reg tx,
    output reg donetx
    );
    localparam clk_count = (clk_freq/baud_rate); // Ratio between clock frequency and baud rate
    
    integer count = 0; // Used for UART Clock Generation

    reg uclk = 0; // UART Clock
    reg [1:0] state;
    reg [3:0] counter;

    // UART Clock Generation
    always @(posedge clk) begin
        if(count < clk_count/2)
            count <= count + 1;
        else begin
            count <= 0;
            uclk <= ~uclk;
        end
    end

    always @(posedge uclk) begin
        if(rst)
            state <= IDLE;
        else begin
            case (state)
                IDLE: begin
                    counter <= 0;
                    tx <= 1'b1;
                    donetx <= 1'b0;
                    if (newd) begin
                        state <= TRANSFER;
                        tx <= 1'b0;
                    end
                    else
                        state <= IDLE;
                end
                TRANSFER: begin
                    tx <= tx_data[counter];
                    counter <= counter + 1;
                    if (counter == 4'h8) begin
                        counter <= 0;
                        tx <= 1'b1;
                        donetx <= 1'b1;
                        state <= IDLE;
                    end
                    else
                        state <= TRANSFER;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule