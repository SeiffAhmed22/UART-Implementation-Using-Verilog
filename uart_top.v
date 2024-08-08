module uart_top (
    input clk, rst,
    input rx,
    input [7:0] dintx,
    input newd,
    output tx,
    output [7:0] doutrx,
    output donetx, donerx
    );

    uarttx UTX(clk, rst, newd, dintx, tx, donetx);

    uartrx URX(clk, rst, rx, donerx, doutrx);
endmodule