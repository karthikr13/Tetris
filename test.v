`timescale 1 us / 100 ns
module test();

    initial begin
        #10000000
        $finish;
    end
    reg clock = 1;
    always @* begin
        #10
        clock <= ~clock;
    end



    LedController LedController(.clk(clock));

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
    end
endmodule