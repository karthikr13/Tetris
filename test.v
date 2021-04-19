`timescale 1 us / 100 ns
module test();

    initial begin
        #1000000
        $finish;
    end
    reg clock = 1;
    reg arduinoClock = 0;
    reg start = 0;
    reg boolean = 0;


    always @* begin
        #10
        clock <= ~clock;
    end

    always @* begin
        #100
        arduinoClock <= ~arduinoClock;
    end

    always @* begin
        if(boolean < 3) begin
            #100
            start <= 1;
            #100
            start <= 0;
            boolean <= boolean + 1;
        end
    end

    parent parent(.arduinoClock(arduinoClock), .clock(clock), .start(start));
endmodule