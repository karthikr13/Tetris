module LedController(
    input clk, 		// System Clock Input 100 Mhz
    output[7:0]  ledOut,	// PWM signal to the audio jack
    input arduinoClock,
    input ready,
    output finished,
    output LED);	// Audio Enable

	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

	////////////////////
	// Your Code Here //
	////////////////////
	reg dividedClock = 0;
    reg clock50mhz = 0;
	reg[20:0] counter = 0;
    reg[15:0] dataCounter = 0;
    reg[15:0] dataCounterMax = 16'd127;
    reg[7:0] color = 0;
    reg[7:0] colorMax = 8'b11111111;
    reg finishedReg = 0;
    reg rgb = 0;
    reg bow = 0;


    always @(posedge arduinoClock) begin
        if(dataCounter < dataCounterMax) begin
            dataCounter <= dataCounter + 1;
        end else begin
            dataCounter <= 0;
        end
        if(color < colorMax) begin
            color <= color + 1;
        end else begin
            color <= 0;
        end
    end

    // always @(ready) begin
    //     finishedReg <= ~finishedReg;
    // end
    

    // wire zeroone;
    // assign zeroone = aaa ? 1'b1 ?: 1'b0; //usually zero or data
    assign ledOut = color;
    assign finished = ready;
    assign LED = ready;
endmodule