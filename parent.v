module parent(
    input arduinoClock,
    input arduinoClock2,
    input clock,
    input start,
    output[7:0] ledOut,
    output[7:0] ledOut2,
    output arduinoStart,
    output arduinoStart2,
    output temp,
    output startest);

    wire[255:0] values;
    reg[8:0] counter = 0;
    reg ledstart = 0;
    reg clk = 0;

    LedControllerFinal controller(clock, arduinoClock, arduinoClock2, ledstart, values, ledOut, ledOut2, arduinoStart, arduinoStart2, temp);

    single_block_grid gridtest(.clk(clk), .reset(1'b0), .ctrl1(1'b0), .ctrl2(1'b0), .grid_out(values));


    integer n;
    always @(posedge clock) begin
        if(start == 1) begin
            // $display("Starting...");
            clk = ~clk;
            #20
            clk = ~clk;
            #20
            ledstart <= 1;
            for(n = 0; n < 256; n = n + 1) begin
                $display("%b", values[n]);
            end
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