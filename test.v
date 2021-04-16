module test();
    /*reg clock = 0;
    always @* begin
        #20
        clock <= ~clock;
    end

    LedController LedController(.clk(clock));*/
    wire[3:0] w;
    assign w = 4'b0000;

    initial begin
        #20
        $display(&w);
    end
endmodule