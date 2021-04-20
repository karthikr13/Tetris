// `timescale 1 us / 100 ns
module parent(
    input arduinoClock,
    input arduinoClock2,
    input clock,
    input start,
    input tempfinished,
    output[7:0] ledOut,
    output[7:0] ledOut2,
    output arduinoStart,
    output arduinoStart2,
    output finishedtest,
    output finishedtest2,
    output startest);

    wire[255:0] values;
    wire finished;
    reg[8:0] counter = 0;
    reg ledstart = 0;
    reg clk = 0;
    reg latch = 0;
    reg enable = 0;
    reg[20:0] timer = 0;
    reg writing = 0;
    reg clk50;

    LedControllerFinal controller(clock, arduinoClock, arduinoClock2, ledstart, values, ledOut, ledOut2, arduinoStart, arduinoStart2, tempfinished, finished, finished2);

    grid_test gridtest(.clk(!clock), .enable(enable), .reset(1'b0), .ctrl1(1'b0), .ctrl2(1'b0), .grid_out(values));
    // integer n;

    always @(posedge clock) begin
        clk50 = ~clk50;
    end
    
    always @(posedge clk50) begin
        if(timer < 500000) begin
            timer <= timer + 1;
        end else begin
            timer <= 0;
        end
        if(timer < 2) begin
            enable <= 1;
        end else if (timer == 2) begin
            ledstart <= 1;
            enable <= 0;
        end else if (timer <500000) begin
            ledstart <= 0;
        end
        // if(timer < 2 && enable == 0 && ledstart == 0 && latch == 0) begin
        //     // $display("Starting...");
        //     enable <= 1;
        //     $display("starting %b, %b, %b", enable, ledstart, start);
        //     // $display("%b", values);      
        // end else begin
        //     if(enable == 1)begin
        //         enable <= 0;
        //         $display("enabled %b %b %b", enable, ledstart, start);
        //         ledstart <= 1;
        //     end else if(ledstart == 1) begin
        //         $display("looping %b %b %b", enable, ledstart, start);
        //         // for(n = 0; n < 16; n = n + 1) begin
        //         //     $display("%d %b %b %b %b %b %b %b %b %b %b %b %b %d %d %d", values[n+0], values[n+16], values[n+32], values[n+48], values[n+64], values[n+80], values[n+96], values[n+112], values[n+128], values[n+144], values[n+160], values[n+176], values[n+192], values[n+208], values[n+224], values[n+240]);
        //         // end     
        //         ledstart <= 0;
        //         latch <= 1;
        //     end else if (latch == 1 && finished) begin
        //         latch <= 0;
        //     end
        // end
        
        // else if (start == 0) begin
        //     ledstart <= 0;
        //     if(finished == 1) begin
        //         latch <= 0;
        //     end
        // end
        
        // $display()
    end

    assign startest = writing;
    assign finishedtest = finished;
endmodule