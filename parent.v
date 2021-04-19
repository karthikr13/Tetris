module parent(
    input arduinoClock,
    input clock,
    input start,
    output[7:0] ledOut,
    output arduinoStart,
    output temp,
    output startest);

    wire[255:0] values;
    reg[8:0] counter = 0;
    reg ledstart = 0;
    reg clk = 0;

    LedControllerFinal controller(clock, arduinoClock, ledstart, values, ledOut, arduinoStart, temp);

    single_block_grid gridtest(.clk(clk), .reset(1'b0), .ctrl1(1'b0), .ctrl2(1'b0), .grid_out(values));

    always @(posedge clock) begin
        if(start == 1) begin
            $display("Starting...");
            clk = ~clk;
            #20
            clk = ~clk;
            #20
            ledstart <= 1;
        end else if (start == 0) begin
            ledstart <= 0;
        end
        // $display()
    end

    assign startest = arduinoStart;

    // always @(start) begin
    //     clk = ~clk;
    //     #20
    //     clk = ~clk;
    //     #20
    //     ledstart <= 1;
    // end

endmodule