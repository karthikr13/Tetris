module LedControllerFinal(
    input clk, 		// System Clock Input 100 Mhz
    input arduinoClock,
    input CTRL_BEGIN, //system signal to begin reading data... sent to arduino?
    input[255:0] data,
    output[7:0]  ledOut,	// PWM signal to the audio jack
    output ready);	// Signal to Arduino to start rendering

    /*
    * Inputs: Clock, arduinoclock, and a ready signal
        On ready signal, the controller will render values on the arduino from a data line.
    */

	// localparam MHz = 1000000;
	// localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

	////////////////////
	// Your Code Here //
	////////////////////
	reg dividedClock = 0;
    reg clock50mhz = 0;
	reg[20:0] counter = 0;
    reg[7:0] color = 0;
    reg[7:0] colorMax = 8'b11111111;

    reg[7:0] dataCounter = 0;
    reg[7:0] dataCounterMax = 8'd127;
    reg[255:0] dataReg = 0;

    reg readyReg = 0;

    always @(posedge arduinoClock) begin
        readyReg <= 0;
        if(dataCounter < dataCounterMax) begin
            dataCounter <= dataCounter + 1;
            color <= dataReg[dataCounter] ? 8'b0 : 8'b11111111;
        end else begin
            dataCounter <= 0;
        end
    end

    always @(CTRL_BEGIN) begin
        dataReg <= data;
        //tell arduino to start
        readyReg <= 1;
    end

    // outputreg <= reg[counter]

    assign ledOut = color;
    assign ready = readyReg;
endmodule