module parent(
    input arduinoClock,
    input clock,
    input start,
    output[7:0] ledOut,
    output arduinoStart);

    wire[255:0] values;
    reg[8:0] counter = 0;
    reg ledstart = 0;
    reg clk = 0;

    LedControllerFinal controller(clk, arduinoClock, ledstart, values, ledOut, arduinoStart);

    single_block_grid gridtest(.clk(clk), .reset(1'b0), .ctrl1(1'b0), .ctrl2(1'b0), .grid_out(values));

    always @(start) begin
        clk = ~clk;
        #20
        clk = ~clk;
        #20
        ledstart <= 1;
    end

endmodule