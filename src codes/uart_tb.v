module uart_tb;
    reg clk_tb, rst_tb;
    reg rx_tb;
    reg [7:0] dintx_tb;
    reg newd_tb;
    wire tx_dut;
    wire [7:0] doutrx_dut;
    wire donetx_dut, donerx_dut;

    uart_top DUT (clk_tb, rst_tb, rx_tb, dintx_tb,
                    newd_tb, tx_dut, 
                    doutrx_dut, donetx_dut, donerx_dut);

    reg [7:0] tx_data;
    reg [7:0] rx_data;

    // Clock Generation
    initial begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb;
    end

    initial begin
        // Initialization
        rst_tb = 1;
        newd_tb = 0;
        tx_data = 0;
        rx_data = 0;
        #10 rst_tb = 0;

        repeat(10) begin
            newd_tb = 1;
            dintx_tb = $random;
            wait(tx_dut == 0);
            @(posedge DUT.UTX.uclk);
            repeat(8) begin
                @(posedge DUT.UTX.uclk);
                tx_data = {tx_dut, tx_data[7:1]};
            end
            @(posedge donetx_dut);
        end

        newd_tb = 0;
        repeat(10) begin
            rx_tb = 1'b0;
            @(posedge DUT.UTX.uclk);
            repeat(8) begin
                @(posedge DUT.UTX.uclk);
                rx_tb = $random;
                rx_data = {rx_tb, rx_data[7:1]};
            end
            @(posedge donerx_dut);
        end
        $stop;
    end
endmodule