`timescale 1 us / 100 ns
module test();

    initial begin
        #1000000
        $finish;
    end
    reg clock = 1;
    reg arduinoClock = 0;
    reg [1:0] start = 0;
    reg boolean = 0;


    always @* begin
        #10
        clock <= ~clock;
    end

    always @(posedge clock) begin
        arduinoClock <= ~arduinoClock;
    end

    always @(posedge clock) begin
        start <= start + 1;
    end

    // always @* begin
    //     if(boolean < 3) begin
    //         #100
    //         start <= 1;
    //         #100
    //         start <= 0;
    //         boolean <= boolean + 1;
    //     end
    // end

    parent parent(.arduinoClock(arduinoClock), .arduinoClock2(arduinoClock), .clock(clock), .start(start[0]));
endmodule