module test();
    reg clock = 0;
    always @* begin
        #20
        clock <= ~clock;
    end

    LedController LedController(.clk(clock));
endmodule