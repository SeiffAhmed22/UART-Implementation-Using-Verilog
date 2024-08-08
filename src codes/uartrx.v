module uartrx #(
    parameter clk_freq = 1000000, // Clock Frequency = 1MHz
    parameter baud_rate = 9600, // Baud Rate = 9600
    parameter IDLE = 1'b0,
    parameter START = 1'b1
    ) (
    input clk, rst,
    input rx,
    output reg done,
    output reg [7:0] rxdata
    );
    localparam clk_count = (clk_freq/baud_rate); // Ratio between clock frequency and baud rate
    
    integer count = 0; // Used for UART Clock Generation

    reg uclk = 0; // UART Clock
    reg state;
    reg [2:0] counter;

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
        if (rst) begin
            done <= 0;
            rxdata <= 0;
            counter <= 0;
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    rxdata <= 0;
                    counter <= 0;
                    done <= 0;
                    if(rx == 1'b0)
                        state <= START;
                    else
                        state <= IDLE;
                end
                START: begin
                    counter <= counter + 1;
                    rxdata <= {rx, rxdata[7:1]};
                    if(counter == 3'h7) begin
                        counter <= 0;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule